`timescale 1ns / 10ps

module sysController #(
    // parameters
) (
    input logic clk,
    input logic n_rst,
    input logic [1:0] ctrl_reg, 
    input logic [1:0] act_ctrl, 
    input logic [63:0] hwdata,
    input logic ahb_wr_weight,
    input logic ahb_wr_input,
    input logic [63:0] sram_rd_data, 
    input logic [1:0] sram_state,
    
    // === NEW REQUIRED INPUT ===
    input logic inference_complete, 
    input logic [63:0] activations,
    
    output logic sram_rd_en,
    output logic sram_wr_en,
    output logic [9:0] sram_addr,
    output logic [63:0] sram_wr_data,
    output logic load_weights,
    output logic run_array,
    output logic [63:0] input_vec,
    output logic [1:0] ctrl_reg_clear, 
    output logic [1:0] status_reg, 
    output logic [1:0] act_ctrl_out 
);
    localparam [9:0] WT_BASE = 10'd0; 
    localparam [9:0] IN_BASE = 10'd64; 
    localparam [9:0] OUT_BASE = 10'd72; 
    localparam SRAM_FREE = 2'd0;
    localparam SRAM_BUSY = 2'd1;
    localparam SRAM_ACCESS = 2'd2;
    
    typedef enum logic [3:0] {
        IDLE = 4'd0,
        LOAD_WEIGHTS = 4'd1,
        WT_SRAM_WAIT = 4'd2,
        WT_DONE = 4'd3,
        INFER_FEED = 4'd4,
        IN_SRAM_WAIT = 4'd5,
        INFER_DRAIN = 4'd6,
        CAPTURE_OUT = 4'd7,
        DONE = 4'd8
    } state_t;

    state_t state, next_state;
    logic [5:0] wt_counter, next_wt_counter;
    logic [2:0] row_counter, next_row_counter;
    logic [5:0] lat_counter, next_lat_counter;
    logic [2:0] out_counter, next_out_counter;
    logic [1:0] status_ff, next_status;
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
                if(wt_wr_ptr < 6'd63) next_wt_wr_ptr = wt_wr_ptr + 6'd1;
            end
            else if(ahb_wr_input) begin
                next_ahb_store_en = 1'b1;
                next_ahb_store_addr = IN_BASE + {7'd0, in_wr_ptr};
                next_ahb_store_data = hwdata;
                if(in_wr_ptr < 3'd7) next_in_wr_ptr = in_wr_ptr + 3'd1;
            end
        end
        
        case(state)
            IDLE: begin
                if(ctrl_reg[1]) begin
                    next_state = LOAD_WEIGHTS;
                    next_status[1] = 1'b1; 
                    next_wt_counter = 6'd0;
                    next_status[0] = 1'b0;
                end
                else if(ctrl_reg[0]) begin
                    next_state = INFER_FEED;
                    next_status[1] = 1'b1; 
                    next_status[0] = 1'b0;
                    next_row_counter = 3'd0;
                    next_lat_counter = 6'd0;
                    next_out_counter = 3'd0;
                end
            end
            LOAD_WEIGHTS: begin
                if(sram_state == SRAM_BUSY) next_state = WT_SRAM_WAIT;
            end
            WT_SRAM_WAIT: begin
                if(sram_state == SRAM_ACCESS) begin
                    if(wt_counter == 6'd63) begin
                        next_state = WT_DONE;
                        next_wt_counter = 6'd0;
                    end else begin
                        next_wt_counter = wt_counter + 6'd1;
                        next_state = LOAD_WEIGHTS;
                    end
                end
            end
            WT_DONE: begin
                next_state = IDLE;
                next_status[1] = 1'b0; 
            end
            
            INFER_FEED: begin
                next_lat_counter = lat_counter + 6'd1;
                if(sram_state == SRAM_BUSY) next_state = IN_SRAM_WAIT;
            end
            IN_SRAM_WAIT: begin
                next_lat_counter = lat_counter + 6'd1;
                if(sram_state == SRAM_ACCESS) begin
                    if(row_counter == 3'd7) begin
                        next_state = INFER_DRAIN;
                        next_row_counter = 3'd0;
                    end else begin
                        next_row_counter = row_counter + 3'd1;
                        next_state = INFER_FEED;
                    end
                end
            end
            INFER_DRAIN: begin
                next_lat_counter = lat_counter + 6'd1;
                // Give pipeline enough cycles to flush before capturing
                if(lat_counter >= 6'd40) next_state = CAPTURE_OUT;
            end
            
            // === FIXED CAPTURE LOGIC: Stream data dynamically! ===
            CAPTURE_OUT: begin
                if (inference_complete) begin
                    if (out_counter == 3'd7) begin
                        next_state = DONE;
                        next_out_counter = 3'd0;
                    end else begin
                        next_out_counter = out_counter + 3'd1;
                    end
                end
            end
            
            DONE: begin
                next_state = IDLE;
                next_status[0] = 1'b1; 
                next_status[1] = 1'b0;
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
            end
            LOAD_WEIGHTS, WT_SRAM_WAIT: begin
                sram_rd_en = 1'b1;
                sram_addr = WT_BASE + {4'd0, wt_counter};
                if(sram_state == SRAM_ACCESS) begin
                    load_weights = 1'b1;
                    input_vec = sram_rd_data;
                end
            end
            WT_DONE: begin
                ctrl_reg_clear[1] = 1'b1; 
            end
            INFER_FEED, IN_SRAM_WAIT: begin
                sram_rd_en = 1'b1;
                sram_addr = IN_BASE + {7'd0, row_counter}; 
                if(sram_state == SRAM_ACCESS) begin
                    run_array = 1'b1;
                    input_vec = sram_rd_data;
                end
            end
            INFER_DRAIN: begin
                run_array = 1'b1; // Keep pushing array so it doesn't freeze
            end
            
            CAPTURE_OUT: begin
                run_array = 1'b1; // Keep data moving!
                if(inference_complete) begin
                    sram_wr_en = 1'b1;
                    sram_addr = OUT_BASE + {7'd0, out_counter};
                    sram_wr_data = activations;
                end
            end
            
            DONE: begin
                ctrl_reg_clear[0] = 1'b1; 
            end
        endcase
    end
endmodule

