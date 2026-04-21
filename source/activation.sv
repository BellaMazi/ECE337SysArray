`timescale 1ns / 10ps

module activation #(
    // parameters
) (
    input logic clk, n_rst, bias_valid_out,
    input logic [2:0] active_mode,
    input logic [63:0] bias_out,
    output logic inference_complete,
    output logic [63:0] activations
);
    logic [63:0] out_reg, out_next;
    logic valid_reg, valid_next;
    
    assign activations = out_reg;
    assign inference_complete = valid_reg;
    
    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            out_reg <= '0;
            valid_reg <= '0;
        end else begin
            out_reg <= out_next;
            valid_reg <= valid_next;
        end
    end
    
    always_comb begin
        out_next = out_reg;
        valid_next = bias_valid_out;
        for (int i = 0; i < 8; i++) begin
            automatic logic [7:0] val;
            automatic logic [3:0] exp;
            automatic logic [7:0] leaky_val;
            val = bias_out[(i*8)+7 -: 8];
            exp = val[6:3];
            if (exp <= 4'd2) begin
                leaky_val = 8'b0;
            end else if (exp == 4'hf) begin
                leaky_val = val;
            end else begin
                leaky_val = {val[7], exp - 4'd2, val[2:0]};
            end
            if (bias_valid_out) begin
                case (active_mode)
                    3'd0: out_next[(i*8)+7 -: 8] = (val[7]) ? 8'h00 : val; // relu
                    3'd1: out_next[(i*8)+7 -: 8] = (val[7]) ? 8'hb8 : 8'h38; // binary Step
                    3'd2: out_next[(i*8)+7 -: 8] = val; // identity
                    3'd3: out_next[(i*8)+7 -: 8] = (val[7]) ? leaky_val : val; // leaky relu
                    default: out_next[(i*8)+7 -: 8] = val; // default to identity
                endcase
            end
        end
    end
endmodule

