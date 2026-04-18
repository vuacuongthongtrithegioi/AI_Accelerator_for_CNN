`timescale 1ns/1ps

module tb ();
    reg clk, reset, enable;
    reg signed [47:0] din_0, din_1, din_2, din_3, din_4, din_5, din_6, din_7, din_8;
    wire signed [23:0] dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7, dout_8;
    wire done;

    Q16_32_to_Q8_16_pipe u_pipe (
        .clk(clk), .reset(reset), .enable(enable),
        .din_0(din_0), .din_1(din_1), .din_2(din_2), .din_3(din_3), .din_4(din_4),
        .din_5(din_5), .din_6(din_6), .din_7(din_7), .din_8(din_8),
        .dout_0(dout_0), .dout_1(dout_1), .dout_2(dout_2), .dout_3(dout_3), .dout_4(dout_4),
        .dout_5(dout_5), .dout_6(dout_6), .dout_7(dout_7), .dout_8(dout_8),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        enable = 0;
        #10 reset = 0;

        din_0 = 48'sd4026531840;
        din_1 = 48'sd4026531840;
        din_2 = 48'sd4026531840;
        din_3 = 48'sd4026531840;
        din_4 = 48'sd4026531840;
        din_5 = 48'sd4026531840;
        din_6 = 48'sd4026531840;
        din_7 = 48'sd4026531840;
        din_8 = 48'sd4026531840;
        enable = 1;
        #10 enable = 0;
        #100; 
        $finish;
    end

    initial begin
       $dumpfile("dump.vcd");
       $dumpvars();
    end
endmodule