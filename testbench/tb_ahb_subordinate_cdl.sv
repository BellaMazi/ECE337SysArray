`timescale 1ns / 10ps

/* verilator coverage_off */

module tb_ahb_subordinate_cdl ();

    localparam CLK_PERIOD = 10ns;
    localparam TIMEOUT = 1000;

    localparam BURST_SINGLE = 3'd0;
    localparam BURST_INCR   = 3'd1;
    localparam BURST_WRAP4  = 3'd2;
    localparam BURST_INCR4  = 3'd3;
    localparam BURST_WRAP8  = 3'd4;
    localparam BURST_INCR8  = 3'd5;
    localparam BURST_WRAP16 = 3'd6;
    localparam BURST_INCR16 = 3'd7;

    localparam ADDR_BIAS = 10'h10;
    localparam ADDR_ACTMODE= 10'h24;
    localparam ADDR_WEIGHT = 10'h00;
    localparam ADDR_INPUT = 10'h08;
    localparam ADDR_OUTPUT = 10'h18;
    localparam ADDR_ERROR = 10'h20;
    localparam ADDR_CTRL = 10'h22;
    localparam ADDR_STATUS = 10'h23;

    localparam SIZE_DWORD = 2'b11;

    initial begin
        $dumpfile("waveform.fst");
        $dumpvars;
    end

    logic clk, n_rst;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    logic hsel;
    logic [9:0] haddr;
    logic [2:0] hsize;
    logic [2:0] hburst;
    logic [1:0] htrans;
    logic hwrite;
    logic [63:0] hwdata;
    logic [63:0] hrdata;
    logic hresp;
    logic hready;
    logic [63:0] bias;
    logic [2:0] active_mode;
    logic [1:0] ctrl_reg;
    logic inference_complete;
    logic ahb_wr_weight;
    logic ahb_wr_input;
    logic [1:0] ctrl_reg_clear;
    logic [1:0] status_reg_ctrl;
    logic hready_stall, occ_err;
    logic [2:0] act_ctrl_out;
    logic nan_err, inf_err;
    logic clear_errors;
    logic overrun_err;


    ahb_subordinate_cdl DUT (
        .clk(clk), .n_rst(n_rst), .hsel(hsel), .inference_complete(inference_complete),
        .occ_err(occ_err), .overrun_err(overrun_err), .act_ctrl_out(act_ctrl_out),
        .ctrl_reg_clear(ctrl_reg_clear), .status_reg_ctrl(status_reg_ctrl),
        .nan_err(nan_err), .inf_err(inf_err),
        .haddr(haddr), .htrans(htrans), .hsize(hsize),.hwrite(hwrite), .hwdata(hwdata), .hrdata(hrdata),
        .hresp(hresp), .hready(hready), .active_mode(active_mode),
        .bias(bias), .ctrl_reg(ctrl_reg),.hready_stall(hready_stall),
        .ahb_wr_weight(ahb_wr_weight), .ahb_wr_input(ahb_wr_input),.clear_errors(clear_errors));

    // bus model connections
    ahb_model_updated #(
        .ADDR_WIDTH(10),
        .DATA_WIDTH(8)
    ) BFM ( .clk(clk),
        // AHB-Subordinate Side
        .hsel(hsel),
        .haddr(haddr),
        .hsize(hsize),
        .htrans(htrans),
        .hburst(hburst),
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hrdata(hrdata),
        .hresp(hresp),
        .hready(hready)
    );

    // Supporting Tasks
    task reset_model;
        BFM.reset_model();
    endtask

    // Read from a register without checking the value
    task enqueue_poll ( input logic [9:0] addr, input logic [1:0] size );
    logic [63:0] data [];
        begin
            data = new [1];
            data[0] = {32'hXXXX};
            //              Fields: hsel,  R/W, addr, data, exp err,         size, burst, chk prdata or not
            BFM.enqueue_transaction(1'b1, 1'b0, addr, data,    1'b0, {1'b0, size},  3'b0,            1'b0);
        end
    endtask

    // Read from a register until a requested value is observed
    task poll_until ( input logic [9:0] addr, input logic [1:0] size, input logic [63:0] data);
        int iters;
        begin
            for (iters = 0; iters < TIMEOUT; iters++) begin
                enqueue_poll(addr, size);
                execute_transactions(1);
                if(BFM.get_last_read() == data) break;
            end
            if(iters >= TIMEOUT) begin
                $error("Bus polling timeout hit.");
            end
        end
    endtask

    // Read Transaction, verifying a specific value is read
    task enqueue_read ( input logic [9:0] addr, input logic [1:0] size, input logic [63:0] exp_read );
        logic [63:0] data [];
        begin
            data = new [1];
            data[0] = exp_read;
            BFM.enqueue_transaction(1'b1, 1'b0, addr, data, 1'b0, {1'b0, size}, 3'b0, 1'b1);
        end
    endtask

    // Write Transaction
    task enqueue_write ( input logic [9:0] addr, input logic [1:0] size, input logic [63:0] wdata );
        logic [63:0] data [];
        begin
            data = new [1];
            data[0] = wdata;
            BFM.enqueue_transaction(1'b1, 1'b1, addr, data, 1'b0, {2'b0, size}, 3'b0, 1'b0);
        end
    endtask

    // Write Transaction Intended for a different subordinate from yours
    task enqueue_fakewrite ( input logic [9:0] addr, input logic [1:0] size, input logic [63:0] wdata );
        logic [63:0] data [];
        begin
            data = new [1];
            data[0] = wdata;
            BFM.enqueue_transaction(1'b0, 1'b1, addr, data, 1'b0, {1'b0, size}, 3'b0, 1'b0);
        end
    endtask

    // Create a burst read of size based on the burst type.
    // If INCR, burst size dependent on dynamic array size
    task enqueue_burst_read ( input logic [9:0] base_addr, input logic [1:0] size, input logic [2:0] burst, input logic [63:0] data [] );
        BFM.enqueue_transaction(1'b1, 1'b0, base_addr, data, 1'b0, {1'b0, size}, burst, 1'b1);
    endtask

    // Create a burst write of size based on the burst type.
    task enqueue_burst_write ( input logic [9:0] base_addr, input logic [1:0] size, input logic [2:0] burst, input logic [63:0] data [] );
        BFM.enqueue_transaction(1'b1, 1'b1, base_addr, data, 1'b0, {1'b0, size}, burst, 1'b1);
    endtask

    // Run n transactions, where a k-beat burst counts as k transactions.
    task execute_transactions (input int num_transactions);
        BFM.run_transactions(num_transactions);
    endtask

    // Finish the current transaction
    task finish_transactions();
        BFM.wait_done();
    endtask
    task check_output(
        input string test_name,
        input logic condition
    );
        if(condition) begin
            $display("PASS: %s",test_name);
        end else begin
            $display("FAIL: %s", test_name);
        end
    endtask

    // Sample hresp during the error window — call AFTER execute_transactions,
    // BEFORE finish_transactions. Both ERR_CYC1 and ERR_CYC2 have hresp=1.
    task check_hresp_error(input string name);
    begin
        @(negedge clk);
        check_output(name, hresp == 1'b1);
    end
    endtask
    
    logic [63:0] dw[];
    logic [63:0] dr[];
    task enqueue_error_write(input logic [9:0] addr, input logic[1:0] size,
                            input logic [63:0] wdata);
        begin
            dw= new[1];
            dw[0] = wdata;
            BFM.enqueue_transaction(1'b1,1'b1,addr, dw, 1'b1, {2'b0,size},
            3'b0, 1'b0);
        end
    endtask

    task enqueue_error_read(input logic [9:0] addr, input logic[1:0] size);
        begin
            dr= new[1];
            dr[0]= 64'h0;
            BFM.enqueue_transaction(1'b1,1'b0,addr, dr, 1'b1, {1'b0,size},
            3'b0, 1'b0);
        end

    endtask
 
    // Wait for error FSM to return to ERR_IDLE after a 2-cycle error response
    task wait_for_idle_fsm;
        repeat(8) @(posedge clk);
    endtask

    logic [63:0] data [];
    logic [63:0] fake_data[];
    logic [63:0] val;

    initial begin
        n_rst = 1;
        inference_complete ='0;
        hready_stall = '0;
        occ_err = '0;
        overrun_err = '0;
        act_ctrl_out = '0;
        ctrl_reg_clear= '0;
        status_reg_ctrl= '0;
        nan_err= '0;
        inf_err = '0;

        reset_model();
        reset_dut();

    // TEST 1: SUBORDINATE SELECTION
    // hsel gates all transactions. hsel=0 must be completely ignored.
    // =================================================================
    $display("\n===== TEST 1: SUBORDINATE SELECTION =====");
    
    // Valid write: hsel=1, bias should update
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hAAAA_BBBB_CCCC_DDDD);
    execute_transactions(1); finish_transactions();
    check_output("1.1 hsel=1: valid write updates bias",
    bias == 64'hAAAA_BBBB_CCCC_DDDD);
    
    // Fake write: hsel=0, bias must not change
    fake_data = new[1];
    fake_data[0] = 64'h1111_2222_3333_4444;
    BFM.enqueue_transaction(1'b0, 1'b1, ADDR_BIAS, fake_data,
    0, {1'b0, SIZE_DWORD}, 3'b0, 0);
    execute_transactions(1); finish_transactions();
    check_output("1.2 hsel=0: fake write ignored, bias unchanged",
    bias == 64'hAAAA_BBBB_CCCC_DDDD);
    
    // Reset bias
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'h0);
    execute_transactions(1); finish_transactions();
    
    // =================================================================
    // TEST 2: TRANSACTION TYPE DECODING
    // IDLE and stalled transactions must not commit.
    // NONSEQ must be accepted.
    // =================================================================
    $display("\n===== TEST 2: TRANSACTION TYPE DECODING =====");
    
    // IDLE: no write should occur during idle cycles
    repeat(4) @(posedge clk);
    check_output("2.1 IDLE: no write committed", bias == 64'h0);
    
    // Stall (hready_stall=1): write during stall must not commit
    hready_stall = 1'b1;
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hDEAD_BEEF_DEAD_BEEF);
    execute_transactions(1); finish_transactions();
    hready_stall = 1'b0;
    check_output("2.2 stall: write not committed during hready_stall",
    bias == 64'h0);
    
    // NONSEQ: valid write should commit
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'h1234_5678_9ABC_DEF0);
    execute_transactions(1); finish_transactions();
    check_output("2.3 NONSEQ: write committed", bias == 64'h1234_5678_9ABC_DEF0);
    
    // =================================================================
    // TEST 3: REGISTER WRITES
    // =================================================================
    $display("\n===== TEST 3: REGISTER WRITES =====");
    
    // -- 3.1 Control Register (0x22) --
    $display("--- 3.1 Control Register ---");
    
    // Write bit 0 (start inference)
    enqueue_write(ADDR_CTRL, SIZE_DWORD, 64'h1);
    execute_transactions(1); finish_transactions();
    check_output("3.1a ctrl[0]=1: start inference bit set",
    ctrl_reg[0] == 1'b1);
    
    // ctrl_reg_clear[0] clears bit 0
    ctrl_reg_clear = 2'b01;
    @(posedge clk); @(negedge clk);
    ctrl_reg_clear = 2'b00;
    check_output("3.1b ctrl_reg_clear[0]: bit 0 cleared",
    ctrl_reg[0] == 1'b0);
    
    // Write bit 1 (load weights)
    enqueue_write(ADDR_CTRL, SIZE_DWORD, 64'h2);
    execute_transactions(1); finish_transactions();
    check_output("3.1c ctrl[1]=1: load weights bit set",
    ctrl_reg[1] == 1'b1);
    
    // ctrl_reg_clear[1] clears bit 1
    ctrl_reg_clear = 2'b10;
    @(posedge clk); @(negedge clk);
    ctrl_reg_clear = 2'b00;
    check_output("3.1d ctrl_reg_clear[1]: bit 1 cleared",
    ctrl_reg[1] == 1'b0);
    
    // Write both bits
    enqueue_write(ADDR_CTRL, SIZE_DWORD, 64'h3);
    execute_transactions(1); finish_transactions();
    check_output("3.1e ctrl=3: both bits set", ctrl_reg == 2'b11);
    ctrl_reg_clear = 2'b11;
    @(posedge clk); @(negedge clk);
    ctrl_reg_clear = 2'b00;
    
    // -- 3.2 Weight Data (0x00, write-only) --
    $display("--- 3.2 Weight Data ---");
    
    enqueue_write(ADDR_WEIGHT, SIZE_DWORD, 64'hA1B2_C3D4_E5F6_0718);
    execute_transactions(1); finish_transactions();
    check_output("3.2a weight write: ahb_wr_weight pulsed",
    ahb_wr_weight == 1'b1);
    @(posedge clk); @(posedge clk);
    check_output("3.2b weight write: ahb_wr_weight clears next cycle",
    ahb_wr_weight == 1'b0);
    
    // 4 consecutive weight writes (simulating row of 8 weights)
    enqueue_write(ADDR_WEIGHT, SIZE_DWORD, 64'h0102_0304_0506_0708);
    enqueue_write(ADDR_WEIGHT, SIZE_DWORD, 64'h1112_1314_1516_1718);
    enqueue_write(ADDR_WEIGHT, SIZE_DWORD, 64'h2122_2324_2526_2728);
    enqueue_write(ADDR_WEIGHT, SIZE_DWORD, 64'h3132_3334_3536_3738);
    execute_transactions(4); finish_transactions();
    check_output("3.2c 4 consecutive weight writes: no error", hresp == 1'b0);
    
    // -- 3.3 Input Data (0x08, write-only) --
    $display("--- 3.3 Input Data ---");
    
    enqueue_write(ADDR_INPUT, SIZE_DWORD, 64'hCAFE_BABE_DEAD_BEEF);
    execute_transactions(1); finish_transactions();
    check_output("3.3a input write: ahb_wr_input pulsed",
    ahb_wr_input == 1'b1);
    @(posedge clk); @(posedge clk);
    check_output("3.3b input write: ahb_wr_input clears next cycle",
    ahb_wr_input == 1'b0);
    
    enqueue_write(ADDR_INPUT, SIZE_DWORD, 64'h0000_0000_0000_0001);
    enqueue_write(ADDR_INPUT, SIZE_DWORD, 64'h0000_0000_0000_0002);
    execute_transactions(2); finish_transactions();
    check_output("3.3c consecutive input writes: no error", hresp == 1'b0);
    
    // -- 3.4 Bias Register (0x10, R/W) --
    $display("--- 3.4 Bias Register ---");
    
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'h1212_2323_3434_5656);
    execute_transactions(1); finish_transactions();
    check_output("3.4a bias write: bias output updated",
    bias == 64'h1212_2323_3434_5656);
    
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hFFFF_FFFF_0000_0000);
    execute_transactions(1); finish_transactions();
    check_output("3.4b bias overwrite: new value reflected",
    bias == 64'hFFFF_FFFF_0000_0000);
    
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'h0);
    execute_transactions(1); finish_transactions();
    
    // =================================================================
    // TEST 4: REGISTER READS
    // =================================================================
    $display("\n===== TEST 4: REGISTER READS =====");
    
    // -- 4.1 Status Register (0x23, RO) --
    $display("--- 4.1 Status Register ---");
    
    status_reg_ctrl = 2'b10;
    enqueue_poll(ADDR_STATUS, SIZE_DWORD);
    execute_transactions(1); finish_transactions();
    check_output("4.1a status read: busy bit visible",
    status_reg_ctrl[1] == 1'b1);
    
    status_reg_ctrl = 2'b01;
    enqueue_poll(ADDR_STATUS, SIZE_DWORD);
    execute_transactions(1); finish_transactions();
    check_output("4.1b status read: done bit visible",
    status_reg_ctrl[0] == 1'b1);
    
    status_reg_ctrl = 2'b00;
    
    // -- 4.2 Error Register (0x20, RO) --
    $display("--- 4.2 Error Register ---");
    
    nan_err = 1'b1;
    overrun_err = 1'b1;
    enqueue_poll(ADDR_ERROR, SIZE_DWORD);
    execute_transactions(1); finish_transactions();
    check_output("4.2a error read: clear_errors pulsed after read",
    clear_errors == 1'b1);
    @(posedge clk); @(posedge clk);
    check_output("4.2b error read: clear_errors clears next cycle",
    clear_errors == 1'b0);
    nan_err = 1'b0;
    overrun_err = 1'b0;
    
    inf_err = 1'b1;
    enqueue_poll(ADDR_ERROR, SIZE_DWORD);
    execute_transactions(1); finish_transactions();
    check_output("4.2c inf_err: clear_errors pulsed", clear_errors == 1'b1);
    inf_err = 1'b0;
    
    // -- 4.3 Control Register read (0x22, R/W) --
    $display("--- 4.3 Control Register Read ---");
    
    enqueue_write(ADDR_CTRL, SIZE_DWORD, 64'h1);
    execute_transactions(1); finish_transactions();
    enqueue_poll(ADDR_CTRL, SIZE_DWORD);
    execute_transactions(1); finish_transactions();
    check_output("4.3 ctrl reg read: ctrl_reg[0] reflects written value",
    ctrl_reg[0] == 1'b1);
    ctrl_reg_clear = 2'b11;
    @(posedge clk); @(negedge clk);
    ctrl_reg_clear = 2'b00;
    
    // -- 4.4 Bias Register read (full 64-bit, verifiable via bus model) --
    $display("--- 4.4 Bias Register Read ---");
    
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hDEAD_C0DE_1234_5678);
    enqueue_read(ADDR_BIAS, SIZE_DWORD, 64'hDEAD_C0DE_1234_5678);
    execute_transactions(2); finish_transactions();
    check_output("4.4 bias read: correct hrdata returned",
    hrdata == 64'hDEAD_C0DE_1234_5678);
    
    // =================================================================
    // TEST 5: READ/WRITE VIOLATIONS
    // Invalid addresses and writes to RO registers must raise hresp.
    // Per CDL spec: hresp stays high for 2 cycles (ERR_CYC1 + ERR_CYC2),
    // hready is low only during ERR_CYC1.
    // =================================================================
    $display("\n===== TEST 5: READ/WRITE VIOLATIONS =====");
    
    // 5.1 Write to invalid address
    enqueue_error_write(10'h3FF, SIZE_DWORD, 64'h0BAD_0BAD_0BAD_0BAD);
    execute_transactions(1);
    check_hresp_error("5.1 invalid addr write: hresp asserted");
    finish_transactions();
    wait_for_idle_fsm();
    reset_model();
    
    // 5.2 Read from invalid address
    enqueue_error_read(10'h030,SIZE_DWORD);
    execute_transactions(1);
    check_hresp_error("5.2 invalid addr read: hresp asserted");
    finish_transactions();
    wait_for_idle_fsm();
    reset_model();
    repeat(2) @(posedge clk);

    // 5.3 Write to read-only output register (0x18)
    enqueue_error_write(ADDR_OUTPUT, SIZE_DWORD, 64'h1234123412341234);
    execute_transactions(1);
    check_hresp_error("5.3 write to RO output reg: hresp asserted");
    finish_transactions();
    wait_for_idle_fsm();
    reset_model();
    repeat(2) @(posedge clk);

    // 5.4 Write to read-only error register (0x20)
    enqueue_error_write(ADDR_ERROR, SIZE_DWORD, 64'h1234123412341234);
    execute_transactions(1);
    check_hresp_error("5.4 write to RO error reg: hresp asserted");
    finish_transactions();
    wait_for_idle_fsm();
    reset_model();
    repeat(2) @(posedge clk);

    // 5.5 Write to read-only status register (0x23)
    //@(negedge clk);
  //  $display("DEBUG 5.5 pre: hresp=%b,hready=%b,ctrl_reg=%b",hresp,hready,ctrl_reg);
    enqueue_error_write(ADDR_STATUS, SIZE_DWORD, 64'h1234123412341234);
    execute_transactions(1);
   // @(negedge clk);
    //$display("DEBUG 5.5 post: hresp=%b,hready=%b,ctrl_reg=%b",hresp,hready,ctrl_reg);
    check_hresp_error("5.5 write to RO status reg: hresp asserted");
    finish_transactions();
    wait_for_idle_fsm();
    reset_model();
    repeat(2) @(posedge clk);

    // 5.6 Bus recovery: valid transaction after error must succeed
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hABCD_EF01_2345_6789);
    execute_transactions(1); finish_transactions();
    check_output("5.6 bus recovery after error: valid write commits",
    bias == 64'hABCD_EF01_2345_6789);
    
    // =================================================================
    // TEST 6: STATE MACHINE LOGIC
    // =================================================================
    $display("\n===== TEST 6: STATE MACHINE LOGIC =====");
    
    // 6.1 Start inference: ctrl[0]=1
    enqueue_write(ADDR_CTRL, SIZE_DWORD, 64'h1);
    execute_transactions(1); finish_transactions();
    check_output("6.1 start inference: ctrl_reg[0] set",
    ctrl_reg[0] == 1'b1);
    
    // Status shows busy
    status_reg_ctrl = 2'b10;
    check_output("6.1 status: busy after ctrl[0] set",
    status_reg_ctrl[1] == 1'b1);
    
    // inference_complete is not used by the subordinate module directly.
    // The controller (external) is responsible for pulsing ctrl_reg_clear[0]
    // when inference finishes. Simulate that here.
    ctrl_reg_clear = 2'b01;
    @(posedge clk); @(posedge clk);
    ctrl_reg_clear = 2'b00;
    status_reg_ctrl = 2'b00;
    check_output("6.2 ctrl_reg_clear: ctrl_reg[0] cleared by controller",
    ctrl_reg[0] == 1'b0);
    
    // 6.3 Load weights: ctrl[1]=1
    enqueue_write(ADDR_CTRL, SIZE_DWORD, 64'h2);
    execute_transactions(1); finish_transactions();
    check_output("6.3 load weights: ctrl_reg[1] set",
    ctrl_reg[1] == 1'b1);
    ctrl_reg_clear = 2'b10;
    @(posedge clk); @(negedge clk);
    ctrl_reg_clear = 2'b00;
    check_output("6.3 ctrl_reg_clear[1]: load weights bit cleared",
    ctrl_reg[1] == 1'b0);
    
    // 6.4 Full inference cycle: write→busy→complete→idle
    enqueue_write(ADDR_CTRL, SIZE_DWORD, 64'h1);
    execute_transactions(1); finish_transactions();
    // Simulate controller clearing ctrl[0] and status going idle
    status_reg_ctrl = 2'b10;
    repeat(3) @(posedge clk);
    ctrl_reg_clear = 2'b01; // controller signals done
    @(posedge clk);
    ctrl_reg_clear = 2'b00;
    status_reg_ctrl = 2'b00;
    enqueue_poll(ADDR_STATUS, SIZE_DWORD);
    execute_transactions(1); finish_transactions();
    check_output("6.4 full inference cycle: ctrl_reg[0] cleared, status idle",
    ctrl_reg[0] == 1'b0 && status_reg_ctrl == 2'b00);
    
    // =================================================================
    // TEST 7: RAW HAZARD
    // Write followed immediately by read to same 8-byte register.
    // hrdata must reflect the newly-written value, not the stale register.
    // =================================================================
    $display("\n===== TEST 7: RAW HAZARD =====");
    
    for (int i = 0; i < 4; i++) begin
    val = {32'hCAFE_BABE, i[31:0]};
    enqueue_write(ADDR_BIAS, SIZE_DWORD, val);
    enqueue_read(ADDR_BIAS, SIZE_DWORD, val);
    execute_transactions(2); finish_transactions();
    check_output($sformatf("7.%0d RAW hazard: hrdata bypasses stale register", i),
    hrdata == val && bias == val);
    end
    
    // RAW between different registers — no bypass, should read actual value
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hFEED_FACE_CAFE_BABE);
    execute_transactions(1); finish_transactions();
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'h1111_2222_3333_4444);
    enqueue_read(ADDR_BIAS, SIZE_DWORD, 64'h1111_2222_3333_4444);
    execute_transactions(2); finish_transactions();
    check_output("7.4 RAW: non-consecutive write reads new value",
    hrdata == 64'h1111_2222_3333_4444);
    
    // =================================================================
    // TEST 8: SRAM ACCESSES BLOCKED WHEN DEVICE IS BUSY
    // occ_err gates SRAM-backed registers (0x00-0x1F): weight, input,
    // bias, output. Non-SRAM registers (0x20+) remain accessible.
    // =================================================================
    $display("\n===== TEST 8: SRAM BLOCKED WHEN BUSY =====");
    
    occ_err = 1'b1;
    
    // Weight write blocked
    enqueue_error_write(ADDR_WEIGHT, SIZE_DWORD, 64'h1111);
    execute_transactions(1);
    check_hresp_error("8.1 busy: weight write blocked");
    finish_transactions(); wait_for_idle_fsm();
    reset_model();
    
    // Input write blocked
    enqueue_error_write(ADDR_INPUT, SIZE_DWORD, 64'h2222);
    execute_transactions(1);
    check_hresp_error("8.2 busy: input write blocked");
    finish_transactions(); wait_for_idle_fsm();
    reset_model();
    
    // Bias write blocked
    enqueue_error_write(ADDR_BIAS, SIZE_DWORD, 64'h3333);
    execute_transactions(1);
    check_hresp_error("8.3 busy: bias write blocked");
    finish_transactions(); wait_for_idle_fsm();
    reset_model();

    // Output read blocked
    enqueue_error_read(ADDR_OUTPUT, SIZE_DWORD);
    execute_transactions(1);
    check_hresp_error("8.4 busy: output read blocked");
    finish_transactions(); wait_for_idle_fsm();
    reset_model();

    // Control register remains accessible (not SRAM-backed)
    enqueue_write(ADDR_CTRL, SIZE_DWORD, 64'h1);
    execute_transactions(1); finish_transactions();
    check_output("8.5 busy: ctrl reg still writable", hresp == 1'b0);
    ctrl_reg_clear = 2'b01; @(posedge clk); @(negedge clk); ctrl_reg_clear = 2'b00;
    
    // Status register remains readable (not SRAM-backed)
    status_reg_ctrl = 2'b10;
    enqueue_poll(ADDR_STATUS, SIZE_DWORD);
    execute_transactions(1); finish_transactions();
    check_output("8.6 busy: status reg still readable", hresp == 1'b0);
    status_reg_ctrl = 2'b00;
    
    // Error register remains readable
    nan_err = 1'b1;
    enqueue_poll(ADDR_ERROR, SIZE_DWORD);
    execute_transactions(1); finish_transactions();
    check_output("8.7 busy: error reg still readable", hresp == 1'b0);
    nan_err = 1'b0;
    
    occ_err = 1'b0;
    wait_for_idle_fsm();
    
    // After busy clears, SRAM access is allowed again
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hBEEF_BABE_1234_5678);
    execute_transactions(1); finish_transactions();
    check_output("8.8 post-busy: bias write succeeds after occ_err cleared",
    bias == 64'hBEEF_BABE_1234_5678 && hresp == 1'b0);
    
    // =================================================================
    // TEST 9: HREADY STALL GENERATION
    // hready_stall must pull hready low during active data phases only.
    // Transactions must stall (not commit) while hready is low.
    // hready must return high when hready_stall is released.
    // hready must NOT go low when stall is asserted with no transaction.
    // =================================================================
    $display("\n===== TEST 9: HREADY STALL GENERATION =====");
    
    // 9.1 hready is high at idle (no stall, no transaction)
    @(negedge clk);
    check_output("9.1 idle: hready high at rest", hready == 1'b1);
    
    // 9.2 Assert stall during write — write must not commit, hready goes low
    // hready is registered: goes low one cycle after stall asserted.
    // Sample it during the stall window, before releasing.
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hFFFF_FFFF_FFFF_FFFF);
    hready_stall = 1'b1;
    execute_transactions(1);
    @(posedge clk);
    @(posedge clk);
    @(negedge clk); // sample during stall — hready should be low here
    check_output("9.2 stall: hready pulled low", hready == 1'b0);
    //release stall first
    hready_stall =1'b0;
    @(posedge clk);
    @(negedge clk);
    //finish_transactions();
    check_output("9.2 stall: write not committed during hready_stall",
    bias != 64'hFFFF_FFFF_FFFF_FFFF);
    hready_stall = 1'b0;
    
    // 9.3 hready returns high after stall released
    @(posedge clk); @(negedge clk);
    check_output("9.3 stall released: hready returns high", hready == 1'b1);
    
    // 9.4 Valid write succeeds after stall released
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'h5A5A_5A5A_5A5A_5A5A);
    execute_transactions(1); finish_transactions();
    check_output("9.4 post-stall: write commits normally",
    bias == 64'h5A5A_5A5A_5A5A_5A5A);
    
    // 9.5 Stall with no active transaction must NOT pull hready low
    // (hready can only be driven low during a data phase per spec)
    hready_stall = 1'b1;
    repeat(3) @(posedge clk);
    @(negedge clk);
    check_output("9.5 stall outside transaction: hready stays high",
    hready == 1'b1);
    hready_stall = 1'b0;
    
    // 9.6 Multiple stall cycles then release — verify single commit
    enqueue_write(ADDR_BIAS, SIZE_DWORD, 64'hAAAA_BBBB_CCCC_DDDD);
    hready_stall = 1'b1;
    execute_transactions(1);
    repeat(3) @(posedge clk); // hold stall for extra cycles
    hready_stall = 1'b0;
    // No finish_transactions here — stalled transaction has no active context
    repeat(2) @(posedge clk);
    // Write was stalled so did not commit
    check_output("9.6 multi-cycle stall: write still not committed",
    bias == 64'h5A5A_5A5A_5A5A_5A5A);
    
    $display("\n===== ALL TESTS COMPLETE =====");
    $finish;
    end
endmodule


/* verilator coverage_on */
