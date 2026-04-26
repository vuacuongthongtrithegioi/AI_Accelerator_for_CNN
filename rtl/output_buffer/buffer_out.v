module buffer_out (
    clk, reset, load,
    c1_in, c2_in, c3_in, 
    c4_in, c5_in, c6_in, 
    c7_in, c8_in, c9_in, 
    c1_out, c2_out, c3_out,
    c4_out, c5_out, c6_out,
    c7_out, c8_out, c9_out
);
    input clk, reset;
    input load;
    input signed [47:0] c1_in, c2_in, c3_in;
    input signed [47:0] c4_in, c5_in, c6_in;
    input signed [47:0] c7_in, c8_in, c9_in;
    output signed [47:0] c1_out, c2_out, c3_out;
    output signed [47:0] c4_out, c5_out, c6_out;
    output signed [47:0] c7_out, c8_out, c9_out;

    reg signed [47:0] rC1, rC2, rC3;
    reg signed [47:0] rC4, rC5, rC6;
    reg signed [47:0] rC7, rC8, rC9;

    always @(posedge clk) begin
        if (reset) begin
            rC1<=0; rC2<=0; rC3<=0;
            rC4<=0; rC5<=0; rC6<=0;
            rC7<=0; rC8<=0; rC9<=0;
        end
        else if (load) begin
            rC1<=c1_in; rC2<=c2_in; rC3<=c3_in;
            rC4<=c4_in; rC5<=c5_in; rC6<=c6_in;
            rC7<=c7_in; rC8<=c8_in; rC9<=c9_in;
        end
    end

    assign c1_out = rC1;
    assign c2_out = rC2;
    assign c3_out = rC3;
    assign c4_out = rC4;
    assign c5_out = rC5;
    assign c6_out = rC6;
    assign c7_out = rC7;
    assign c8_out = rC8;
    assign c9_out = rC9;

endmodule