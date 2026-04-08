module mac_unit(
    clk, reset, clear,
    ifm1, ifm2, ifm3,
    weight1, weight2, weight3,
    ofm1, ofm2, ofm3,
    ofm4, ofm5, ofm6,
    ofm7, ofm8, ofm9
);

    input wire clk, reset, clear;
    input wire [23:0] ifm1, ifm2, ifm3;
    input wire [23:0] weight1, weight2, weight3;
    output wire [23:0] ofm1, ofm2, ofm3;
    output wire [23:0] ofm4, ofm5, ofm6;
    output wire [23:0] ofm7, ofm8, ofm9;

    wire [23:0] ifm12, ifm23, ifm45, ifm56, ifm78, ifm89;
    wire [23:0] weight14, weight25, weight36, weight47, weight58, weight69;

    wire [47:0] pe_ofm1, pe_ofm2, pe_ofm3, 
                pe_ofm4, pe_ofm5, pe_ofm6,
                pe_ofm7, pe_ofm8, pe_ofm9;

    pe pe1 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm1),  .in_b(weight1),  .out_a(ifm12), .out_b(weight14), .out_c(pe_ofm1));
    pe pe2 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm12), .in_b(weight2),  .out_a(ifm23), .out_b(weight25), .out_c(pe_ofm2));
    pe pe3 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm23), .in_b(weight3),  .out_a(),      .out_b(weight36), .out_c(pe_ofm3));

    pe pe4 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm2),  .in_b(weight14), .out_a(ifm45), .out_b(weight47), .out_c(pe_ofm4));
    pe pe5 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm45), .in_b(weight25), .out_a(ifm56), .out_b(weight58), .out_c(pe_ofm5));
    pe pe6 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm56), .in_b(weight36), .out_a(),      .out_b(weight69), .out_c(pe_ofm6));

    pe pe7 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm3),  .in_b(weight47), .out_a(ifm78), .out_b(),         .out_c(pe_ofm7));
    pe pe8 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm78), .in_b(weight58), .out_a(ifm89), .out_b(),         .out_c(pe_ofm8));
    pe pe9 (.clk(clk), .reset(reset), .clear(clear), .in_a(ifm89), .in_b(weight69), .out_a(),      .out_b(),         .out_c(pe_ofm9));

    assign ofm1 = pe_ofm1[23:0];
    assign ofm2 = pe_ofm2[23:0];
    assign ofm3 = pe_ofm3[23:0];
    assign ofm4 = pe_ofm4[23:0];
    assign ofm5 = pe_ofm5[23:0];
    assign ofm6 = pe_ofm6[23:0];
    assign ofm7 = pe_ofm7[23:0];
    assign ofm8 = pe_ofm8[23:0];
    assign ofm9 = pe_ofm9[23:0];

endmodule