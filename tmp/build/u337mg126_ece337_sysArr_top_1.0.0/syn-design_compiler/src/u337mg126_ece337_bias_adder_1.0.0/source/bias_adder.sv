`timescale 1ns / 10ps

module bias_adder (
    input logic clk, n_rst, data_out_valid,
    input logic [63:0] outputs, bias,
    output logic [63:0] bias_out,
    output logic bias_valid_out
);
    logic bias_valid_reg;
    logic [63:0] bias_out_reg;
    logic [63:0] bias_out_next;
    logic bias_valid_next;
    logic [7:0] fp_sum_wire [7:0];
   
    assign bias_out = bias_out_reg;
    assign bias_valid_out = bias_valid_reg;
   
    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            bias_out_reg   <= '0;
            bias_valid_reg <= '0;
        end
        else begin
            bias_out_reg   <= bias_out_next;
            bias_valid_reg <= bias_valid_next;
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
        if (data_out_valid) begin
            for(int j = 0; j < 8; j++) begin
                bias_out_next[(j*8) + 7 -: 8] = fp_sum_wire[j];
            end  
        end else begin
            bias_out_next = '0;
        end
    end
endmodule
