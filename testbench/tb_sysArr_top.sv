`timescale 1ns / 10ps
/* verilator coverage_off */

// =============================================================================
// Top-Level Testbench for sysArr_top (Matrix Multiply Accelerator)
//
// Tests:
//   1. Complete Inference Sequence
//   2. Consecutive Inference Sequences
//   3. Activation Mode Tests (ReLU, Identity, Binary, Leaky ReLU)
//   4. Bias and Accumulation Test
//   5. Error Propagation Test
//   6. Global Pipeline Flush Test
// =============================================================================

module tb_sysArr_top ();

    localparam CLK_PERIOD = 10ns;
    localparam TIMEOUT    = 1000;
    localparam N          = 8;  // array dimension

    localparam HTRANS_IDLE   = 2'b00;
    localparam HTRANS_NONSEQ = 2'b10;

    localparam SIZE_DWORD = 2'b11;

    localparam ADDR_WEIGHT = 10'h000;
    localparam ADDR_INPUT  = 10'h008;
    localparam ADDR_BIAS   = 10'h010;
    localparam ADDR_OUTPUT = 10'h018;
    localparam ADDR_ERROR  = 10'h020;
    localparam ADDR_CTRL   = 10'h022;
    localparam ADDR_STATUS = 10'h023;
    localparam ADDR_ACTIV  = 10'h024;

    localparam CTRL_START_INFERENCE = 64'h1;
    localparam CTRL_LOAD_WEIGHTS    = 64'h2;

    localparam ACT_RELU     = 64'h0;
    localparam ACT_BINARY   = 64'h1;
    localparam ACT_IDENTITY = 64'h2;
    localparam ACT_LEAKY    = 64'h3;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic        clk, n_rst;
    logic        hsel;
    logic [9:0]  haddr;
    logic [1:0]  htrans;
    logic [1:0]  hsize;
    logic        hwrite;
    logic [63:0] hwdata;
    logic [63:0] hrdata;
    logic        hready;
    logic        hresp;

    always begin
        clk = 0; #(CLK_PERIOD / 2.0);
        clk = 1; #(CLK_PERIOD / 2.0);
    end

    sysArr_top DUT (
        .clk(clk), .n_rst(n_rst),
        .hsel(hsel), .haddr(haddr), .htrans(htrans), .hsize(hsize),
        .hwrite(hwrite), .hwdata(hwdata),
        .hrdata(hrdata), .hready(hready), .hresp(hresp)
    );

    // =========================================================================
    // Module-level storage (avoids dynamic array task port issues)
    // =========================================================================
    logic [63:0] result_a  [N];  // output from first inference
    logic [63:0] result_b  [N];  // output from second inference
    logic [63:0] weights_m [N];  // weight vectors
    logic [63:0] inputs_m  [N];  // input vectors

    // =========================================================================
    // Tasks — all use fixed-size arrays via module-level variables
    // =========================================================================
    task reset_dut;
    begin
        n_rst  = 0;
        hsel   = 0;
        haddr  = '0;
        htrans = HTRANS_IDLE;
        hsize  = SIZE_DWORD;
        hwrite = 0;
        hwdata = '0;
        @(posedge clk); @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk); @(posedge clk);
    end
    endtask

    task ahb_write(input logic [9:0]  addr,
                   input logic [1:0]  sz,
                   input logic [63:0] data);
    begin
        @(negedge clk);
        hsel   = 1;
        haddr  = addr;
        hsize  = sz;
        hwrite = 1;
        htrans = HTRANS_NONSEQ;
        hwdata = '0;
        @(posedge clk);
        while (!hready) @(posedge clk);
        @(negedge clk);
        htrans = HTRANS_IDLE;
        hsel   = 0;
        hwrite = 0;
        hwdata = data;
        @(posedge clk);
        while (!hready) @(posedge clk);
        @(negedge clk);
        hwdata = '0;
    end
    endtask

    task ahb_read(input  logic [9:0]  addr,
                  input  logic [1:0]  sz,
                  output logic [63:0] rdata);
    begin
        @(negedge clk);
        hsel   = 1;
        haddr  = addr;
        hsize  = sz;
        hwrite = 0;
        htrans = HTRANS_NONSEQ;
        @(posedge clk);
        while (!hready) @(posedge clk);
        @(negedge clk);
        htrans = HTRANS_IDLE;
        hsel   = 0;
        @(posedge clk);
        while (!hready) @(posedge clk);
        rdata = hrdata;
        @(negedge clk);
    end
    endtask

    task poll_status(input logic [1:0] mask,
                     input logic [1:0] expected_val,
                     input string      ctx);
        logic [63:0] rd;
        logic [1:0] status_bits;
        int iters;
    begin
        for (iters = 0; iters < TIMEOUT; iters++) begin
            ahb_read(ADDR_STATUS, SIZE_DWORD, rd);
            status_bits = rd[25:24] | rd[1:0];
            if ((status_bits & mask) == expected_val) break;
        end
        if (iters >= TIMEOUT)
            $error("TIMEOUT in poll_status: %s", ctx);
    end
    endtask

    // Load N weight vectors from weights_m[] into the accelerator
    task load_weights_task;
    begin
        for (int i = 0; i < N; i++)
            ahb_write(ADDR_WEIGHT, SIZE_DWORD, weights_m[i]);
    end
    endtask

    // Load N input vectors from inputs_m[] into the accelerator
    task load_inputs_task;
    begin
        for (int i = 0; i < N; i++)
            ahb_write(ADDR_INPUT, SIZE_DWORD, inputs_m[i]);
    end
    endtask

    // Read N output vectors into result_a[]
    task read_outputs_a;
        logic [63:0] rd;
    begin
        for (int i = 0; i < N; i++) begin
            ahb_read(ADDR_OUTPUT, SIZE_DWORD, rd);
            result_a[i] = rd;
        end
    end
    endtask

    // Read N output vectors into result_b[]
    task read_outputs_b;
        logic [63:0] rd;
    begin
        for (int i = 0; i < N; i++) begin
            ahb_read(ADDR_OUTPUT, SIZE_DWORD, rd);
            result_b[i] = rd;
        end
    end
    endtask

    // Full inference sequence using weights_m, inputs_m, given bias and act mode
    // Results stored in result_a[]
    task run_inference_a(input logic [63:0] bias_val,
                         input logic [63:0] act_mode);
    begin
        load_weights_task();
        ahb_write(ADDR_ACTIV, SIZE_DWORD, act_mode);
        ahb_write(ADDR_CTRL,  SIZE_DWORD, CTRL_LOAD_WEIGHTS);
        poll_status(2'b10, 2'b00, "weight load");
        ahb_write(ADDR_BIAS, SIZE_DWORD, bias_val);
        load_inputs_task();
        ahb_write(ADDR_CTRL, SIZE_DWORD, CTRL_START_INFERENCE);
        poll_status(2'b10, 2'b00, "not busy");
        read_outputs_a();
    end
    endtask

    // Same but stores results in result_b[]
    task run_inference_b(input logic [63:0] bias_val,
                         input logic [63:0] act_mode);
    begin
        load_weights_task();
        ahb_write(ADDR_ACTIV, SIZE_DWORD, act_mode);
        ahb_write(ADDR_CTRL,  SIZE_DWORD, CTRL_LOAD_WEIGHTS);
        poll_status(2'b10, 2'b00, "weight load");
        ahb_write(ADDR_BIAS, SIZE_DWORD, bias_val);
        load_inputs_task();
        ahb_write(ADDR_CTRL, SIZE_DWORD, CTRL_START_INFERENCE);
        poll_status(2'b10, 2'b00, "not busy");
        read_outputs_b();
    end
    endtask

    task check_output(input string name, input logic cond);
    begin
        if (cond) $display("PASS: %s", name);
        else      $display("FAIL: %s", name);
    end
    endtask

    // =========================================================================
    // Test data initialisation
    // =========================================================================
    logic [63:0] rdata;
    logic        all_zero;
    logic        bias_affected;

    initial begin
        reset_dut();

        // Zero weights / inputs
        for (int i = 0; i < N; i++) begin
            weights_m[i] = 64'h0;
            inputs_m[i]  = 64'h0;
        end

        // Simple non-zero inputs: each vector filled with byte value (i+1)
        for (int i = 0; i < N; i++)
            inputs_m[i] = {8{8'(i + 1)}};

        // =================================================================
        // TEST 1: COMPLETE INFERENCE SEQUENCE
        // Zero weights → output must be 0 regardless of inputs
        // =================================================================
        $display("\n===== TEST 1: COMPLETE INFERENCE SEQUENCE =====");

        run_inference_a(64'h0, ACT_IDENTITY);

        all_zero = 1;
        for (int i = 0; i < N; i++)
            if (result_a[i] !== 64'h0) all_zero = 0;
        check_output("1.1 zero weights → zero outputs", all_zero);
        check_output("1.2 no bus error during inference",  hresp == 1'b0);
        @(negedge clk);
        check_output("1.3 hready high after inference",   hready == 1'b1);

        // =================================================================
        // TEST 2: CONSECUTIVE INFERENCE SEQUENCES
        // Two back-to-back inferences — state must reset cleanly between them
        // =================================================================
        $display("\n===== TEST 2: CONSECUTIVE INFERENCE SEQUENCES =====");

        run_inference_a(64'h0,  ACT_IDENTITY);
        run_inference_b(64'hFF, ACT_IDENTITY);

        check_output("2.1 first inference completes",  hresp == 1'b0);
        check_output("2.2 second inference completes", hresp == 1'b0);

        // With zero weights both should produce same base (zero) before bias;
        // result_b used a non-zero bias so it may differ from result_a
        check_output("2.3 no error on consecutive inferences", hresp == 1'b0);

        // =================================================================
        // TEST 3: ACTIVATION MODE TESTS
        // Each mode is written to ADDR_ACTIV; a full inference is run to
        // exercise the activation pipeline end-to-end.
        // =================================================================
        $display("\n===== TEST 3: ACTIVATION MODE TESTS =====");

        // 3.1 ReLU
        $display("--- 3.1 ReLU ---");
        run_inference_a(64'h0, ACT_RELU);
        check_output("3.1 ReLU: inference completes without error", hresp == 1'b0);

        // 3.2 Identity
        $display("--- 3.2 Identity ---");
        run_inference_a(64'h0, ACT_IDENTITY);
        check_output("3.2 Identity: inference completes without error", hresp == 1'b0);

        // 3.3 Binary
        $display("--- 3.3 Binary ---");
        run_inference_a(64'h0, ACT_BINARY);
        check_output("3.3 Binary: inference completes without error", hresp == 1'b0);

        // 3.4 Leaky ReLU
        $display("--- 3.4 Leaky ReLU ---");
        run_inference_a(64'h0, ACT_LEAKY);
        check_output("3.4 Leaky ReLU: inference completes without error", hresp == 1'b0);

        // =================================================================
        // TEST 4: BIAS AND ACCUMULATION TEST
        // Non-zero bias should produce different output than zero bias
        // =================================================================
        $display("\n===== TEST 4: BIAS AND ACCUMULATION TEST =====");

        ahb_write(ADDR_BIAS, SIZE_DWORD, 64'hAABBCCDD_11223344);
        repeat(2) @(posedge clk);
        check_output("4.1 bias write accepted (no hresp)", hresp == 1'b0);

        ahb_read(ADDR_BIAS, SIZE_DWORD, rdata);
        check_output("4.2 bias read-back correct",
                     rdata == 64'hAABBCCDD_11223344);

        // Run with non-zero bias → result_a
        run_inference_a(64'hAABBCCDD_11223344, ACT_IDENTITY);
        check_output("4.3 inference with non-zero bias completes", hresp == 1'b0);

        // Run with zero bias → result_b
        run_inference_b(64'h0, ACT_IDENTITY);

        bias_affected = 0;
        for (int i = 0; i < N; i++)
            if (result_a[i] !== result_b[i]) bias_affected = 1;
        check_output("4.4 non-zero bias produces different output than zero bias",
                     bias_affected);

        // =================================================================
        // TEST 5: ERROR PROPAGATION TEST
        // Illegal AHB transactions must produce hresp=1; bus must recover
        // =================================================================
        $display("\n===== TEST 5: ERROR PROPAGATION TEST =====");

        // 5.1 Write to read-only output register (0x18)
        @(negedge clk);
        hsel   = 1; haddr = ADDR_OUTPUT; hsize = SIZE_DWORD;
        hwrite = 1; htrans = HTRANS_NONSEQ; hwdata = '0;
        @(posedge clk);
        while (!hready && !hresp) @(posedge clk);
        @(negedge clk);
        htrans = HTRANS_IDLE; hsel = 0; hwrite = 0;
        hwdata = 64'hBADC0FFE_EBADC0FF;
        @(posedge clk); @(negedge clk);
        check_output("5.1 write to RO output reg: hresp asserted", hresp == 1'b1);
        hwdata = '0;
        repeat(6) @(posedge clk);

        // 5.2 Write to invalid address
        @(negedge clk);
        hsel   = 1; haddr = 10'h3FF; hsize = SIZE_DWORD;
        hwrite = 1; htrans = HTRANS_NONSEQ; hwdata = '0;
        @(posedge clk);
        while (!hready && !hresp) @(posedge clk);
        @(negedge clk);
        htrans = HTRANS_IDLE; hsel = 0; hwrite = 0;
        hwdata = 64'hDEAD_DEAD_DEAD_DEAD;
        @(posedge clk); @(negedge clk);
        check_output("5.2 write to invalid addr: hresp asserted", hresp == 1'b1);
        hwdata = '0;
        repeat(6) @(posedge clk);

        // 5.3 Bus recovers — valid write succeeds after error
        ahb_write(ADDR_BIAS, SIZE_DWORD, 64'h1234_5678_9ABC_DEF0);
        check_output("5.3 bus recovers: valid write after error",  hresp == 1'b0);
        ahb_read(ADDR_BIAS, SIZE_DWORD, rdata);
        check_output("5.4 bias correct after error recovery",
                     rdata == 64'h1234_5678_9ABC_DEF0);

        // 5.5 Error register is readable without generating another error
        ahb_read(ADDR_ERROR, SIZE_DWORD, rdata);
        check_output("5.5 error register readable", hresp == 1'b0);

        // =================================================================
        // TEST 6: GLOBAL PIPELINE FLUSH TEST
        // Assert reset mid-operation; verify clean idle state afterwards
        // =================================================================
        $display("\n===== TEST 6: GLOBAL PIPELINE FLUSH TEST =====");

        // Begin a weight load then reset mid-operation
        ahb_write(ADDR_WEIGHT, SIZE_DWORD, 64'hDEAD_BEEF_CAFE_BABE);
        ahb_write(ADDR_CTRL,   SIZE_DWORD, CTRL_LOAD_WEIGHTS);
        repeat(3) @(posedge clk);

        // Assert reset
        @(negedge clk);
        n_rst  = 0;
        hsel   = 0;
        htrans = HTRANS_IDLE;
        hwrite = 0;
        hwdata = '0;
        @(posedge clk); @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk); @(posedge clk);

        // 6.1 hready high after reset
        @(negedge clk);
        check_output("6.1 hready=1 after reset", hready == 1'b1);

        // 6.2 hresp low after reset
        check_output("6.2 hresp=0 after reset",  hresp  == 1'b0);

        // 6.3 Bias cleared to 0
        ahb_read(ADDR_BIAS, SIZE_DWORD, rdata);
        check_output("6.3 bias cleared after reset", rdata == 64'h0);

        // 6.4 Status idle after reset
        ahb_read(ADDR_STATUS, SIZE_DWORD, rdata);
        check_output("6.4 status idle after reset", rdata[1:0] == 2'b00);

        // 6.5 Full inference succeeds after flush
        run_inference_a(64'h0, ACT_IDENTITY);
        check_output("6.5 full inference succeeds after pipeline flush",
                     hresp == 1'b0);

        $display("\n===== ALL TESTS COMPLETE =====");
        $finish;
    end

endmodule
/* verilator coverage_on */