`timescale 1ns/1ps

module tb ();
    reg clk, reset, enable;
    reg signed [47:0] din;
    wire signed [23:0] dout;
    wire done;

    Q16_32_to_Q8_16_pipe u_dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .din(din),
        .dout(dout),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        enable = 0;
        din = 0;

        #10 reset = 0;

        din = 48'sd4026531840; 
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