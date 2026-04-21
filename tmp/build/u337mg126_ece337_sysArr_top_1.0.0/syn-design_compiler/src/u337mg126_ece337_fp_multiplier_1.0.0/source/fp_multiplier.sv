module fp_multiplier (
    input logic [7:0] x_in, w_in,
    output logic [7:0] mult_out
);
    logic s1, s2;
    logic [3:0] e1, e2;
    logic [2:0] m1_frac, m2_frac;
    assign {s1, e1, m1_frac} = x_in;
    assign {s2, e2, m2_frac} = w_in;
    logic is_zero1, is_zero2, is_inf1, is_inf2, is_nan1, is_nan2;
    assign is_zero1 = (e1 == 0);
    assign is_zero2 = (e2 == 0);
    assign is_inf1  = (e1 == 4'hf && m1_frac == 0);
    assign is_inf2  = (e2 == 4'hf && m2_frac == 0);
    assign is_nan1  = (e1 == 4'hf && m1_frac != 0);
    assign is_nan2  = (e2 == 4'hf && m2_frac != 0);
    logic [3:0] m1, m2;
    assign m1 = is_zero1 ? 4'b0 : {1'b1, m1_frac};
    assign m2 = is_zero2 ? 4'b0 : {1'b1, m2_frac};
    logic res_s;
    logic signed [5:0] exp_sum;
    logic [7:0] prod_m;
    assign res_s = s1 ^ s2;
    assign exp_sum = {2'b0, e1} + {2'b0, e2} - 6'sd7;
    assign prod_m = m1 * m2;
    logic [3:0] norm_m;
    logic G, R, S;
    logic round_up;
    logic [4:0] rounded_m;
    logic signed [5:0] final_exp;

    always_comb begin
        norm_m = '0;
        G = 1'b0;
        R = 1'b0;
        S = 1'b0;
        final_exp = '0;
        round_up = 1'b0;
        rounded_m = '0;
        mult_out = '0;

        if (is_nan1 || is_nan2 || (is_inf1 && is_zero2) || (is_zero1 && is_inf2)) begin
            mult_out = {1'b0, 4'hf, 3'b001};
        end else if (is_inf1 || is_inf2) begin
            mult_out = {res_s, 4'hf, 3'b000};
        end else if (is_zero1 || is_zero2) begin
            mult_out = {res_s, 7'b0};
        end else begin
            if (prod_m[7]) begin
                norm_m = prod_m[7:4];
                G = prod_m[3];
                R = prod_m[2];
                S = prod_m[1] | prod_m[0];
                final_exp = exp_sum + 1;
            end else begin
                norm_m = prod_m[6:3];
                G = prod_m[2];
                R = prod_m[1];
                S = prod_m[0];
                final_exp = exp_sum;
            end
            round_up = G & (R | S | norm_m[0]);
            rounded_m = {1'b0, norm_m} + {4'b0, round_up};
            if (rounded_m[4]) begin
                rounded_m = rounded_m >> 1;
                final_exp = final_exp + 1;
            end
            if (final_exp >= 15) begin
                mult_out = {res_s, 4'hf, 3'b000};
            end else if (final_exp <= 0) begin
                mult_out = {res_s, 7'b0};
            end else begin
                mult_out = {res_s, final_exp[3:0], rounded_m[2:0]};
            end
        end
    end
endmodule

