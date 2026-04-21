`timescale 1ns / 10ps

module sysController #(
    // parameters
) (
    input logic clk,
    input logic n_rst,
    //from AHB
    input logic [1:0] ctrl_reg, //bit[0] = start_infer, bit[1] = load_weights
    input logic [1:0] act_ctrl, //activations function select
    input logic [63:0] hwdata,
    input logic ahb_wr_weight,
    input logic ahb_wr_input,
    //from dataBuffer + SRAM 
    input logic [63:0] sram_rd_data, //read data from SRAM (weights or inputs)
    input logic [1:0] sram_state, //FREE = 0, BUSY = 1, ACCESS = 2, ERROR = 3
    //from sysArray
    input logic [63:0] activations,
    //input logic array_done,
    //to dataBuffer
    output logic sram_rd_en,
    output logic sram_wr_en,
    output logic [9:0] sram_addr,
    output logic [63:0] sram_wr_data,
    //to sysArray
    output logic load_weights,
    output logic run_array,
    output logic [63:0] input_vec,
    //to AHB sub
    output logic [1:0] ctrl_reg_clear, //pulses to clear ctrl_reg bits
    output logic [1:0] status_reg, //bit[0] = infer_done bit[1] = busy
    output logic [1:0] act_ctrl_out //passthrough to activation block
);
    localparam [9:0] WT_BASE = 10'd0; //rows 0-63, weights
    localparam [9:0] IN_BASE = 10'd64; //rows 64-71, inputs
    localparam [9:0] OUT_BASE = 10'd72; //rows 72-79, outputs
    localparam SRAM_FREE = 2'd0;
    localparam SRAM_BUSY = 2'd1;
    localparam SRAM_ACCESS = 2'd2;
    //localparam SRAM_ERROR = 2'd3; 
    typedef enum logic [3:0] {
        IDLE = 4'd0,
        LOAD_WEIGHTS = 4'd1,
        WT_SRAM_WAIT = 4'd2,
        WT_DONE = 4'd3,
        INFER_FEED = 4'd4,
        IN_SRAM_WAIT = 4'd5,
        INFER_DRAIN = 4'd6,
        CAPTURE_OUT = 4'd7,
        OUT_SRAM_WAIT = 4'd8,
        DONE = 4'd9
    } state_t;

    state_t state, next_state;
    logic [5:0] wt_counter, next_wt_counter;
    logic [2:0] row_counter, next_row_counter;
    logic [5:0] lat_counter, next_lat_counter;
    logic [2:0] out_counter, next_out_counter;
    logic [1:0] status_ff, next_status;
    //logic [1:0] ctrl_reg_clear_ff;
    logic [9:0] hold_addr;
    logic hold_rd_en, hold_wr_en;
    logic [63:0] hold_wr_data;
    logic ahb_store_en, next_ahb_store_en;
    logic [9:0] ahb_store_addr, next_ahb_store_addr;
    logic [63:0] ahb_store_data, next_ahb_store_data;
    logic [5:0] wt_wr_ptr, next_wt_wr_ptr;
    logic [2:0] in_wr_ptr, next_in_wr_ptr;
    assign act_ctrl_out = act_ctrl;
    assign status_reg = status_ff;

    always_comb begin
        next_state = state;
        next_wt_counter = wt_counter;
        next_row_counter = row_counter;
        next_lat_counter = lat_counter;
        next_out_counter = out_counter;
        next_status = status_ff;
        next_wt_wr_ptr = wt_wr_ptr;
        next_in_wr_ptr = in_wr_ptr;
        next_ahb_store_en = 1'b0;
        next_ahb_store_addr = 10'd0;
        next_ahb_store_data = 64'd0;
        if(state == IDLE) begin  
            if(ahb_wr_weight) begin
                next_ahb_store_en = 1'b1;
                next_ahb_store_addr = WT_BASE + {4'd0, wt_wr_ptr};
                next_ahb_store_data = hwdata;
                if(wt_wr_ptr < 6'd63)
                    next_wt_wr_ptr = wt_wr_ptr + 6'd1;
            end
            else if(ahb_wr_input) begin
                next_ahb_store_en = 1'b1;
                next_ahb_store_addr = IN_BASE + {7'd0, in_wr_ptr};
                next_ahb_store_data = hwdata;
                if(in_wr_ptr < 3'd7)
                    next_in_wr_ptr = in_wr_ptr + 3'd1;
            end
        end
        case(state)
            IDLE: begin
                if(ctrl_reg[1]) begin
                    next_state = LOAD_WEIGHTS;
                    next_status[1] = 1'b1; //assert busy
                    next_wt_counter = 6'd0;
                    next_status[0] = 1'b0;
                end
                else if(ctrl_reg[0]) begin
                    next_state = INFER_FEED;
                    next_status[1] = 1'b1; //assert busy
                    next_status[0] = 1'b0;
                    next_row_counter = 3'd0;
                    next_lat_counter = 6'd0;
                end
            end
            LOAD_WEIGHTS: begin
                if(sram_state == SRAM_BUSY) begin
                    next_state = WT_SRAM_WAIT;
                end
                // else if(sram_state == SRAM_ACCESS) begin
                //     if(wt_counter == 6'd63) begin
                //         next_state = WT_DONE;
                //         next_wt_counter = 6'd0;
                //     end
                //     else begin
                //         next_wt_counter = wt_counter + 6'd1;
                //     end
                // end
            end
            WT_SRAM_WAIT: begin
                if(sram_state == SRAM_ACCESS) begin
                    if(wt_counter == 6'd63) begin
                        next_state = WT_DONE;
                        next_wt_counter = 6'd0;
                    end
                    else begin
                        next_wt_counter = wt_counter + 6'd1;
                        next_state = LOAD_WEIGHTS;
                    end
                end
            end
            WT_DONE: begin
                next_state = IDLE;
                next_status[1] = 1'b0; //clear busy
                //next_wt_wr_ptr = 6'd0; //reset weight pointer for next load
            end
            INFER_FEED: begin
                next_lat_counter = lat_counter + 6'd1;
                if(sram_state == SRAM_BUSY) begin
                    next_state = IN_SRAM_WAIT;
                end 
                // if(sram_state == SRAM_BUSY) begin
                //     next_state = IN_SRAM_WAIT;
                // end
                // else if(sram_state == SRAM_ACCESS) begin
                //     next_lat_counter = lat_counter + 6'd1;
                //     if(row_counter == 3'd7) begin
                //         next_state = INFER_DRAIN;
                //         next_row_counter = 3'd0;
                //     end
                //     else begin
                //         next_row_counter = row_counter + 3'd1;
                //     end
                // end
            end
            IN_SRAM_WAIT: begin
                next_lat_counter = lat_counter + 6'd1;
                if(sram_state == SRAM_ACCESS) begin
                    if(row_counter == 3'd7) begin
                        next_state = INFER_DRAIN;
                        next_row_counter = 3'd0;
                    end
                    else begin
                        next_row_counter = row_counter + 3'd1;
                        next_state = INFER_FEED;
                    end
                end
            end
            INFER_DRAIN: begin
                next_lat_counter = lat_counter + 6'd1;
                if(lat_counter >= 6'd40) begin //55 cycles
                    next_state = CAPTURE_OUT;
                end
            end
            CAPTURE_OUT: begin
                if(sram_state == SRAM_BUSY) begin
                    next_state = OUT_SRAM_WAIT;
                end
                // else if(sram_state == SRAM_ACCESS) begin
                //     if(out_counter == 3'd7) begin
                //         next_state = DONE;
                //         next_out_counter = 3'd0;
                //     end
                //     else begin
                //         next_out_counter = out_counter + 3'd1;
                //     end
                // end
            end
            OUT_SRAM_WAIT: begin
                if(sram_state == SRAM_ACCESS) begin
                    if(out_counter == 3'd7) begin
                        next_state = DONE;
                        next_out_counter = 3'd0;
                    end
                    else begin
                        next_out_counter = out_counter + 3'd1;
                    next_state = CAPTURE_OUT;
                    end
                end
            end
            DONE: begin
                next_state = IDLE;
                next_status[0] = 1'b1; //inference complete
                next_status[1] = 1'b0;
                //next_in_wr_ptr = 3'd0;
            end
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
            wt_counter <= 6'd0;
            row_counter <= 3'd0;
            lat_counter <= 6'd0;
            out_counter <= 3'd0;
            status_ff <= 2'b00;
            wt_wr_ptr <= 6'd0;
            in_wr_ptr <= 3'd0;
            ahb_store_en <= 1'b0;
            ahb_store_addr <= 10'd0;
            ahb_store_data <= 64'd0;
            // hold_addr <= 10'd0;
            // hold_rd_en <= 1'b0;
            // hold_wr_en <= 1'b0;
            // hold_wr_data <= 64'd0;
        end
        else begin
            state <= next_state;
            wt_counter <= next_wt_counter;
            row_counter <= next_row_counter;
            lat_counter <= next_lat_counter;
            out_counter <= next_out_counter;
            status_ff <= next_status;
            wt_wr_ptr <= next_wt_wr_ptr;
            in_wr_ptr <= next_in_wr_ptr;
            ahb_store_en <= next_ahb_store_en;
            ahb_store_addr <= next_ahb_store_addr;
            ahb_store_data <= next_ahb_store_data;
            // if(sram_state == SRAM_FREE) begin
            //     hold_addr <= sram_addr;
            //     hold_rd_en <= sram_rd_en;
            //     hold_wr_en <= sram_wr_en;
            //     hold_wr_data <= sram_wr_data;
            // end
        end
    end

    always_comb begin
        sram_rd_en = 1'b0;
        sram_wr_en = 1'b0;
        sram_addr = 10'd0;
        sram_wr_data = 64'd0;
        load_weights = 1'b0;
        run_array = 1'b0;
        input_vec = 64'd0;
        ctrl_reg_clear = 2'b00;
        case(state)
            IDLE: begin
                if(ahb_store_en) begin
                    sram_wr_en = 1'b1;
                    sram_addr = ahb_store_addr;
                    sram_wr_data = ahb_store_data;
                end
                // if(sram_state == SRAM_BUSY) begin
                //     sram_wr_en = hold_wr_en;
                //     sram_addr = hold_addr;
                //     sram_wr_data = hold_wr_data;
                // end
            end
            LOAD_WEIGHTS: begin
                sram_rd_en = 1'b1;
                sram_addr = WT_BASE + {4'd0, wt_counter};
                if(sram_state == SRAM_ACCESS) begin
                    load_weights = 1'b1;
                    input_vec = sram_rd_data;
                end
            end
            WT_SRAM_WAIT: begin
                sram_rd_en = 1'b1;
                sram_addr = WT_BASE + {4'd0, wt_counter}; 
                if(sram_state == SRAM_ACCESS) begin
                    load_weights = 1'b1;
                    input_vec = sram_rd_data;
                end
            end
            WT_DONE: begin
                ctrl_reg_clear[1] = 1'b1; //tell AHB to clear load weights
            end
            INFER_FEED: begin
                sram_rd_en = 1'b1;
                sram_addr = IN_BASE + {7'd0, row_counter};
                if(sram_state == SRAM_ACCESS) begin
                    run_array = 1'b1;
                    input_vec = sram_rd_data;
                end
            end
            IN_SRAM_WAIT: begin
                sram_rd_en = 1'b1;
                sram_addr = IN_BASE + {7'd0, row_counter}; //keep run array 0
                if(sram_state == SRAM_ACCESS) begin
                    run_array = 1'b1;
                    input_vec = sram_rd_data;
                end
            end
            INFER_DRAIN: begin
            end
            CAPTURE_OUT: begin
                sram_wr_en = 1'b1;
                sram_addr = OUT_BASE + {7'd0, out_counter};
                sram_wr_data = activations;
            end
            OUT_SRAM_WAIT: begin
                sram_wr_en = 1'b1;
                sram_addr = OUT_BASE + {7'd0, out_counter};
                sram_wr_data = activations;
            end
            DONE: begin
                ctrl_reg_clear[0] = 1'b1; //tell AHB sub to clear start bit?
            end
            default: begin
                sram_rd_en = 1'b0;
                sram_wr_en = 1'b0;
                sram_addr = 10'd0;
                sram_wr_data = 64'd0;
                load_weights = 1'b0;
                run_array = 1'b0;
                input_vec = 64'd0;
                ctrl_reg_clear = 2'b00; 
            end
        endcase
    end
endmodule

