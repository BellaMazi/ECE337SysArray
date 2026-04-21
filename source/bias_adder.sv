`timescale 1ns / 10ps

module bias_adder (
    input logic clk, n_rst, data_out_valid,
    input logic [63:0] outputs, bias,
    output logic [63:0] bias_out,
    output logic bias_valid_out,
    output logic nan_err,
    output logic inf_err
);
    logic bias_valid_reg, bias_valid_next;
    logic [63:0] bias_out_reg, bias_out_next;
    logic nan_err_reg, nan_err_next;
    logic inf_err_reg, inf_err_next;
    logic [7:0] fp_sum_wire [7:0];
    assign bias_out = bias_out_reg;
    assign bias_valid_out = bias_valid_reg;
    assign nan_err = nan_err_reg;
    assign inf_err = inf_err_reg;
    
    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            bias_out_reg <= '0;
            bias_valid_reg <= '0;
            nan_err_reg <= '0;
            inf_err_reg <= '0;
        end
        else begin
            bias_out_reg <= bias_out_next;
            bias_valid_reg <= bias_valid_next;
            nan_err_reg <= nan_err_next;
            inf_err_reg <= inf_err_next;
        end
    end
    
    generate
        genvar i;
        for(i = 0; i < 8; i++) begin : fp_bias_adders
            fp_adder fa_inst (
                .mult_in(outputs[(i*8) + 7 -: 8]),
                .y_in(bias[(i*8) + 7 -: 8]),
                .full_sum(fp_sum_wire[i])
            );
        end
    endgenerate
    
    always_comb begin : OutputLogic
        bias_out_next = bias_out_reg;
        bias_valid_next = data_out_valid;
        nan_err_next = 1'b0;
        inf_err_next = 1'b0;
        if (data_out_valid) begin
            for(int j = 0; j < 8; j++) begin
                bias_out_next[(j*8) + 7 -: 8] = fp_sum_wire[j];
                if (fp_sum_wire[j][6:3] == 4'b1111) begin
                    if (fp_sum_wire[j][2:0] == 3'b000) begin
                        inf_err_next = 1'b1;
                    end else begin
                        nan_err_next = 1'b1;
                    end
                end
            end   
        end
    end
endmodule

