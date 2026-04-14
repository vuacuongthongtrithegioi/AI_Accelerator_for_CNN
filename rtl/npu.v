module NPU (clk, reset, start, IFM, WGT, done, c1_out, c2_out, c3_out, c4_out, c5_out, c6_out, c7_out, c8_out, c9_out);
    input clk, reset, start;
    input [215:0] IFM;
    input [215:0] WGT;
    output done;
    output [47:0] c1_out, c2_out, c3_out; 
    output [47:0] c4_out, c5_out, c6_out;
    output [47:0] c7_out, c8_out, c9_out;

    wire [23:0] a1, a2, a3;
    wire [23:0] b1, b2, b3;

    wire [23:0] a1_mac, a2_mac, a3_mac;
    wire [23:0] b1_mac, b2_mac, b3_mac;

    wire [47:0] c1_mac, c2_mac, c3_mac;
    wire [47:0] c4_mac, c5_mac, c6_mac;
    wire [47:0] c7_mac, c8_mac, c9_mac;

    wire done_input_buffer, done_mac;

    systolic_input_buffer input_buffer (
        .clk(clk),
        .reset(reset),
        .start(start),
        .IFM(IFM),
        .WGT(WGT),
        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3),
        .done(done_input_buffer)
    );

    mac_top mac (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a1(a1_mac), .a2(a2_mac), .a3(a3_mac),
        .b1(b1_mac), .b2(b2_mac), .b3(b3_mac),
        .c1(c1_mac), .c2(c2_mac), .c3(c3_mac),
        .c4(c4_mac), .c5(c5_mac), .c6(c6_mac),
        .c7(c7_mac), .c8(c8_mac), .c9(c9_mac),
        .done(done_mac)
    );

    assign done = done_input_buffer & done_mac;
    assign c1_out = c1_mac;
    assign c2_out = c2_mac;
    assign c3_out = c3_mac;
    assign c4_out = c4_mac;
    assign c5_out = c5_mac;
    assign c6_out = c6_mac;
    assign c7_out = c7_mac;
    assign c8_out = c8_mac;
    assign c9_out = c9_mac;
endmodule