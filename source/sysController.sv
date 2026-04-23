`timescale 1ns / 10ps

module sysController (
    input logic clk, n_rst,
    input logic [1:0] ctrl_reg, 
    input logic [1:0] act_ctrl, 
    
    input logic [63:0] sram_rd_data, 
    input logic inference_complete, 
    input logic [63:0] activations,
    
    output logic sram_rd_en, sram_wr_en,
    output logic [9:0] sram_addr,
    output logic [63:0] sram_wr_data,
    output logic load_weights, run_array,
    output logic [63:0] input_vec,
    output logic [1:0] ctrl_reg_clear, 
    output logic [1:0] status_reg
);

    localparam [9:0] WT_BASE = 10'd0;
    localparam [9:0] IN_BASE = 10'd64;
    localparam [9:0] OUT_BASE = 10'd72;

    typedef enum logic [3:0] {
        IDLE = 4'd0,
        LOAD_WEIGHTS = 4'd1,
        INFER_FEED = 4'd2,
        WAIT_AND_CAPTURE = 4'd3,
        DONE = 4'd4
    } state_t;

    state_t state, next_state;
    logic [5:0] wt_counter, next_wt_counter;
    logic [2:0] row_counter, next_row_counter;
    logic [2:0] out_counter, next_out_counter;
    logic [1:0] status_ff, next_status;

    assign status_reg = status_ff;

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
            wt_counter <= '0; row_counter <= '0; out_counter <= '0;
            status_ff <= 2'b00;
        end else begin
            state <= next_state;
            wt_counter <= next_wt_counter;
            row_counter <= next_row_counter;
            out_counter <= next_out_counter;
            status_ff <= next_status;
        end
    end

    always_comb begin
        next_state = state;
        next_wt_counter = wt_counter;
        next_row_counter = row_counter;
        next_out_counter = out_counter;
        next_status = status_ff;

        sram_rd_en = 1'b0; sram_wr_en = 1'b0;
        sram_addr = 10'd0; sram_wr_data = 64'd0;
        load_weights = 1'b0; run_array = 1'b0; input_vec = 64'd0;
        ctrl_reg_clear = 2'b00;

        case(state)
            IDLE: begin
                if(ctrl_reg[1]) begin
                    next_state = LOAD_WEIGHTS;
                    next_status[1] = 1'b1; // busy
                    next_status[0] = 1'b0;
                    next_wt_counter = 0;
                end else if(ctrl_reg[0]) begin
                    next_state = INFER_FEED;
                    next_status[1] = 1'b1; // busy
                    next_status[0] = 1'b0;
                    next_row_counter = 0;
                    next_out_counter = 0;
                end
            end

            LOAD_WEIGHTS: begin
                sram_rd_en = 1'b1;
                sram_addr = WT_BASE + {4'd0, wt_counter};
                load_weights = 1'b1;
                input_vec = sram_rd_data;
                
                if(wt_counter == 6'd63) begin
                    next_state = DONE;
                    ctrl_reg_clear[1] = 1'b1;
                end else begin
                    next_wt_counter = wt_counter + 6'd1;
                end
            end

            INFER_FEED: begin
                sram_rd_en = 1'b1;
                sram_addr = IN_BASE + {7'd0, row_counter};
                run_array = 1'b1;
                input_vec = sram_rd_data;
                
                if(row_counter == 3'd7) begin
                    next_state = WAIT_AND_CAPTURE;
                end else begin
                    next_row_counter = row_counter + 3'd1;
                end
            end

            WAIT_AND_CAPTURE: begin
                run_array = 1'b1;
                input_vec = 64'd0; 
                
                if (inference_complete) begin
                    sram_wr_en = 1'b1;
                    sram_addr = OUT_BASE + {7'd0, out_counter};
                    sram_wr_data = activations;
                    
                    if (out_counter == 3'd7) begin
                        next_state = DONE;
                        ctrl_reg_clear[0] = 1'b1; 
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
endmodule

