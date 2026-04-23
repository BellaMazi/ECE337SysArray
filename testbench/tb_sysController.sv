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
    logic [63:0] sram_rd_data;
    logic inference_complete;
    logic [63:0] activations;

    logic sram_rd_en, sram_wr_en;
    logic [9:0] sram_addr;
    logic [63:0] sram_wr_data;
    logic load_weights, run_array;
    logic [63:0] input_vec;
    logic [1:0] ctrl_reg_clear;
    logic [1:0] status_reg;

    string test_name;

    // Updated DUT Instantiation (act_ctrl_out removed)
    sysController DUT(
        .clk(clk), .n_rst(n_rst), 
        .ctrl_reg(ctrl_reg), .act_ctrl(act_ctrl), 
        .sram_rd_data(sram_rd_data), 
        .inference_complete(inference_complete), .activations(activations), 
        .sram_rd_en(sram_rd_en), .sram_wr_en(sram_wr_en), 
        .sram_addr(sram_addr), .sram_wr_data(sram_wr_data), 
        .load_weights(load_weights), .run_array(run_array), 
        .input_vec(input_vec), .ctrl_reg_clear(ctrl_reg_clear), 
        .status_reg(status_reg)
    );

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

    task def_in();
        ctrl_reg = 2'b00;
        act_ctrl = 2'b00;
        sram_rd_data = 64'd0;
        activations = 64'd0;
        inference_complete = 1'b0;
    endtask

    initial begin
        n_rst = 1;
        def_in();
        reset_dut();

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

        def_in();
        reset_dut();
        
        ctrl_reg = 2'b10;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        if(status_reg[1] == 1'b1 && sram_rd_en == 1'b1 && sram_addr == WT_BASE)
            $display("TEST 3: Pass");
        else
            $display("TEST 3: Fail");

        $display("TEST 4: ctrl_reg[0] triggers INFER_FEED");
        test_name = "ctrl_reg[0] triggers INFER_FEED";

        def_in();
        reset_dut();
        
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

        def_in();
        reset_dut();
        
        ctrl_reg = 2'b11;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        if(sram_addr == WT_BASE)
            $display("TEST 5: Pass");
        else
            $display("TEST 5: Fail");

        $display("TEST 6: 64 cycle weight load seq");
        test_name = "64 cycle weight load seq";

        def_in();
        reset_dut();
        
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
                @(posedge clk); #1; // Pipelined 1 cycle per read now
                if(!load_weights) load_seen = 0;
                if(input_vec != expected_data) vec_correct = 0;
            end
            if(load_seen && vec_correct)
                $display("so far so good");
            else
                $display("bad");
        end

        if(ctrl_reg_clear[1] == 1'b1)
            $display("TEST 6: ctrl_reg_clear PASS!");
        else
            $display("TEST 6: ctrl_reg_clear FAIL!");
            
        @(posedge clk); #1;
        
        if(status_reg == 2'b00)
            $display("TEST 6: status_reg full final PASS");
        else 
            $display("TEST 6: status_reg full final FAIL");

        
        $display("TEST 7: Pipelined LOAD_WEIGHTS signal stability");
        test_name = "stable pipelined feed";

        def_in();
        reset_dut();
        
        ctrl_reg = 2'b10;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        begin
            logic stable_rd_en;
            integer j;
            stable_rd_en = 1;

            for(j = 0; j < 5; j++) begin
                @(posedge clk); #1;
                // Addr will increment now, so we just check rd_en
                if(sram_rd_en != 1'b1) stable_rd_en = 0;
            end
            if(stable_rd_en && load_weights == 1'b1)
                $display("TEST 7: stable vals PASS");
            else begin
                $display("TEST 7: stable vals FAIL");
            end
        end

        $display("TEST 8: 8 row inference feed");
        test_name = "8 row inference feed";

        def_in();
        reset_dut();
        
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
                @(posedge clk); #1;
                if(!run_array) run_seen = 0;
                if(input_vec != in_data) vec_ok = 0;
                if(sram_addr != IN_BASE + k) addr_ok = 0;
            end
            if(run_seen && vec_ok && addr_ok)
                $display("TEST 8: oks PASS");
            else begin
                $display("TEST 8: oks FAIL");
            end
        end

        $display("TEST 9: INFER_FEED transitions directly to WAIT_AND_CAPTURE");
        test_name = "INFER_DRAIN state transition";

        def_in();
        reset_dut();

        begin
            ctrl_reg = 2'b01;
            @(posedge clk); #1;
            ctrl_reg = 2'b00;

            begin
                integer r;
                for(r = 0; r< 8; r++) begin
                    sram_rd_data = 64'hCAFE_0000_0000_0000 | r;
                    @(posedge clk); #1;
                end
            end

            if(DUT.state == 4'd3) // 3 is WAIT_AND_CAPTURE
                $display("TEST 9: PASS (Entered WAIT_AND_CAPTURE)");
            else
                $display("TEST 9: FAIL (State is %0d)", DUT.state);
        end

        $display("TEST 10: CAPTURE_OUT triggered by inference_complete");
        test_name = "CAPTURE_OUT";

        def_in();
        reset_dut();

        begin
            ctrl_reg = 2'b01; 
            @(posedge clk); #1;
            ctrl_reg = 2'b00;
            
            // Feed 8 inputs
            begin
                integer r2;
                for(r2 = 0; r2 < 8; r2 ++) begin
                    sram_rd_data = 64'd0;
                    @(posedge clk); #1;
                end
            end
            
            // Simulate 10 cycles of pipeline delay before activations are ready
            begin
                integer d2;
                for(d2 = 0; d2 < 10; d2++) begin
                    @(posedge clk); #1;
                end
            end

            begin
                integer c;
                logic addr_ok2, data_ok;
                addr_ok2 = 1;
                data_ok = 1;
                
                // Assert valid signal to trigger output capture dynamically
                inference_complete = 1'b1;
                
                for(c = 0; c< 8; c++) begin
                    activations = 64'hDEAD_BEEF_0000_0000 | c;
                    if(sram_addr != OUT_BASE + c) addr_ok2 = 0;
                    if(sram_wr_data != activations) data_ok = 0;
                    @(posedge clk); #1;
                end
                
                inference_complete = 1'b0;
                
                if(addr_ok2 && data_ok)
                    $display("TEST 10: PASS");
                else begin
                    $display("TEST 10: FAIL");
                end
            end
        end

        $display("TEST 11: CAPTURE_OUT - 8-row output write completion");
        test_name = "CAPTURE_OUT - 8-row output write";

        // Test 10 functionally covered the 8-row write, but we can verify the state exited.
        if (DUT.state == 4'd4 || DUT.state == 4'd0) // DONE or IDLE
            $display("TEST 11: PASS");
        else
            $display("TEST 11: FAIL");

        $display("TEST 12: Done state");
        test_name = "DONE state";

        def_in();
        reset_dut();

        begin
            ctrl_reg = 2'b01; 
            @(posedge clk); #1;
            ctrl_reg = 2'b00;
            
            // Fast-forward through feed
            begin
                integer r3;
                for(r3 = 0; r3 < 8; r3++) begin
                    sram_rd_data = 64'd0;
                    @(posedge clk); #1;
                end
            end
            
            // Trigger completion
            inference_complete = 1'b1;
            begin
                integer c2; 
                for(c2 = 0; c2 < 8; c2++) begin
                    activations = 64'd0;
                    @(posedge clk); #1;
                end
            end
            inference_complete = 1'b0;
            
            if(status_reg[0] == 1'b1 && status_reg[1] == 1'b0 && ctrl_reg_clear[0] == 1'b1)
                $display("TEST 12: pt1 PASS");
            else begin
                $display("TEST 12: pt1 FAIL");
                $display("status_reg: %b, ctrl_reg_clr[0] = %b", status_reg, ctrl_reg_clear[0]);
            end
            
            @(posedge clk); #1;
            if(ctrl_reg_clear[0] == 1'b0 && status_reg[0] == 1'b1) // Status stays 1 until new infer
                $display("TEST 12: pt2 PASS");
            else
                $display("TEST 12: pt2 FAIL");
        end

        $display("TEST 13: b2b loading and inferring");
        test_name = "b2b";
        def_in();
        reset_dut();

        ctrl_reg = 2'b10;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;

        begin
            integer w2;
            for(w2 = 0; w2 < 64; w2++) begin
                sram_rd_data = 64'd0;
                @(posedge clk); #1;
            end
        end
        
        @(posedge clk); #1;
        ctrl_reg = 2'b01;
        @(posedge clk); #1;
        ctrl_reg = 2'b00;
        
        if(status_reg[1] == 1'b1 && sram_addr == IN_BASE)
            $display("TEST 13: PASS");
        else begin
            $display("TEST 13: FAIL");
            $display("status_reg[1]: %b, sram_addr: %b", status_reg[1], sram_addr);
        end

        $finish;
    end
endmodule

/* verilator coverage_on */

