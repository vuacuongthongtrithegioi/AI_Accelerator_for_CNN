module systolic_input_top #(parameter DW=24)(
    input clk, reset, start,

    input [215:0] IFM,
    input [215:0] WGT,

    output [DW-1:0] a1,a2,a3,
    output [DW-1:0] b1,b2,b3,
    output done
);
    wire [2:0] cycle;
    wire load;

    wire [23:0] A00 = IFM[215:192];
    wire [23:0] A01 = IFM[191:168];
    wire [23:0] A02 = IFM[167:144];

    wire [23:0] A10 = IFM[143:120];
    wire [23:0] A11 = IFM[119:96];
    wire [23:0] A12 = IFM[95:72];

    wire [23:0] A20 = IFM[71:48];
    wire [23:0] A21 = IFM[47:24];
    wire [23:0] A22 = IFM[23:0];

    wire [23:0] B00 = WGT[215:192];
    wire [23:0] B01 = WGT[191:168];
    wire [23:0] B02 = WGT[167:144];

    wire [23:0] B10 = WGT[143:120];
    wire [23:0] B11 = WGT[119:96];
    wire [23:0] B12 = WGT[95:72];

    wire [23:0] B20 = WGT[71:48];
    wire [23:0] B21 = WGT[47:24];
    wire [23:0] B22 = WGT[23:0];

    systolic_input_buffer_ctl ctrl (
        .clk(clk),
        .reset(reset),
        .start(start),
        .load(load),
        .cycle(cycle),
        .done(done)
    );

    systolic_input_buffer buffer (
        .clk(clk),
        .reset(reset),
        .load(load),
        .cycle(cycle),

        .A00(A00), .A01(A01), .A02(A02),
        .A10(A10), .A11(A11), .A12(A12),
        .A20(A20), .A21(A21), .A22(A22),

        .B00(B00), .B01(B01), .B02(B02),
        .B10(B10), .B11(B11), .B12(B12),
        .B20(B20), .B21(B21), .B22(B22),

        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3)
    );

endmodule