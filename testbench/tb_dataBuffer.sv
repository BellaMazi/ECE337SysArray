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

        $display("TEST 10: SRAM BUSY stall");
        test_name = "SRAM wrarbites - SRAM BUSY stall";









        




        $finish;
    end
endmodule

/* verilator coverage_on */

