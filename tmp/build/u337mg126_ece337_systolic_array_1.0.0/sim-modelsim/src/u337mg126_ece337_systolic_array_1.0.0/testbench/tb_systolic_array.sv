`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_systolic_array ();

    localparam CLK_PERIOD = 10; // 100 MHz clock

    logic clk, n_rst, load_weights, run_array;
    logic [63:0] input_vec;
    logic data_out_valid;
    logic [63:0] outputs;
    string testName;

    // Instantiate the DUT
    systolic_array DUT (
        .clk(clk), 
        .n_rst(n_rst), 
        .load_weights(load_weights), 
        .run_array(run_array),
        .input_vec(input_vec), 
        .data_out_valid(data_out_valid), 
        .outputs(outputs)
    );

    // Clock generation
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    // --- HELPER TASKS ---

    task reset_dut;
    begin
        n_rst = 0;
        load_weights = 0;
        run_array = 0;
        input_vec = '0;
        @(negedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
    end
    endtask

    task flush_pipeline;
    begin
        // Reverted back to 24 cycles since max stream is 8 rows
        run_array = 1'b1;
        input_vec = 64'h0000_0000_0000_0000;
        repeat(24) @(negedge clk); 
        run_array = 1'b0;
        @(negedge clk);
    end
    endtask

    task load_ones_weights;
    begin
        load_weights = 1'b1;
        input_vec = 64'h3838_3838_3838_3838; // +1.0 in FP8
        repeat(8) @(negedge clk);
        load_weights = 1'b0;
        input_vec = 64'h0000_0000_0000_0000;
        @(negedge clk);
    end
    endtask

    // --- MAIN TEST SUITE ---

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_systolic_array); 
        
        // TEST 1: The Reset Test
        testName = "Reset test";
        reset_dut();
        repeat(5) @(negedge clk);

        // TEST 2: Standard 8x8 Pulse
        testName = "Standard 8x8 test";
        load_ones_weights();
        run_array = 1'b1;
        input_vec = 64'h3838_3838_3838_3838; 
        repeat(8) @(negedge clk); 
        flush_pipeline();

        // TEST 3: Consecutive Inference Sequences
        testName = "Consecutive Inferences";
        // Inference 1
        run_array = 1'b1;
        input_vec = 64'h3838_3838_3838_3838; 
        repeat(8) @(negedge clk);
        flush_pipeline();
        // Inference 2 (Proves counter reset properly)
        run_array = 1'b1;
        input_vec = 64'h3838_3838_3838_3838; 
        repeat(8) @(negedge clk);
        flush_pipeline();

        // TEST 4: Stall Test
        testName = "Stop mid calculation";
        run_array = 1'b1;
        input_vec = 64'h3838_3838_3838_3838; 
        repeat(4) @(negedge clk); 
        run_array = 1'b0;
        input_vec = 64'h0000_0000_0000_0000;
        repeat(5) @(negedge clk);
        run_array = 1'b1;
        input_vec = 64'h3838_3838_3838_3838; 
        repeat(4) @(negedge clk); 
        flush_pipeline();

        // TEST 5: Zero x Zero Test
        testName = "Zero times zero test";
        load_weights = 1'b1;
        input_vec = 64'h0000_0000_0000_0000; 
        repeat(8) @(negedge clk);
        load_weights = 1'b0;
        @(negedge clk);
        run_array = 1'b1;
        input_vec = 64'h0000_0000_0000_0000; 
        repeat(8) @(negedge clk); 
        flush_pipeline();

        // TEST 6: The Identity Matrix Test
        testName = "Identity matrix test";
        load_weights = 1'b1;
        input_vec = 64'h0000_0000_0000_0038; @(negedge clk);
        input_vec = 64'h0000_0000_0000_3800; @(negedge clk);
        input_vec = 64'h0000_0000_0038_0000; @(negedge clk);
        input_vec = 64'h0000_0000_3800_0000; @(negedge clk);
        input_vec = 64'h0000_0038_0000_0000; @(negedge clk);
        input_vec = 64'h0000_3800_0000_0000; @(negedge clk);
        input_vec = 64'h0038_0000_0000_0000; @(negedge clk);
        input_vec = 64'h3800_0000_0000_0000; @(negedge clk);
        load_weights = 1'b0;
        @(negedge clk);
        run_array = 1'b1;
        input_vec = 64'h3838_3838_3838_3838; 
        repeat(8) @(negedge clk); 
        flush_pipeline();

        // TEST 7: Output Stall
        testName = "Stall during output";
        reset_dut();
        load_ones_weights();
        run_array = 1'b1;
        input_vec = 64'h3838_3838_3838_3838;
        repeat(8) @(negedge clk); 
        input_vec = 64'h0000_0000_0000_0000;
        wait(data_out_valid == 1'b1);
        repeat(2) @(negedge clk);
        run_array = 1'b0;
        repeat(10) @(negedge clk);
        run_array = 1'b1;
        wait(data_out_valid == 1'b0);
        flush_pipeline();
        
        $finish;
    end
endmodule

/* verilator coverage_on */