module output_buffer #(parameter DW=48)(
    clk, reset, load,
    C00,C01,C02,
    C10,C11,C12,
    C20,C21,C22,
    out_cnt,
    data_out
);
    input clk, reset, load;
    input [DW-1:0] C00,C01,C02;
    input [DW-1:0] C10,C11,C12;
    input [DW-1:0] C20,C21,C22;
    input [3:0] out_cnt;
    output reg [DW-1:0] data_out;

    reg [DW-1:0] rC00,rC01,rC02;
    reg [DW-1:0] rC10,rC11,rC12;
    reg [DW-1:0] rC20,rC21,rC22;

    always @(posedge clk) begin
        if (reset) begin
            rC00<=0; rC01<=0; rC02<=0;
            rC10<=0; rC11<=0; rC12<=0;
            rC20<=0; rC21<=0; rC22<=0;
        end
        else if (load) begin
            rC00<=C00; rC01<=C01; rC02<=C02;
            rC10<=C10; rC11<=C11; rC12<=C12;
            rC20<=C20; rC21<=C21; rC22<=C22;
        end
    end

    always @(*) begin
        data_out = 0;

        if (out_cnt == 0) data_out = rC00;
        else if (out_cnt == 1) data_out = rC01;
        else if (out_cnt == 2) data_out = rC02;
        else if (out_cnt == 3) data_out = rC10;
        else if (out_cnt == 4) data_out = rC11;
        else if (out_cnt == 5) data_out = rC12;
        else if (out_cnt == 6) data_out = rC20;
        else if (out_cnt == 7) data_out = rC21;
        else if (out_cnt == 8) data_out = rC22;
    end

endmodule