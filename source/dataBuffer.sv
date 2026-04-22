`timescale 1ns / 10ps

module dataBuffer #(
    // parameters
) (
    input logic clk, 
    input logic n_rst,
    input logic sram_rd_en,
    input logic sram_wr_en,
    input logic [9:0] sram_addr,
    input logic [63:0] sram_wr_data, 
    input logic [1:0] ctrl_reg_clear,
    input logic ctrl_reg_0,
    
    input logic [9:0] haddr,
    input logic [63:0] hwdata,
    input logic hwrite,
    input logic ahb_req,
    output logic [63:0] sram_rd_data,
    output logic [1:0] sram_state_out,
    output logic hready_stall,
    output logic occ_err,
    output logic overrun_err
);
    localparam [9:0] WT_BASE = 10'd0;
    localparam [9:0] IN_BASE = 10'd64;
    localparam [9:0] OUT_BASE = 10'd72;
    localparam [9:0] WEIGHT_REG = 10'h000;
    localparam [9:0] INPUT_REG = 10'h008;
    localparam [9:0] OUTPUT_REG = 10'h018;
    localparam [9:0] ERROR_REG = 10'h020;
    
    localparam SRAM_FREE = 2'd0;
    localparam SRAM_BUSY = 2'd1;
    localparam SRAM_ACCESS = 2'd2;
    
    localparam RGN_WT = 2'd0;
    localparam RGN_IN = 2'd1;
    localparam RGN_OUT = 2'd2;
    localparam RGN_NON = 2'd3;

    logic [1:0] sram_state;
    logic [1:0] wt_sram_hi_state, wt_sram_lo_state;
    logic [1:0] in_sram_hi_state, in_sram_lo_state;
    logic [1:0] out_sram_hi_state, out_sram_lo_state;
    logic [9:0] sram_address;
    logic sram_re, sram_we;
    logic [63:0] sram_wdata;
    logic wt_re, wt_we, in_re, in_we, out_re, out_we;
    logic [9:0] wt_addr, in_addr, out_addr;
    logic [31:0] wt_hi_rd, wt_lo_rd, in_hi_rd, in_lo_rd, out_hi_rd, out_lo_rd;
    
    logic [6:0] wt_wr_ptr, next_wt_wr_ptr;
    logic [3:0] in_wr_ptr, next_in_wr_ptr;
    logic [2:0] out_rd_ptr, next_out_rd_ptr;
    logic [3:0] out_valid_cnt, next_out_valid_cnt;
    logic occ_err_ff, next_occ_err, overrun_err_ff, next_overrun_err;
    logic [1:0] last_rd_region, next_last_rd_region;
    logic [9:0] ahb_mapped_addr;

    assign sram_state_out = sram_state;
    assign occ_err = occ_err_ff;
    assign overrun_err = overrun_err_ff;

    always_comb begin
        if (wt_sram_hi_state == SRAM_BUSY || wt_sram_lo_state == SRAM_BUSY ||
            in_sram_hi_state == SRAM_BUSY || in_sram_lo_state == SRAM_BUSY ||
            out_sram_hi_state == SRAM_BUSY || out_sram_lo_state == SRAM_BUSY)
            sram_state = SRAM_BUSY;
        else if (wt_sram_hi_state == SRAM_ACCESS || wt_sram_lo_state == SRAM_ACCESS ||
                 in_sram_hi_state == SRAM_ACCESS || in_sram_lo_state == SRAM_ACCESS ||
                 out_sram_hi_state == SRAM_ACCESS || out_sram_lo_state == SRAM_ACCESS)
            sram_state = SRAM_ACCESS;
        else
            sram_state = SRAM_FREE;
    end

    always_comb begin
        sram_address = 10'd0;
        sram_re = 1'b0;
        sram_we = 1'b0;
        sram_wdata = 64'd0;
        hready_stall = 1'b0;
        
        next_wt_wr_ptr = wt_wr_ptr;
        next_in_wr_ptr = in_wr_ptr;
        next_out_rd_ptr = out_rd_ptr;
        next_out_valid_cnt = out_valid_cnt;
        next_occ_err = occ_err_ff;
        next_overrun_err = overrun_err_ff;
        next_last_rd_region = last_rd_region;
        ahb_mapped_addr = 10'd0;

        // AHB address decode
        if(haddr == WEIGHT_REG) begin
            ahb_mapped_addr = WT_BASE + {3'd0, (wt_wr_ptr <= 7'd63 ? wt_wr_ptr[5:0] : 6'd63)};
        end
        else if(haddr == INPUT_REG) begin
            ahb_mapped_addr = IN_BASE + {6'd0, (in_wr_ptr[2:0])};
        end
        else if(haddr == OUTPUT_REG) begin
            ahb_mapped_addr = OUT_BASE + {7'd0, out_rd_ptr};
        end

        // Arbitration
        if(sram_rd_en || sram_wr_en) begin
            sram_address = sram_addr;
            sram_re = sram_rd_en;
            sram_we = sram_wr_en;
            sram_wdata = sram_wr_data;
        end
        else if (ahb_req) begin
            if(sram_state == SRAM_BUSY) begin
                hready_stall = 1'b1;
            end
            else begin
                sram_address = ahb_mapped_addr;
                sram_re = ~hwrite;
                sram_we = hwrite;
                sram_wdata = hwdata;
            end
        end

        // Region Tracking for Output Mux
        if(sram_re && sram_state != SRAM_BUSY) begin
            if(sram_address < IN_BASE) next_last_rd_region = RGN_WT;
            else if (sram_address < OUT_BASE) next_last_rd_region = RGN_IN;
            else next_last_rd_region = RGN_OUT;
        end
        else if(ahb_req && !hwrite && sram_state != SRAM_BUSY) begin
            if(haddr == WEIGHT_REG) next_last_rd_region = RGN_WT;
            else if (haddr == INPUT_REG) next_last_rd_region = RGN_IN;
            else if (haddr == OUTPUT_REG) next_last_rd_region = RGN_OUT;
        end

        // === FIXED POINTER LOGIC: Trigger on AHB Request ===
        if(ahb_req && hwrite && sram_state != SRAM_BUSY) begin
            if(haddr == WEIGHT_REG) begin
                if(wt_wr_ptr >= 7'd64) next_occ_err = 1'b1;
                else next_wt_wr_ptr = wt_wr_ptr + 7'd1;
            end
            else if(haddr == INPUT_REG) begin
                if(in_wr_ptr >= 4'd8) next_occ_err = 1'b1; // Fixed 8-check
                else next_in_wr_ptr = in_wr_ptr + 4'd1;
            end
        end

        if(sram_wr_en && hwrite && (sram_addr >= OUT_BASE) && sram_state != SRAM_BUSY) begin
            if(out_valid_cnt > 4'd0) next_overrun_err = 1'b1;
            next_out_valid_cnt = 4'd8;
        end

        if(ahb_req && ~hwrite && (haddr == OUTPUT_REG) && sram_state != SRAM_BUSY) begin
            if(out_valid_cnt > 4'd0) next_out_valid_cnt = out_valid_cnt - 4'd1;
            next_out_rd_ptr = out_rd_ptr + 3'd1;
        end

        if(ahb_req && ~hwrite && (haddr == ERROR_REG)) begin
            next_occ_err = 1'b0;
            next_overrun_err = 1'b0;
        end

        // Clears
        if(ctrl_reg_clear[1]) next_wt_wr_ptr = 7'd0;
        if(ctrl_reg_clear[0]) next_out_rd_ptr = 3'd0;
        if(ctrl_reg_0) next_in_wr_ptr = 4'd0;
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            wt_wr_ptr <= 7'd0;
            in_wr_ptr <= 4'd0;
            out_rd_ptr <= 3'd0;
            out_valid_cnt <= 4'd0;
            occ_err_ff <= 1'b0;
            overrun_err_ff <= 1'b0;
            last_rd_region <= RGN_NON;
        end
        else begin
            wt_wr_ptr <= next_wt_wr_ptr;
            in_wr_ptr <= next_in_wr_ptr;
            out_rd_ptr <= next_out_rd_ptr;
            out_valid_cnt <= next_out_valid_cnt;
            occ_err_ff <= next_occ_err;
            overrun_err_ff <= next_overrun_err;
            last_rd_region <= next_last_rd_region;
        end
    end

    // SRAM Bank Routing
    always_comb begin
        wt_re = sram_re && (sram_address >= WT_BASE) && (sram_address < IN_BASE);
        in_re = sram_re && (sram_address >= IN_BASE) && (sram_address < OUT_BASE);
        out_re = sram_re && (sram_address >= OUT_BASE);
        wt_we = sram_we && (sram_address >= WT_BASE) && (sram_address < IN_BASE);
        in_we = sram_we && (sram_address >= IN_BASE) && (sram_address < OUT_BASE);
        out_we = sram_we && (sram_address >= OUT_BASE);
        wt_addr = sram_address - WT_BASE;
        in_addr = sram_address - IN_BASE;
        out_addr = sram_address - OUT_BASE;
    end

    // Read Data Mux
    always_comb begin
        case(last_rd_region)
            RGN_WT: sram_rd_data = {wt_hi_rd, wt_lo_rd};
            RGN_IN: sram_rd_data = {in_hi_rd, in_lo_rd};
            RGN_OUT: sram_rd_data = {out_hi_rd, out_lo_rd};
            default: sram_rd_data = 64'd0;
        endcase
    end

    /* verilator lint_off SYNCASYNCNET */
    sram1024x32_wrapper wt_sram_hi(.clk(clk), .n_rst(n_rst), .address(wt_addr), .read_enable(wt_re), .write_enable(wt_we), .write_data(sram_wdata[63:32]), .read_data(wt_hi_rd), .sram_state(wt_sram_hi_state));
    sram1024x32_wrapper wt_sram_lo(.clk(clk), .n_rst(n_rst), .address(wt_addr), .read_enable(wt_re), .write_enable(wt_we), .write_data(sram_wdata[31:0]), .read_data(wt_lo_rd), .sram_state(wt_sram_lo_state));
    sram1024x32_wrapper in_sram_hi(.clk(clk), .n_rst(n_rst), .address(in_addr), .read_enable(in_re), .write_enable(in_we), .write_data(sram_wdata[63:32]), .read_data(in_hi_rd), .sram_state(in_sram_hi_state));
    sram1024x32_wrapper in_sram_lo(.clk(clk), .n_rst(n_rst), .address(in_addr), .read_enable(in_re), .write_enable(in_we), .write_data(sram_wdata[31:0]), .read_data(in_lo_rd), .sram_state(in_sram_lo_state));
    sram1024x32_wrapper out_sram_hi(.clk(clk), .n_rst(n_rst), .address(out_addr), .read_enable(out_re), .write_enable(out_we), .write_data(sram_wdata[63:32]), .read_data(out_hi_rd), .sram_state(out_sram_hi_state));
    sram1024x32_wrapper out_sram_lo(.clk(clk), .n_rst(n_rst), .address(out_addr), .read_enable(out_re), .write_enable(out_we), .write_data(sram_wdata[31:0]), .read_data(out_lo_rd), .sram_state(out_sram_lo_state));
    /* verilator lint_on SYNCASYNCNET */
endmodule