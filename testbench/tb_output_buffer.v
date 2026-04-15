`timescale 1ns/1ps

module tb ();
    reg clk, reset, done_sytolic;

    reg [47:0] c1_in, c2_in, c3_in; 
    reg [47:0] c4_in, c5_in, c6_in; 
    reg [47:0] c7_in, c8_in, c9_in; 

    wire [47:0] c1_out, c2_out, c3_out;
    wire [47:0] c4_out, c5_out, c6_out;
    wire [47:0] c7_out, c8_out, c9_out;

    output_buffer_top dut (
        .clk(clk), .reset(reset), .done_sytolic(done_sytolic),
        .c1_in(c1_in), .c2_in(c2_in), .c3_in(c3_in),
        .c4_in(c4_in), .c5_in(c5_in), .c6_in(c6_in),
        .c7_in(c7_in), .c8_in(c8_in), .c9_in(c9_in),
        .c1_out(c1_out), .c2_out(c2_out), .c3_out(c3_out),
        .c4_out(c4_out), .c5_out(c5_out), .c6_out(c6_out),
        .c7_out(c7_out), .c8_out(c8_out), .c9_out(c9_out)
    );
    
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        done_sytolic = 0;
        c1_in = 48'h000000000001; c2_in = 48'h000000000002; c3_in = 48'h000000000003;
        c4_in = 48'h000000000004; c5_in = 48'h000000000005; c6_in = 48'h000000000006;
        c7_in = 48'h000000000007; c8_in = 48'h000000000008; c9_in = 48'h000000000009;
        #10;
        reset = 0; 
        #100;
        done_sytolic = 1;
        #10;
        done_sytolic = 0;
        #100 $finish;
    end

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars;
    end
endmodule