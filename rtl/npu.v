module NPU (clk, reset, start, IFM, WGT, done);
    input clk, reset, start;
    input [215:0] IFM;
    input [215:0] WGT;
    output done;

    wire [23:0] a1, a2, a3;
    wire [23:0] b1, b2, b3;

    wire [23:0] a1_mac, a2_mac, a3_mac;
    wire [23:0] b1_mac, b2_mac, b3_mac;

    wire done_input_buffer, done_mac;

    systolic_input_buffer input_buffer (
    
    );

    mac_top mac (
    
    );
endmodule