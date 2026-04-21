`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_dataBuffer ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic sram_rd_en, sram_wr_en;
    logic [9:0] sram_addr;
    logic [63:0] sram_wr_data;
    logic [1:0] ctrl_reg_clear;
    logic ctrl_reg_0;
    logic [9:0] haddr;
    logic [63:0] hwdata;
    logic write, hwrite, ahb_req;
    logic [63:0] sram_rd_data;
    logic [1:0] sram_state_out;
    logic hready_stall;

    localparam SRAM_FREE = 2'd0;
    localparam SRAM_BUSY = 2'd1;
    localparam SRAM_ACCESS = 2'd2;
    localparam SRAM_ERROR = 2'd3;

    localparam [9:0] WT_BASE = 10'd0;
    localparam [9:0] IN_BASE = 10'd64;
    localparam [9:0] OUT_BASE = 10'd72;

    localparam [9:0] WEIGHT_REG = 10'h000;
    localparam [9:0] INPUT_REG = 10'h008;
    localparam [9:0] OUTPUT_REG = 10'h018;
    localparam [9:0] ERROR_REG = 10'h020;

    string test_name;

    dataBuffer DUT(.clk(clk), .n_rst(n_rst), 
    .sram_rd_en(sram_rd_en), .sram_wr_en(sram_wr_en), 
    .sram_addr(sram_addr), .sram_wr_data(sram_wr_data), 
    .ctrl_reg_clear(ctrl_reg_clear), .ctrl_reg_0(ctrl_reg_0), 
    .haddr(haddr), .hwdata(hwdata), .hwrite(hwrite), 
    .ahb_req(ahb_req), .sram_rd_data(sram_rd_data), .sram_state_out(sram_state_out), 
    .hready_stall(hready_stall), .occ_err(occ_err), .overrun_err(overrun_err));


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
        sram_rd_en = 1'b0;
        sram_wr_en = 1'b0;
        sram_addr = 10'd0;
        sram_wr_data = 64'd0;
        ctrl_reg_clear = 2'b00;
        ctrl_reg_0 = 1'b0;
        haddr = 10'd0;
        hwdata = 64'd0;
        //write = 1'b0;
        hwrite = 1'b0;
        ahb_req = 1'b0;
    endtask

    task wait_sram(input logic [1:0] targ);
        integer timeout;
        timeout = 0;
        while(sram_state_out != targ && timeout < 20) begin
            @(posedge clk); #1;
            timeout++;
        end
    endtask

    task ahb_write(input logic [9:0] addr, input logic [63:0] data);
        haddr = addr;
        hwdata = data;
        hwrite = 1'b1;
        //write = 1'b1;
        ahb_req = 1'b1;
        wait_sram(SRAM_FREE);
        @(posedge clk); #1;
        wait_sram(SRAM_ACCESS);
        @(posedge clk); #1;
        ahb_req = 1'b0;
        hwrite = 1'b0;
        //write = 1'b0;
        hwdata = 64'd0;
    endtask

    task ahb_read(input logic [9:0] addr, input logic [63:0] data);
        haddr = addr;
        hwrite = 1'b0;
        //write = 1'b0;
        ahb_req = 1'b1;
        wait_sram(SRAM_FREE);
        @(posedge clk); #1;
        wait_sram(SRAM_ACCESS);
        data = sram_rd_data;
        @(posedge clk); #1;
        ahb_req = 1'b0;
        haddr = 10'd0;
    endtask

    task ctrl_write(input logic [9:0] addr, input logic [63:0] data);
        sram_wr_en = 1'b1;
        sram_addr = addr;
        sram_wr_data = data;
        wait_sram(SRAM_FREE);
        @(posedge clk); #1;
        wait_sram(SRAM_ACCESS);
        @(posedge clk); #1;
        sram_wr_en = 1'b0;
        sram_addr = 10'd0;
        sram_wr_data = 64'd0;
    endtask

     task ctrl_read(input logic [9:0] addr, input logic [63:0] data);
        sram_rd_en = 1'b1;
        sram_addr = addr;
        wait_sram(SRAM_FREE);
        @(posedge clk); #1;
        wait_sram(SRAM_ACCESS);
        data = sram_rd_data;
        @(posedge clk); #1;
        sram_rd_en = 1'b0;
        sram_addr = 10'd0;
    endtask

    initial begin
        n_rst = 1;
        sram_rd_en = 0;
        sram_wr_en = 0;
        sram_addr = 0;
        sram_wr_data = 0;
        ctrl_reg_clear = 0;
        ctrl_reg_0 = 0;
        haddr = 0;
        hwdata = 0;
        hwrite = 0;
        ahb_req = 0;

        reset_dut;
        //def_in();

        $display("TEST 1: Reset Behave");
        test_name = "Reset Behave";

        if(occ_err == 1'b0 && overrun_err == 1'b0 && hready_stall == 1'b0 && sram_rd_data == 64'd0)
            $display("TEST 1: PASS");
        else begin
            $display("TEST 1: FAIL");  
            $display("occ_err = %b, overrun_err %b, hready_stall = %b, sram_rd_data: %h", occ_err, overrun_err, hready_stall, sram_rd_data); 

        end 

        $display("TEST 2: AHB weight writes - 64 seq writes");
        test_name = "AHB weight writes - 64 seq writes";

        reset_dut();
        def_in();

        begin
            integer i;
            logic [63:0] wdata;
            for(i = 0; i < 64; i++) begin
                wdata = 64'hAAAA_0000_0000_0000 | i;
                ahb_write(WEIGHT_REG, wdata);
            end
            if(occ_err == 1'b0)
                $display("TEST 2: PASS");
            else
                $display("TEST 2: FAIL");
        end

        $display("TEST 3: 65th weight write causes occ_err");
        test_name = "occ_err";

        $display("TEST 3: before 65th write, wt_wr_ptr = %d, occ_err = %b", 
        DUT.wt_wr_ptr, occ_err);
        ahb_write(WEIGHT_REG, 64'hDEAD_BEEF_DEAD_BEEF);
        $display("TEST 3: after 65th write, wt_wr_ptr = %d, occ_err = %b",
        DUT.wt_wr_ptr, occ_err);

        ahb_write(WEIGHT_REG, 64'hDEAD_BEEF_DEAD_BEEF);
        if(occ_err == 1'b1)
            $display("TEST 3: err assert PASS");
        else
            $display("TEST 3: err assert FAIL");

        begin
            logic [63:0] temp;
            ahb_read(ERROR_REG, temp);
        end

        if(occ_err == 1'b0)
            $display("TEST 3: err clear PASS");
        else
            $display("TEST 3: err clear FAIL");

        $display("TEST 4: AHB input writes - 8 seq");
        test_name = "AHB input writes - 8 seq";

        reset_dut();
        def_in();

        begin
            integer j;
            for(j = 0; j < 8; j ++)
                ahb_write(INPUT_REG, 64'hBBBB_0000_0000_0000 | j);
            if(occ_err == 1'b0)
                $display("TEST 4: PASS");
            else
                $display("TEST 4: FAIL");
        end

        $display("TEST 5: 9th input write asserts occ_err");
        test_name = "9th input write asserts occ_err";

        ahb_write(INPUT_REG, 64'hBEEF_EEEF_CEEF_DEEF);
        if(occ_err == 1'b1)
            $display("TEST 5: occ assert PASS");
        else
            $display("TEST 5: occ assert FAIL");
        
        begin
            logic [63:0] temp;
            ahb_read(ERROR_REG, temp);
        end

        if(occ_err == 1'b0)
            $display("TEST 5: occ clear PASS");
        else
            $display("TEST 5: occ clear FAIL");

        $display("TEST 6: SRAM_reads - weight region");
        test_name = "SRAM_reads - weight region";

        reset_dut();

        begin
            integer k;
            logic [63:0] wr_val, rd_val;
            logic all_match;
            all_match = 1;

            for(k = 0; k < 8; k++) begin
                wr_val = 64'hECE3_3700_0000_0000 | k;
                ahb_write(WEIGHT_REG, wr_val);
            end
            ctrl_reg_clear = 2'b10;
            @(posedge clk) #1;
            ctrl_reg_clear = 2'b00;

            for(k = 0; k < 8; k++) begin
                ctrl_read(WT_BASE + k, rd_val);
                if(rd_val != (64'hECE3_3700_0000_0000 | k)) all_match = 0;
            end
            if(all_match)
                $display("TEST 6: PASS");
            else
                $display("TEST 6: FAIL");
        end

        $display("TEST 7: Contoller SRAM_reads - input region");
        test_name = "Contoller SRAM_reads - input region";

        begin
            integer m;
            logic [63:0] wr_val, rd_val;
            logic all_match;
            all_match = 1;
            for(m = 0; m < 8; m++) begin
                wr_val = 64'hDEEF_BEEF_0000_0000 | m;
                ahb_write(INPUT_REG, wr_val);
            end

            for(m = 0; m < 8; m++) begin
                ctrl_read(IN_BASE + m, rd_val);
                if(rd_val != (64'hDEEF_BEEF_0000_0000 | m)) all_match = 0;
            end
            if(all_match)
                $display("TEST 7: PASS");
            else
                $display("TEST 7: PASS");
            
        end

        $display("TEST 8: Contoller SRAM writes - out region");
        test_name = "Contoller SRAM writes - out region";

        reset_dut();
        def_in();

        begin
            integer n;
            logic [63:0] wr_val, rd_val;
            logic all_match;
            all_match =1;

            for(n = 0; n < 8; n++) begin
                wr_val = 64'hDEAD_DEAD_DEAD_DEAD | n;
                ctrl_write(OUT_BASE + n, wr_val);
            end

            for(n = 0; n < 8; n++) begin
                ahb_read(OUTPUT_REG, rd_val);
                if(rd_val != (64'hDEAD_DEAD_DEAD_DEAD | n)) all_match = 0;
            end
            if(all_match)
                $display("TEST 8: PASS");
            else
                $display("TEST 8: FAIL");
        end

        $display("TEST 9:  SRAM wrarbites - contoller wins");
        test_name = "SRAM wrarbites - contoller wins";

        begin
            logic [63:0] rd_result;

            ctrl_write(WT_BASE + 5, 64'hAAAA_AAAA_AAAA_AAAA);

            sram_rd_en = 1'b1;
            sram_addr = WT_BASE + 5;
            ahb_req = 1'b1;
            haddr = WEIGHT_REG;
            hwdata = 64'hDEAD_DEEF_DEAD_DEEF;
            hwrite = 1'b1;

            wait_sram(SRAM_FREE);
            @(posedge clk); #1;
            wait_sram(SRAM_ACCESS);
            rd_result = sram_rd_data;
            @(posedge clk); #1;

            sram_rd_en = 1'b0;
            ahb_req = 1'b0;
            hwrite = 1'b0;

            if(rd_result == 64'hAAAA_AAAA_AAAA_AAAA)
                $display("TEST 9: Controller read data correct");
            else begin
                $display("TEST 9: Controller DID NOT read data correct");
                $display("result: %h", rd_result);
            end

        end

        n_rst = 1;
        sram_rd_en = 0;
        sram_wr_en = 0;
        sram_addr = 0;
        sram_wr_data = 0;
        ctrl_reg_clear = 0;
        ctrl_reg_0 = 0;
        haddr = 0;
        hwdata = 0;
        hwrite = 0;
        ahb_req = 0;

        reset_dut();

        $display("TEST 10: SRAM BUSY stall");
        test_name = "SRAM wrarbites - SRAM BUSY stall";

        begin : busy_stall
            logic stall_seen;
            stall_seen = 0;
        
            haddr   = INPUT_REG;
            hwdata  = 64'hCAFE_BABE_1234_5678;
            hwrite  = 1'b1;
            write   = 1'b1;
            ahb_req = 1'b1;
        
            // Wait for BUSY phase and check hready_stall
            wait_sram(SRAM_FREE); @(posedge clk); #1;
            if (sram_state_out == SRAM_BUSY && hready_stall == 1'b1)
                stall_seen = 1;
            wait_sram(SRAM_ACCESS); @(posedge clk); #1;
        
            ahb_req = 1'b0;
            hwrite  = 1'b0;
            write   = 1'b0;

            if(hready_stall == 1'b0) begin
                $display("TEST 10: PASS");
            end
            else
                $display("TEST 10: FAIL");
        end

        $display("TEST 11: SRAM BUSY controller path no stall");
        test_name = "SRAM_BUSY";

        begin
            logic stallDurCtrl;
            stallDurCtrl = 0;

            wait_sram(SRAM_FREE); 
            @(posedge clk); #1;
            if(hready_stall)
                stallDurCtrl = 1;
            wait_sram(SRAM_BUSY); 
            @(posedge clk); #1;
            if(hready_stall)
                stallDurCtrl = 1;
            wait_sram(SRAM_ACCESS); 
            @(posedge clk); #1;

            sram_rd_en = 1'b0;
            if(!stallDurCtrl)
                $display("TEST 11: PASS (sram stays 0 during controller-only SRAM access)");
            else
                $display("TEST 11: FAIL");

            
        end

        def_in();
        reset_dut();

        $display("TEST 12: Read-data mux: correct bank is selected");
        test_name = "Read-data mux: correct bank is selected";

        begin
            logic [63:0] wt_val, in_val, out_val;
            logic [63:0] rd_wt, rd_in, rd_out;

            wt_val = 64'hAAAAAAAAAAAAAAAA;
            in_val = 64'hCCCCCCCCCCCCCCCC;
            out_val = 64'hEEEEEEEEEEEEEEEE;

            ahb_write(WEIGHT_REG, wt_val);
            ahb_write(INPUT_REG, in_val);
            ctrl_write(OUT_BASE, out_val);

            ctrl_reg_clear = 2'b11;
            @(posedge clk); #1;
            ctrl_reg_clear = 2'b00;
            ctrl_reg_0 = 1'b1;
            @(posedge clk); #1;
            ctrl_reg_0 = 1'b0;

            //read back
            ctrl_read(WT_BASE, rd_wt);
            ctrl_read(IN_BASE, rd_in);
            ctrl_read(OUT_BASE, rd_out);

            if(rd_wt == wt_val && rd_in == in_val && rd_out == out_val)
                $display("TEST 12: PASS");
            else begin
                $display("TEST 12: FAIL");
                $display("rd_wt = %h, rd_in = %h, rd_out = %h", rd_wt, rd_in, rd_out);
            end


        end

        test_name = "Back-to-back reads different regions";
        $display("TEST 13: %s", test_name);
        reset_dut();
 
        begin
            logic [63:0] rd_a, rd_b;
    
            ahb_write(WEIGHT_REG, 64'h1111_1111_1111_1111);
            ctrl_write(OUT_BASE,  64'h9999_9999_9999_9999);
            ctrl_reg_clear = 2'b11; @(posedge clk); #1; ctrl_reg_clear = 2'b00;
        
            sram_rd_en = 1'b1; sram_addr = WT_BASE;
            wait_sram(SRAM_FREE); @(posedge clk); #1;
            wait_sram(SRAM_ACCESS); 
            rd_a = sram_rd_data; 
            @(posedge clk); #1;
            sram_addr = OUT_BASE;
            wait_sram(SRAM_FREE); 
            @(posedge clk); #1;
            wait_sram(SRAM_ACCESS); 
            rd_b = sram_rd_data; 
            @(posedge clk); #1;
            sram_rd_en = 1'b0;
        
            if(rd_a == 64'h1111_1111_1111_1111)
                $display("TEST 13: PASS first read (WT) not contaminated");
            else
                $display("TEST 13: FAIL first read bad");
            if(rd_b == 64'h9999_9999_9999_9999)
                $display("TEST 13: PASS second read (OUT) not contaminated");
            else
                $display("TEST 13: FAIL Second read bad");
        end

        test_name = "Overrun error — outputs overwritten before read";
        $display("TEST 14:", test_name);
        reset_dut();
    
        begin
            integer p;
            // First inference: controller writes 8 outputs (not read by AHB)
            for (p = 0; p < 8; p++)
                ctrl_write(OUT_BASE + p, 64'hFFFF_0000_0000_0000 | p);
        
            if(overrun_err == 1'b0)
                $display("overrun_err=0 after first write set");
        
            // Second inference: controller writes again without AHB reading
            for (p = 0; p < 8; p++)
                ctrl_write(OUT_BASE + p, 64'hEEEE_0000_0000_0000 | p);
        
            if(overrun_err == 1'b1)
                $display("TEST 14: PASS overrun_err=1 when outputs overwritten before read");
            else
                $display("TEST 14: FAIL");
        end

        test_name = "Overrun error clears on error reg read";
        $display("TEST 15: %s", test_name);
    
        begin
            logic [63:0] dummy;
            ahb_read(ERROR_REG, dummy);
            if(overrun_err == 1'b0)
                $display("TEST 15: PASS overrun_err=0 after error register read");
        end

        test_name = "occ_err clears on error reg read";
        $display("TEST 16: %s", test_name);
        reset_dut();
    
        begin
            integer q;
            logic [63:0] dummy;
            // Write 65 weights to trigger occ_err
            for (q = 0; q < 65; q++)
                ahb_write(WEIGHT_REG, 64'd0 | q);
            if(occ_err == 1'b1)
                $display("TEST 16: PASS occ_err=1 after 65th weight write");
            else
                $display("TEST 16: FAIL after 65th weight write");
            ahb_read(ERROR_REG, dummy);
            if(occ_err == 1'b0)
                $display("TEST 16: PASS occ_err=0 after error register read");
            else
                $display("TEST 16: FAIL after err reg read");
        end

        test_name = "Pointer resets";
        $display("TEST 17: %s", test_name);
        reset_dut();
    
        begin
            integer r;
            logic [63:0] rd_val;
        
            // Advance wt_wr_ptr by writing 10 weights
            for (r = 0; r < 10; r++)
                ahb_write(WEIGHT_REG, 64'hAAAA_0000_0000_0000 | r);
        
            // Assert ctrl_reg_clear[1] — wt_wr_ptr should reset to 0
            ctrl_reg_clear = 2'b10; @(posedge clk); #1; ctrl_reg_clear = 2'b00;
        
            // Write one more weight — should go to WT_BASE+0 if ptr reset
            ahb_write(WEIGHT_REG, 64'hBEEF_BEEF_BEEF_BEEF);
        
            // Read WT_BASE+0 — should be the freshly written value
            ctrl_read(WT_BASE, rd_val);
            if(rd_val == 64'hBEEF_BEEF_BEEF_BEEF)
                $display("TEST 17: PASS wt_wr_ptr reset to 0 after ctrl_reg_clear[1]");
            else
            $display("TEST 17: FAIL: wt_wr_ptr NOT reset to 0 after ctrl_reg_clear[1]");
        
            // Advance out_rd_ptr by reading 5 outputs
            begin 
                integer s;
                logic [63:0] d;
                for (s = 0; s < 8; s++)
                ctrl_write(OUT_BASE + s, 64'hCCCC_0000_0000_0000 | s);
                for (s = 0; s < 5; s++)
                ahb_read(OUTPUT_REG, d);
            end
        
            // Assert ctrl_reg_clear[0] — out_rd_ptr resets to 0
            ctrl_reg_clear = 2'b01; @(posedge clk); #1; ctrl_reg_clear = 2'b00;
        
            // Next AHB read should return OUT_BASE+0 data
            begin : out_rd_chk
                logic [63:0] out_rd;
                ahb_read(OUTPUT_REG, out_rd);
                if(out_rd == 64'hCCCC_0000_0000_0000)
                    $display("TEST 17: PASS out_rd_ptr reset to 0 after ctrl_reg_clear[0]");
                else
                    $display("TEST 17: FAIL out_rd_ptr NOT reset to 0 after ctrl_reg_clear[0]");
            end
        
            // Advance in_wr_ptr by writing 4 inputs
            for (r = 0; r < 4; r++)
                ahb_write(INPUT_REG, 64'hDDDD_0000_0000_0000 | r);
        
            // Assert ctrl_reg_0 — in_wr_ptr resets to 0
            ctrl_reg_0 = 1'b1; @(posedge clk); #1; ctrl_reg_0 = 1'b0;
        
            // Write one input — should go to IN_BASE+0
            ahb_write(INPUT_REG, 64'hEEEE_EEEE_EEEE_EEEE);
            ctrl_read(IN_BASE, rd_val);
            if(rd_val == 64'hEEEE_EEEE_EEEE_EEEE)
                $display("TEST 17: PASS in_wr_ptr reset to 0 after ctrl_reg_0");
            else
                $display("TEST 17: FAIL in_wr_ptr NOT reset to 0 after ctrl_reg_0");
        end




        









        




        $finish;
    end
endmodule

/* verilator coverage_on */

