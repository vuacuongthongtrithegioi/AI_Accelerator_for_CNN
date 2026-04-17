module ReLU (
    input clk, reset, relu_en,

    input signed [47:0] in_0, in_1, in_2,
    input signed [47:0] in_3, in_4, in_5,
    input signed [47:0] in_6, in_7, in_8,

    output signed [47:0] out_0, out_1, out_2,
    output signed [47:0] out_3, out_4, out_5,
    output signed [47:0] out_6, out_7, out_8
);

    reg signed [47:0] out_0_reg, out_1_reg, out_2_reg;
    reg signed [47:0] out_3_reg, out_4_reg, out_5_reg;
    reg signed [47:0] out_6_reg, out_7_reg, out_8_reg;

    always @(posedge clk) begin
        if (reset) begin
            out_0_reg <= 0; out_1_reg <= 0; out_2_reg <= 0;
            out_3_reg <= 0; out_4_reg <= 0; out_5_reg <= 0;
            out_6_reg <= 0; out_7_reg <= 0; out_8_reg <= 0;
        end
        else if (relu_en) begin
            out_0_reg <= (in_0 < 0) ? 0 : in_0;
            out_1_reg <= (in_1 < 0) ? 0 : in_1;
            out_2_reg <= (in_2 < 0) ? 0 : in_2;

            out_3_reg <= (in_3 < 0) ? 0 : in_3;
            out_4_reg <= (in_4 < 0) ? 0 : in_4;
            out_5_reg <= (in_5 < 0) ? 0 : in_5;

            out_6_reg <= (in_6 < 0) ? 0 : in_6;
            out_7_reg <= (in_7 < 0) ? 0 : in_7;
            out_8_reg <= (in_8 < 0) ? 0 : in_8;
        end
    end

    assign out_0 = out_0_reg;
    assign out_1 = out_1_reg;
    assign out_2 = out_2_reg;
    assign out_3 = out_3_reg;
    assign out_4 = out_4_reg;
    assign out_5 = out_5_reg;
    assign out_6 = out_6_reg;
    assign out_7 = out_7_reg;
    assign out_8 = out_8_reg;

endmodule

 