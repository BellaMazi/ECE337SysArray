`timescale 1ns / 10ps

module fp_adder (
    input logic [7:0] mult_in, y_in,
    output logic [7:0] full_sum
);
    logic s1, s2;
    logic [3:0] e1, e2;
    logic [2:0] f1, f2;
    assign {s1, e1, f1} = mult_in;
    assign {s2, e2, f2} = y_in;
    logic is_zero1, is_zero2, is_inf1, is_inf2, is_nan1, is_nan2;
    assign is_zero1 = (e1 == 0);
    assign is_zero2 = (e2 == 0);
    assign is_inf1  = (e1 == 4'hf && f1 == 0);
    assign is_inf2  = (e2 == 4'hf && f2 == 0);
    assign is_nan1  = (e1 == 4'hf && f1 != 0);
    assign is_nan2  = (e2 == 4'hf && f2 != 0);
    logic [3:0] m1, m2;
    assign m1 = is_zero1 ? 4'b0 : {1'b1, f1};
    assign m2 = is_zero2 ? 4'b0 : {1'b1, f2};
    logic sA, sB;
    logic [3:0] eA, eB;
    logic [3:0] mA, mB;
    logic A_is_larger;
    assign A_is_larger = (e1 > e2) || (e1 == e2 && m1 >= m2);
    always_comb begin
        if (A_is_larger) begin
            sA = s1; eA = e1; mA = m1;
            sB = s2; eB = e2; mB = m2;
        end else begin
            sA = s2; eA = e2; mA = m2;
            sB = s1; eB = e1; mB = m1;
        end
    end
    logic [3:0] exp_diff;
    logic [7:0] mB_aligned;
    logic [7:0] mA_ext;
    logic sticky;
    assign exp_diff = eA - eB;
    assign mA_ext = {mA, 4'b0};
    always_comb begin
        if (exp_diff > 5) begin
            mB_aligned = 8'b0;
            sticky = (mB != 0);
        end else begin
            mB_aligned = {mB, 4'b0} >> exp_diff;
            sticky = (exp_diff == 0) ? 1'b0 : (( {mB, 4'b0} << (8 - exp_diff) ) != 0);
        end
    end
    logic do_sub;
    logic [8:0] sum_m;
    assign do_sub = (sA != sB);
    always_comb begin
        if (do_sub) begin
            sum_m = mA_ext - mB_aligned;
        end else begin
            sum_m = mA_ext + mB_aligned;
        end
    end
    logic [3:0] norm_m;
    logic G, R, S;
    logic round_up;
    logic [4:0] rounded_m;
    logic signed [5:0] final_exp;
    logic [3:0] shift_amt;
    logic [7:0] shifted_sum;
    
    always_comb begin
        norm_m = '0;
        G = 1'b0;
        R = 1'b0;
        S = 1'b0;
        final_exp = '0;
        shift_amt = '0;
        shifted_sum = '0;
        round_up = 1'b0;
        rounded_m = '0;
        full_sum = '0;

        if (is_nan1 || is_nan2) begin
            full_sum = {1'b0, 4'hf, 3'b001};
        end else if (is_inf1 && is_inf2 && do_sub) begin
            full_sum = {1'b0, 4'hf, 3'b001};
        end else if (is_inf1 || is_inf2) begin
            full_sum = {sA, 4'hf, 3'b000};
        end else if (is_zero1 && is_zero2) begin
            full_sum = {sA & sB, 7'b0};
        end else if (sum_m == 0) begin
            full_sum = 8'b0;
        end else begin
            if (sum_m[8]) begin
                norm_m = sum_m[8:5];
                G = sum_m[4]; R = sum_m[3]; S = (sum_m[2:0] != 0) | sticky;
                final_exp = {2'b0, eA} + 1;
            end else begin
                if (sum_m[7]) shift_amt = 0;
                else if (sum_m[6]) shift_amt = 1;
                else if (sum_m[5]) shift_amt = 2;
                else if (sum_m[4]) shift_amt = 3;
                else if (sum_m[3]) shift_amt = 4;
                else shift_amt = 5;
                shifted_sum = sum_m[7:0] << shift_amt;
                norm_m = shifted_sum[7:4];
                G = shifted_sum[3]; R = shifted_sum[2]; S = (shifted_sum[1:0] != 0) | sticky;
                final_exp = {2'b0, eA} - {2'b0, shift_amt};
            end
            round_up = G & (R | S | norm_m[0]);
            rounded_m = {1'b0, norm_m} + {4'b0, round_up};
            if (rounded_m[4]) begin
                rounded_m = rounded_m >> 1;
                final_exp = final_exp + 1;
            end
            if (final_exp >= 15) begin
                full_sum = {sA, 4'hf, 3'b000};
            end else if (final_exp <= 0) begin
                full_sum = {sA, 7'b0};
            end else begin
                full_sum = {sA, final_exp[3:0], rounded_m[2:0]};
            end
        end
    end
endmodule

