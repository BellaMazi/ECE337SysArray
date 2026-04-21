`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_bias_adder ();

    localparam CLK_PERIOD = 10;

    logic clk, n_rst, data_out_valid;
    logic [63:0] outputs, bias;
    logic [63:0] bias_out;
    logic bias_valid_out;
    
    // NEW: Error flags for testing
    logic nan_err; 
    logic inf_err;

    bias_adder DUT (
        .clk(clk),
        .n_rst(n_rst),
        .data_out_valid(data_out_valid),
        .outputs(outputs),
        .bias(bias),
        .bias_out(bias_out),
        .bias_valid_out(bias_valid_out),
        .nan_err(nan_err),   // NEW: Wired to DUT
        .inf_err(inf_err)    // NEW: Wired to DUT
    );

    // Clock generation
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        data_out_valid = 0;
        outputs = '0;
        bias = '0;
        @(negedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
    end
    endtask

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_bias_adder); 

        // TEST 1: Reset
        reset_dut();
        repeat(3) @(negedge clk);

        // TEST 2: Basic Addition
        bias = 64'h3838_3838_3838_3838;
        data_out_valid = 1'b1;
        outputs = 64'h5050_5050_5050_5050; 
        repeat(8) @(negedge clk);
        data_out_valid = 1'b0;
        outputs = 64'h0000_0000_0000_0000;
        repeat(5) @(negedge clk);

        // TEST 3: Zero Bias
        bias = 64'h0000_0000_0000_0000; 
        data_out_valid = 1'b1;
        outputs = 64'h5050_5050_5050_5050; 
        repeat(4) @(negedge clk); 
        data_out_valid = 1'b0;
        outputs = 64'h0000_0000_0000_0000;
        repeat(5) @(negedge clk);

        // TEST 4: Pipeline stall
        bias = 64'h3838_3838_3838_3838; 
        data_out_valid = 1'b1;
        outputs = 64'h5050_5050_5050_5050; 
        repeat(2) @(negedge clk); 
        //data valid goes low mid stream
        data_out_valid = 1'b0;
        outputs = 64'h0000_0000_0000_0000;
        @(negedge clk);
        //resume valid data
        data_out_valid = 1'b1;
        outputs = 64'h5050_5050_5050_5050; 
        repeat(2) @(negedge clk);
        data_out_valid = 1'b0;
        repeat(5) @(negedge clk);

        // TEST 5: FP8 errors
        // Sub-Test 5A: Inf error
        bias    = 64'h7070_7070_7070_7070; 
        outputs = 64'h7070_7070_7070_7070; 
        data_out_valid = 1'b1;
        repeat(2) @(negedge clk);
        // Sub-Test 5B: NaN error
        bias    = 64'h7F7F_7F7F_7F7F_7F7F; 
        outputs = 64'h7F7F_7F7F_7F7F_7F7F;
        repeat(2) @(negedge clk);
        data_out_valid = 1'b0;
        outputs = 64'h0000_0000_0000_0000;
        repeat(5) @(negedge clk);

        $display("All tests completed!");
        $finish;
    end
endmodule

/* verilator coverage_on */

