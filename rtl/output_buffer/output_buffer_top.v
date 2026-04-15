module output_buffer_top (
    input clk, reset,
    input done_systolic,

    input [47:0] c1_in, c2_in, c3_in,
    input [47:0] c4_in, c5_in, c6_in,
    input [47:0] c7_in, c8_in, c9_in,

    output [47:0] c1_out, c2_out, c3_out,
    output [47:0] c4_out, c5_out, c6_out,
    output [47:0] c7_out, c8_out, c9_out
);

    wire load;

    output_buffer_ctl out_ctl (
        .clk(clk), 
        .reset(reset),
        .done_sytolic(done_systolic),
        .load(load)
    );

    buffer_out u_buffer_out (
        .clk(clk), .reset(reset), .load(load),
        .c1_in(c1_in), .c2_in(c2_in), .c3_in(c3_in),
        .c4_in(c4_in), .c5_in(c5_in), .c6_in(c6_in),
        .c7_in(c7_in), .c8_in(c8_in), .c9_in(c9_in),
        .c1_out(c1_out), .c2_out(c2_out), .c3_out(c3_out),
        .c4_out(c4_out), .c5_out(c5_out), .c6_out(c6_out),
        .c7_out(c7_out), .c8_out(c8_out), .c9_out(c9_out)
    );

endmodule