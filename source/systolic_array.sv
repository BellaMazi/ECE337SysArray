`timescale 1ns / 10ps

module systolic_array (
    input logic clk, n_rst, 
    input logic load_weights, 
    input logic run_array,
    input logic [15:0] input_count,
    input logic [63:0] input_vec,
    output logic data_out_valid,
    output logic [63:0] outputs
);
    logic [7:0] x_reg [7:0][7:0];
    logic [7:0] y_reg [7:0][7:0];
    logic [7:0] w_reg [7:0][7:0];
    logic [7:0] w12_reg;
    logic [7:0] w13_regs [1:0];
    logic [7:0] w14_regs [2:0];
    logic [7:0] w15_regs [3:0];
    logic [7:0] w16_regs [4:0];
    logic [7:0] w17_regs [5:0];
    logic [7:0] w18_regs [6:0];
    logic [7:0] y_align [7:0][6:0];
    logic [7:0] x_in [7:0][7:0];
    logic [7:0] y_in [7:0][7:0];
    logic [7:0] x_w_mult [7:0][7:0];
    logic [7:0] full_sum [7:0][7:0];
    logic [63:0] outputs_reg, outputs_next;
    logic data_out_valid_reg, data_out_valid_next;
    logic [15:0] latency_counter;
    assign outputs = outputs_reg;
    assign data_out_valid = data_out_valid_reg;

    always_ff @ (posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            foreach(x_reg[i,j]) x_reg[i][j] <= '0;
            foreach(y_reg[i,j]) y_reg[i][j] <= '0;
            foreach(w_reg[i,j]) w_reg[i][j] <= '0;
            w12_reg <= '0;
            foreach(w13_regs[i]) w13_regs[i] <= '0;
            foreach(w14_regs[i]) w14_regs[i] <= '0;
            foreach(w15_regs[i]) w15_regs[i] <= '0;
            foreach(w16_regs[i]) w16_regs[i] <= '0;
            foreach(w17_regs[i]) w17_regs[i] <= '0;
            foreach(w18_regs[i]) w18_regs[i] <= '0;
            foreach(y_align[i,j]) y_align[i][j] <= '0;
            latency_counter <= '0;
            outputs_reg <= '0;
            data_out_valid_reg <= '0;
        end
        else begin
            outputs_reg <= outputs_next;
            data_out_valid_reg <= data_out_valid_next;

            if(load_weights) begin
                latency_counter <= '0; 
                w_reg[7] <= w_reg[6];
                w_reg[6] <= w_reg[5];
                w_reg[5] <= w_reg[4];
                w_reg[4] <= w_reg[3];
                w_reg[3] <= w_reg[2];
                w_reg[2] <= w_reg[1];
                w_reg[1] <= w_reg[0];
                w_reg[0][0] <= input_vec[7:0];
                w_reg[0][1] <= input_vec[15:8];
                w_reg[0][2] <= input_vec[23:16];
                w_reg[0][3] <= input_vec[31:24];
                w_reg[0][4] <= input_vec[39:32];
                w_reg[0][5] <= input_vec[47:40];
                w_reg[0][6] <= input_vec[55:48];
                w_reg[0][7] <= input_vec[63:56];
            end
            else if (!run_array) begin
                if (latency_counter > (16'd14 + input_count)) begin
                    latency_counter <= '0;
                end
            end
            else if(run_array) begin
                if (latency_counter < 16'hFFFF) begin
                    latency_counter <= latency_counter + 1;
                end

                w12_reg <= input_vec[15:8];
                w13_regs[0] <= input_vec[23:16];
                w13_regs[1] <= w13_regs[0];
                w14_regs[0] <= input_vec[31:24];
                w14_regs[1] <= w14_regs[0];
                w14_regs[2] <= w14_regs[1];
                w15_regs[0] <= input_vec[39:32];
                w15_regs[1] <= w15_regs[0];
                w15_regs[2] <= w15_regs[1];
                w15_regs[3] <= w15_regs[2];
                w16_regs[0] <= input_vec[47:40];
                w16_regs[1] <= w16_regs[0];
                w16_regs[2] <= w16_regs[1];
                w16_regs[3] <= w16_regs[2];
                w16_regs[4] <= w16_regs[3];
                w17_regs[0] <= input_vec[55:48];
                w17_regs[1] <= w17_regs[0];
                w17_regs[2] <= w17_regs[1];
                w17_regs[3] <= w17_regs[2];
                w17_regs[4] <= w17_regs[3];
                w17_regs[5] <= w17_regs[4];
                w18_regs[0] <= input_vec[63:56];
                w18_regs[1] <= w18_regs[0];
                w18_regs[2] <= w18_regs[1];
                w18_regs[3] <= w18_regs[2];
                w18_regs[4] <= w18_regs[3];
                w18_regs[5] <= w18_regs[4];
                w18_regs[6] <= w18_regs[5];
                for(int r = 0; r < 8; r = r + 1) begin
                    for(int c = 0; c < 8; c = c + 1) begin
                        x_reg[r][c] <= x_in[r][c];
                        y_reg[r][c] <= full_sum[r][c];
                    end
                end
                for(int j = 0; j < 7; j = j + 1) begin
                    y_align[j][0] <= y_reg[7][j];
                    for(int k = 1; k < 7 - j; k = k + 1) begin
                        y_align[j][k] <= y_align[j][k-1];
                    end
                end
            end
        end
    end

    generate
        genvar row, col;
        for(row = 0; row < 8; row = row + 1) begin : pe_rows
            for(col = 0; col < 8; col = col + 1) begin : pe_cols
                always_comb begin
                    if(col == 0) begin
                        case(row)
                            0: x_in[row][col] = input_vec[7:0];
                            1: x_in[row][col] = w12_reg;
                            2: x_in[row][col] = w13_regs[1];
                            3: x_in[row][col] = w14_regs[2];
                            4: x_in[row][col] = w15_regs[3];
                            5: x_in[row][col] = w16_regs[4];
                            6: x_in[row][col] = w17_regs[5];
                            7: x_in[row][col] = w18_regs[6];
                            default: x_in[row][col] = '0;
                        endcase
                    end else begin
                        x_in[row][col] = x_reg[row][col-1];
                    end
                    y_in[row][col] = (row == 0) ? '0 : y_reg[row-1][col];
                end
                fp_multiplier fm1 (.x_in(x_in[row][col]), .w_in(w_reg[row][col]), .mult_out(x_w_mult[row][col]));
                fp_adder fa1 (.mult_in(x_w_mult[row][col]), .y_in(y_in[row][col]), .full_sum(full_sum[row][col]));
            end
        end
    endgenerate

    always_comb begin : OutputLogic
        outputs_next = outputs_reg;
        data_out_valid_next = 1'b0;
        if(run_array) begin
            for(int j = 0; j < 8; j = j + 1) begin
                outputs_next[(j*8)+7 -: 8] = (j == 7) ? y_reg[7][7] : y_align[j][6-j];
            end
            if(latency_counter >= 16'd15 && latency_counter <= (16'd14 + input_count)) begin
                data_out_valid_next = 1'b1;
            end
        end
    end
endmodule

