module mac_unit_top #(parameter DW=24)(
    input clk,
    input reset,
    input start,

    input signed [215:0] IFM,
    input signed [215:0] WGT,

    output signed [47:0] c1,c2,c3,
    output signed [47:0] c4,c5,c6,
    output signed [47:0] c7,c8,c9,

    output done
);
    wire signed [DW-1:0] a1,a2,a3;
    wire signed [DW-1:0] b1,b2,b3;

    systolic_input_top input_buffer (
        .clk(clk),
        .reset(reset),
        .start(start),
        .IFM(IFM),
        .WGT(WGT),
        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3),
        .done()
    );

    mac_top mac (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3),
        .c1(c1), .c2(c2), .c3(c3),
        .c4(c4), .c5(c5), .c6(c6),
        .c7(c7), .c8(c8), .c9(c9),
        .done(done)
    );

endmodule