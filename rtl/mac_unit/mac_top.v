module mac_top #(parameter DW=24)(
    input clk, reset, start,

    input [DW-1:0] a1,a2,a3,
    input [DW-1:0] b1,b2,b3,

    output [DW-1:0] c1,c2,c3,
    output [DW-1:0] c4,c5,c6,
    output [DW-1:0] c7,c8,c9,

    output done
);

    wire clear, valid;
    wire [2:0] cycle;

    SystolicController ctrl (
        .clk(clk),
        .reset(reset),
        .start(start),

        .clear(clear),
        .valid(valid),
        .done(done),
        .cycle(cycle)
    );

    wire [DW-1:0] a1_g, a2_g, a3_g;
    wire [DW-1:0] b1_g, b2_g, b3_g;

    assign a1_g = valid ? a1 : 0;
    assign a2_g = valid ? a2 : 0;
    assign a3_g = valid ? a3 : 0;

    assign b1_g = valid ? b1 : 0;
    assign b2_g = valid ? b2 : 0;
    assign b3_g = valid ? b3 : 0;

    matrix_multiplication systolic (
        .clk(clk),
        .reset(reset),
        .clear(clear),

        .a1(a1_g), .a2(a2_g), .a3(a3_g),
        .b1(b1_g), .b2(b2_g), .b3(b3_g),

        .c1(c1), .c2(c2), .c3(c3),
        .c4(c4), .c5(c5), .c6(c6),
        .c7(c7), .c8(c8), .c9(c9)
    );

endmodule