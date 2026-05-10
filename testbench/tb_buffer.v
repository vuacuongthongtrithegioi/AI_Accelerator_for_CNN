`timescale 1ns/1ps

module tb ();

    parameter DW = 216;
    parameter DEPTH = 4;

    reg clk, reset;
    reg start, mode;

    reg  signed [DW-1:0] data_in;
    wire signed [DW-1:0] data_out;

    wire full;
    wire empty;
    wire done;

    buffer_top #(
        .DW(DW),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .reset(reset),

        .start(start),
        .mode(mode),

        .data_in(data_in),
        .data_out(data_out),

        .full(full),
        .empty(empty),

        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk     = 0;
        reset   = 1;
        start   = 0;
        mode    = 0;
        data_in = 0;
        #15;
        reset = 0;
        start = 1;
        mode  = 0;
        data_in = {
            24'd1, 24'd2, 24'd3,
            24'd4, 24'd5, 24'd6,
            24'd7, 24'd8, 24'd9
        };
        #10;
        start = 0;
        #20;
        start = 1;
        data_in = {
            24'd0, 24'd0, 24'd1,
            24'd1, 24'd0, 24'd0,
            24'd0, 24'd1, 24'd1
        };
        #10;
        start = 0;
        #20;
        start = 1;
        data_in = {
            24'd5, 24'd0, 24'd1,
            24'd1, 24'd7, 24'd9,
            24'd0, 24'd1, 24'd1
        };
        #10;
        start = 0;
        #20;
        start = 1;
        data_in = {
            24'd5, 24'd3, 24'd1,
            24'd1, 24'd5, 24'd9,
            24'd0, 24'd1, 24'd1
        };
        #10;
        start = 0;
        #20;
        start = 1;
        data_in = {
            24'd2, 24'd4, 24'd6,
            24'd1, 24'd5, 24'd8,
            24'd0, 24'd1, 24'd1
        };
        #10;
        start = 0;
        #20;
        start = 1;
        mode = 1;
        #10;
        start = 0;
        #20;
        start = 1;
        #10;
        start = 0;
        #20;
        start = 1;
        #10;
        start = 0;
        #20;
        start = 1;
        #10;
        start = 0;
        #20;
        start = 1;
        #10;
        start = 0;
        #100;
        $finish;
    end
    initial begin
        $dumpfile("tb_buffer.vcd");
        $dumpvars(0, tb);
    end

endmodule