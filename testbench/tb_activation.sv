`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_activation ();

    localparam CLK_PERIOD = 10;
    logic clk, n_rst, bias_valid_out;
    logic [2:0] active_mode;
    logic [63:0] bias_out;
    logic inference_complete;
    logic [63:0] activations;
    activation DUT (
        .clk(clk),
        .n_rst(n_rst),
        .bias_valid_out(bias_valid_out),
        .active_mode(active_mode),
        .bias_out(bias_out),
        .inference_complete(inference_complete),
        .activations(activations)
    );
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end
    task reset_dut;
    begin
        n_rst = 0;
        bias_valid_out = 0;
        active_mode = 3'd0;
        bias_out = '0;
        @(negedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
    end
    endtask
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_activation); 

        //TEST 1: Reset Behavior
        reset_dut();
        repeat(3) @(negedge clk);

        //THE STRESS VECTOR
        bias_out = 64'hFF7F_8000_F090_B838;
        bias_valid_out = 1'b1;

        //TEST 2: ReLu
        active_mode = 3'd0; 
        repeat(2) @(negedge clk); 
        //expected output: 64'h007F_0000_0000_0038

        //TEST 3: Binary
        active_mode = 3'd1; 
        repeat(2) @(negedge clk);
        //expected output: 64'hb838_b838_b8b8_b838

        // TEST 4: Mode 2 - Identity
        active_mode = 3'd2; 
        repeat(2) @(negedge clk);
        //expected output: 64'hFF7F_8000_F090_B838

        // TEST 5: Mode 3 - Leaky ReLU
        active_mode = 3'd3; 
        repeat(2) @(negedge clk);
        //expected output: 64'hFF7F_0000_F000_A838

        // TEST 6: Default mode test
        active_mode = 3'd5;
        repeat(2) @(negedge clk);
        //expected output: 64'hFF7F_8000_F090_B838

        // TEST 7: Stall & Bubble Logic
        active_mode = 3'd0;
        //pipeline stall
        bias_valid_out = 1'b0;
        bias_out = 64'hFFFF_FFFF_FFFF_FFFF;
        @(negedge clk);
        //resume valid data
        bias_valid_out = 1'b1;
        bias_out = 64'hFF7F_8000_F090_B838;
        repeat(2) @(negedge clk);
        bias_valid_out = 1'b0;
        repeat(5) @(negedge clk);

        $display("All tests completed!");
        $finish;
    end
endmodule

/* verilator coverage_on */

