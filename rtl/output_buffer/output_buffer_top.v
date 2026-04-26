module output_buffer_top (
    input clk, reset,
    input done_systolic,

    input signed [47:0] c1_in, c2_in, c3_in,
    input signed [47:0] c4_in, c5_in, c6_in,
    input signed [47:0] c7_in, c8_in, c9_in,

    output signed [47:0] c1_out, c2_out, c3_out,
    output signed [47:0] c4_out, c5_out, c6_out,
    output signed [47:0] c7_out, c8_out, c9_out,

    output reg done
);

    wire load;
    reg load_d;

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

    always @(posedge clk) begin
        if (reset) begin
            load_d <= 0;
            done <= 0;
        end else begin
            load_d <= load;
            done <= load_d;   
        end
    end 
endmodule