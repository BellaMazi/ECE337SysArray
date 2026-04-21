`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_sysController ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    localparam SRAM_FREE = 2'd0;
    localparam SRAM_BUSY = 2'd1;
    localparam SRAM_ACCESS = 2'd2;
    localparam SRAM_ERROR = 2'd3;
    localparam [9:0] WT_BASE = 10'd0;
    localparam [9:0] IN_BASE = 10'd64;
    localparam [9:0] OUT_BASE = 10'd72;

    logic clk, n_rst;
    logic [1:0] ctrl_reg;
    logic [1:0] act_ctrl;
    logic [63:0] hwdata;
    logic ahb_wr_weight, ahb_wr_input;
    logic [63:0] sram_rd_data;
    logic [1:0] sram_state;
    logic [63:0] activations;
    //logic array_done;

    logic sram_rd_en, sram_wr_en;
    logic [9:0] sram_addr;
    logic [63:0] sram_wr_data;
    logic load_weights, run_array;
    logic [63:0] input_vec;
    logic [1:0] ctrl_reg_clear;
    logic [1:0] status_reg;
    logic [1:0] act_ctrl_out;

    string test_name;

    sysController DUT(.clk(clk), .n_rst(n_rst), 
    .ctrl_reg(ctrl_reg), .act_ctrl(act_ctrl), 
    .hwdata(hwdata), .ahb_wr_weight(ahb_wr_weight), 
    .ahb_wr_input(ahb_wr_input), .sram_rd_data(sram_rd_data), 
    .sram_state(sram_state), .activations(activations), .sram_rd_en(sram_rd_en), 
    .sram_wr_en(sram_wr_en), .sram_addr(sram_addr), 
    .sram_wr_data(sram_wr_data), .load_weights(load_weights), 
    .run_array(run_array), .input_vec(input_vec), 
    .ctrl_reg_clear(ctrl_reg_clear), .status_reg(status_reg), .act_ctrl_out(act_ctrl_out));

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
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    //sysController #() DUT (.*);

    task def_in();
        ctrl_reg = 2'b00;
        act_ctrl = 2'b00;
        hwdata = 64'd0;
        ahb_wr_weight = 1'b0;
        ahb_wr_input = 1'b0;
        sram_rd_data = 64'd0;
        sram_state = SRAM_FREE;
        activations = 64'd0;
        //array_done = 1'b0;
    endtask

    task sram_cycle(input logic [63:0] rd_data);
        sram_state = SRAM_FREE;
        @(posedge clk); #1;
        sram_state = SRAM_BUSY;
        @(posedge clk); #1;
        sram_state = SRAM_ACCESS;
        sram_rd_data = rd_data;
        @(posedge clk); #1;
        sram_state = SRAM_FREE;
        sram_rd_data = 64'd0;
    endtask

    initial begin
        n_rst = 1;
        reset_dut;

        $display("TEST 1: Reset Behavior");
        test_name = "Reset Behavior";

        if(sram_rd_en == 1'b0 && sram_wr_en == 1'b0 && sram_addr == 10'd0 && load_weights == 1'b0 && run_array == 1'b0 && input_vec == 64'd0 && ctrl_reg_clear == 2'b00 && status_reg == 2'b00) begin
            $display("TEST 1: Pass");
        end
        else begin
            $display("TEST 1: Fail");
        end

        $display("TEST 2: IDLE hold");
        test_name = "IDLE hold";

        def_in();
        repeat(10) @(posedge clk); #1;

        if(status_reg == 2'b00 && sram_rd_en == 1'b0 && sram_wr_en == 1'b0 && ctrl_reg_clear == 2'b00)
            $display("TEST 2: Pass");
        else
            $display("TEST 2: Fail");

        $display("TEST 3: ctrl_reg [1] triggers LOAD_WEIGHTS");
        test_name = "ctrl_reg [1] triggers LOAD_WEIGHTS";

        reset_dut();
        def_in();
        ctrl_reg = 2'b10;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        if(status_reg[1] == 1'b1 && sram_rd_en == 1'b1 && sram_addr == WT_BASE)
            $display("TEST 3: Pass");
        else
            $display("TEST 3: Fail");

        $display("TEST 4: ctrl_reg[0] triggers INFER_FEED");
        test_name = "ctrl_reg[0] triggers INFER_FEED";

        reset_dut();
        def_in();
        ctrl_reg = 2'b01;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        if(status_reg[1] == 1'b1 && sram_rd_en == 1'b1 && sram_addr == IN_BASE)
            $display("TEST 4: Pass");
        else begin
            $display("TEST 4: Fail");
            $display("status_reg[1]: %b, sram_rd_en: %b, sram_addr: %b", status_reg[1], sram_rd_en, sram_addr);
        end

        $display("TEST 5: ctrl_reg[1] wins over ctrl_reg[0]");
        test_name = "load priority over infer";

        reset_dut();
        def_in();
        ctrl_reg = 2'b11;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        if(sram_addr == WT_BASE)
            $display("TEST 5: Pass");
        else
            $display("TEST 5: Fail");

        $display("TEST 6: 64 cycle weight load seq");
        test_name = "64 cycle weight load seq";

        reset_dut();
        def_in();
        ctrl_reg = 2'b10;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        begin : weight_loading
            integer i;
            logic [63:0] expected_data;
            logic load_seen, vec_correct;
            load_seen = 1;
            vec_correct = 1;

            for(i = 0; i<64; i++) begin
                expected_data = 64'hA5A5A5A5_00000000 | i;
                sram_rd_data = expected_data;
                sram_cycle(expected_data);
                if(!load_weights) load_seen = 0;
                if(input_vec != expected_data) vec_correct = 0;
            end
            if(load_seen && vec_correct)
                $display("so far so good");
            else
                $display("bad");
        end

        //@(posedge clk); #1;
        if(ctrl_reg_clear[1] == 1'b1)
            $display("TEST 6: ctrl_reg_clear PASS!");
        else
            $display("TEST 6: ctrl_reg_clear FAIL!");
        if(status_reg[1] == 1'b0)
            $display("TEST 6: status_reg PASS!");
        else
            $display("TEST 6: status_reg FAIL!");
        @(posedge clk); #1;
        if(status_reg == 2'b00)
            $display("TEST 6: status_reg full final PASS");
        else 
            $display("TEST 6: status_reg full final FAIL");

        
        $display("TEST 7: WT_SRAM_WAIT- signals stable during busy");
        test_name = "stable during busy";

        reset_dut();
        def_in();
        ctrl_reg = 2'b10;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;
        sram_state = SRAM_BUSY;

        begin
            logic [9:0] captured_addr;
            logic captrued_rd_en;
            logic stable_addr, stable_rd_en;
            integer j;
            captured_addr = sram_addr;
            captrued_rd_en = sram_rd_en;
            stable_addr = 1;
            stable_rd_en = 1;

            for(j = 0; j < 5; j++) begin
                @(posedge clk); #1;
                if(sram_addr != captured_addr) stable_addr = 0;
                if(sram_rd_en != captrued_rd_en) stable_rd_en = 0;
            end
            if(stable_addr && stable_rd_en && load_weights == 1'b0)
                $display("TEST 7: stable vals PASS");
            else begin
                $display("TEST 7: stable vals FAIL");
                $display("stable_addr: %b, stable_rd_en: %d, load_weights: %b", stable_addr, stable_rd_en, load_weights);
            end
        end

        sram_state = SRAM_ACCESS;
        @(posedge clk); #1;
        sram_state = SRAM_FREE;

        $display("TEST 8: 8 row inference feed");
        test_name = "8 row inference feed";

        reset_dut();
        def_in();
        ctrl_reg = 2'b01;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        begin
            integer k;
            logic [63:0] in_data;
            logic run_seen, vec_ok, addr_ok;
            run_seen = 1;
            vec_ok = 1;
            addr_ok = 1;

            for(k = 0; k < 8; k++) begin
                in_data = 64'hBEEF_0000_0000_0000 | k;
                sram_rd_data = in_data;
                sram_state = SRAM_FREE;
                @(posedge clk); #1;
                sram_state = SRAM_BUSY;
                @(posedge clk); #1;
                sram_state = SRAM_ACCESS;
                if(!run_array) run_seen = 0;
                if(input_vec != in_data) vec_ok = 0;
                if(sram_addr != IN_BASE + k) addr_ok = 0;
                @(posedge clk); #1;
                sram_state = SRAM_FREE;
                sram_rd_data = 64'd0;
            end
            if(run_seen && vec_ok && addr_ok)
                $display("TEST 8: oks PASS");
            else begin
                $display("TEST 8: oks FAIL");
                $display("run_seen = %b, vec_ok = %b, addr_ok = %b", run_seen, vec_ok, addr_ok);
            end
        end

        $display("TEST 9: IN_SRAM_WAIT");
        test_name = "IN_SRAM_WAIT stable";

        reset_dut();
        def_in();
        ctrl_reg = 2'b01;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;
        sram_state = SRAM_FREE;
        @(posedge clk); #1;
        sram_state = SRAM_BUSY;

        begin
            logic [9:0] cap_addr;
            logic stable;
            integer m;
            cap_addr = sram_addr;
            stable = 1;
            for(m = 0; m<4; m++) begin
                @(posedge clk); #1;
                if(sram_addr != cap_addr) stable = 0;
            end
            if(run_array == 1'b0 && stable)
                $display("TEST 9: PASS");
            else begin
                $display("TEST 9: FAIL");
                $display("run_array = %b, stable = %b", run_array, stable);
            end
        end
        sram_state = SRAM_FREE;

        $display("TEST 10: INFER_DRAIN - lat_counter gets to 54 then CAPTURE_OUT and lat < 55 cycles");
        test_name = "INFER_DRAIN lat_conter and lat budge";

        reset_dut();
        def_in();

        begin
            integer cycle_cnt;
            logic done_seen;
            cycle_cnt = 0;
            done_seen = 0;

            ctrl_reg = 2'b01;
            @(posedge clk); #1;
            ctrl_reg = 2'b00;

            begin
                integer r;
                for(r = 0; r< 8; r++) begin
                    sram_cycle(64'hCAFE_0000_0000_0000 | r);
                    cycle_cnt++;
                end
            end

            if(run_array == 1'b0)
                $display("entering INFER_DRAIN");
            
            begin
                integer d;
                for(d = 0; d < 60; d++) begin
                    @(posedge clk); #1;
                    cycle_cnt++;
                    if(sram_wr_en) begin
                        done_seen = 1;
                        break;
                    end
                end
            end
            if(done_seen && cycle_cnt <= 55) begin
                $display("TEST 10: PASS");
                $display("lat measured: %d", cycle_cnt);
            end
            else begin
                $display("TEST 10: FAIL");
                $display("done_seen = %b, lat measured: %d", done_seen, cycle_cnt);
            end

        end

        $display("TEST 11: CAPTURE_OUT - 8-row output write");
        test_name = "CAPTURE_OUT - 8-row output write";

        begin
            ctrl_reg = 2'b01; 
            @(posedge clk); #1;
            ctrl_reg = 2'b00;
            begin
                integer r2;
                for(r2 = 0; r2 < 8; r2 ++)
                    sram_cycle(64'd0);
            end
            begin
                integer d2;
                for(d2 = 0; d2 < 60; d2++) begin
                    @(posedge clk); #1;
                    if(sram_wr_en) break;
                end
            end

            begin
                integer c;
                logic addr_ok2, data_ok;
                addr_ok2 = 1;
                data_ok = 1;
                for(c = 0; c< 8; c++) begin
                    activations = 64'hDEAD_BEEF_0000_0000 | c;
                    if(sram_addr != OUT_BASE + c) addr_ok2 = 0;
                    if(sram_wr_data != activations) data_ok = 0;
                    sram_cycle(64'd0);
                end
                if(addr_ok2 && data_ok)
                    $display("TEST 11: PASS");
                else begin
                    $display("TEST 11: FAIL");
                    $display("addr_ok2: %b, data_ok = %b", addr_ok2, data_ok);
                end
            end
        end

        $display("TEST 12: Done state");
        test_name = "DONE state";

        begin
            ctrl_reg = 2'b01; 
            @(posedge clk); #1;
            ctrl_reg = 2'b00;
            begin
                integer r3;
                for(r3 = 0; r3 < 8; r3++) sram_cycle(64'd0);
            end
            begin
                integer d3;
                for(d3 = 0; d3 < 60; d3++) begin
                    @(posedge clk); #1;
                    if(sram_wr_en) break;
                end
            end
            begin
                integer c2; 
                for(c2 = 0; c2 < 8; c2++) sram_cycle(64'd0);
            end
            if(status_reg[0] == 1'b1 && status_reg[1] == 1'b0 && ctrl_reg_clear[0] == 1'b1)
                $display("TEST 12: pt1 PASS");
            else begin
                $display("TEST 12: pt1 FAIL");
                $display("status_reg: %b, ctrl_reg_clr[0] = %b", status_reg, ctrl_reg_clear[0]);
            end
            @(posedge clk); #1;
            if(ctrl_reg_clear[0] == 1'b0)
                $display("TEST 12: pt2 PASS");
            else
                $display("TEST 12: pt2 FAIL");
        end

        $display("TEST 13: act_ctlr pass");
        test_name = "actl_ctrl pass";

        reset_dut();
        def_in();
        act_ctrl = 2'b10;
        @(posedge clk); #1;
        if(act_ctrl_out == 2'b10)
            $display("TEST 13: good1");
        else
            $display("TEST 13: bad1");
        act_ctrl = 2'b11;
        @(posedge clk); #1;
        if(act_ctrl_out == 2'b11)
            $display("TEST 13: good2");
        else
            $display("TEST 13: bad2");

        $display("TEST 14: b2b");
        test_name = "b2b";
        reset_dut();
        def_in();

        ctrl_reg = 2'b10;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        begin
            integer w2;
            for(w2 = 0; w2 < 64; w2++)
                sram_cycle(64'd0);
        end
        @(posedge clk); #1;
        ctrl_reg = 2'b01;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;
        if(status_reg[1] == 1'b1 && sram_addr == IN_BASE)
            $display("TEST 14: PASS");
        else begin
            $display("TEST 14: FAIL");
            $display("status_reg[1]: %b, sram_addr: %b", status_reg[1], sram_addr);
        end



        $finish;
    end
endmodule

/* verilator coverage_on */

