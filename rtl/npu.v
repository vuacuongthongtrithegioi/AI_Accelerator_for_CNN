module NPU (clk, reset, start, 
    IFM, WGT, done, 
    c1_out, c2_out, c3_out, 
    c4_out, c5_out, c6_out, 
    c7_out, c8_out, c9_out, 
    done_input_buffer, done_mac, done_q, done_relu);

    input clk, reset, start;
    input [215:0] IFM;
    input [215:0] WGT;
    output done;
    output signed [47:0] c1_out, c2_out, c3_out; 
    output signed [47:0] c4_out, c5_out, c6_out;
    output signed [47:0] c7_out, c8_out, c9_out;
    output done_input_buffer, done_mac, done_q, done_relu;

    wire signed [23:0] a1, a2, a3;
    wire signed [23:0] b1, b2, b3;

    wire signed [47:0] c1_mac, c2_mac, c3_mac;
    wire signed [47:0] c4_mac, c5_mac, c6_mac;
    wire signed [47:0] c7_mac, c8_mac, c9_mac;

    wire signed [47:0] q1_mac, q2_mac, q3_mac;
    wire signed [47:0] q4_mac, q5_mac, q6_mac;
    wire signed [47:0] q7_mac, q8_mac, q9_mac;

    wire signed [47:0] relu1_mac, relu2_mac, relu3_mac;
    wire signed [47:0] relu4_mac, relu5_mac, relu6_mac;
    wire signed [47:0] relu7_mac, relu8_mac, relu9_mac;

    systolic_input_top input_buffer (
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
        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3),
        .c1(c1_mac), .c2(c2_mac), .c3(c3_mac),
        .c4(c4_mac), .c5(c5_mac), .c6(c6_mac),
        .c7(c7_mac), .c8(c8_mac), .c9(c9_mac),
        .done(done_mac)
    );

    Q16_32_to_Q8_16_pipe cut_bit (
        .clk(clk),
        .reset(reset),
        .enable(done_mac),
        .din_0(c1_mac), .din_1(c2_mac), .din_2(c3_mac),
        .din_3(c4_mac), .din_4(c5_mac), .din_5(c6_mac),
        .din_6(c7_mac), .din_7(c8_mac), .din_8(c9_mac),
        .dout_0(q1_mac), .dout_1(q2_mac), .dout_2(q3_mac),
        .dout_3(q4_mac), .dout_4(q5_mac), .dout_5(q6_mac),
        .dout_6(q7_mac), .dout_7(q8_mac), .dout_8(q9_mac),
        .done(done_q)
    );

    ReLU relu (
        .clk(clk),
        .reset(reset),
        .relu_en(done_q),
        .done(done_relu),
        .in_0(q1_mac), .in_1(q2_mac), .in_2(q3_mac),
        .in_3(q4_mac), .in_4(q5_mac), .in_5(q6_mac),
        .in_6(q7_mac), .in_7(q8_mac), .in_8(q9_mac),
        .out_0(relu1_mac), .out_1(relu2_mac), .out_2(relu3_mac),
        .out_3(relu4_mac), .out_4(relu5_mac), .out_5(relu6_mac),
        .out_6(relu7_mac), .out_7(relu8_mac), .out_8(relu9_mac)
    );

    assign c1_out = relu1_mac;
    assign c2_out = relu2_mac;
    assign c3_out = relu3_mac;
    assign c4_out = relu4_mac;
    assign c5_out = relu5_mac;
    assign c6_out = relu6_mac;
    assign c7_out = relu7_mac;
    assign c8_out = relu8_mac;
    assign c9_out = relu9_mac;
    assign done = done_relu;
endmodule