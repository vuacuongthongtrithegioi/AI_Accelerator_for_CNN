module tb ();
    reg clk, reset, start;
    reg [215:0] IFM, WGT;
    wire done;
    wire done_input_buffer, done_mac;
    wire done_cut_bit, done_relu, done_output_buffer;
    wire signed [23:0] c1_out, c2_out, c3_out;
    wire signed [23:0] c4_out, c5_out, c6_out; 
    wire signed [23:0] c7_out, c8_out, c9_out;

    NPU npu (
        .clk(clk),
        .reset(reset),
        .start(start),
        .IFM_in(IFM),
        .WGT_in(WGT),
        .done_input_buffer(done_input_buffer),
        .done_mac(done_mac),
        .done_cut_bit(done_cut_bit),
        .done_relu(done_relu),
        .done_output_buffer(done_output_buffer),
        .cout_1(c1_out), .cout_2(c2_out), .cout_3(c3_out),
        .cout_4(c4_out), .cout_5(c5_out), .cout_6(c6_out),
        .cout_7(c7_out), .cout_8(c8_out), .cout_9(c9_out),
        .done_npu(done)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        IFM = {
            24'd6554,   24'd13107,  24'd19661,
            24'd26214,  24'd32768,  24'd39322,
            24'd45875,  24'd52429,  24'd58982
        };

        WGT = {
            24'd6554,   24'd13107,  24'd19661,
            24'd26214,  24'd32768,  24'd39322,
            24'd45875,  24'd52429,  24'd58982
        };
        #10;
        reset = 0; 
        start = 1;
        #10;
        start = 0;
        #1000 $finish;
    end

    initial begin
        $dumpfile("npu_tb.vcd");
        $dumpvars();
    end
endmodule