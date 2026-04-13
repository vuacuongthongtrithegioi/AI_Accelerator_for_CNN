module pe(
    clk, reset, clear,
    in_a, in_b,
    out_a, out_b,
    out_c
);
    input wire clk, reset, clear;
    input wire [23:0] in_a, in_b;
    output reg [23:0] out_a, out_b;
    output reg [47:0] out_c;

    always @(posedge clk) begin
        if (reset || clear) begin
            out_a <= 0;
            out_b <= 0;
            out_c <= 0;
        end else begin
            out_a <= in_a;
            out_b <= in_b;
            out_c <= out_c + in_a * in_b;
        end
    end
endmodule