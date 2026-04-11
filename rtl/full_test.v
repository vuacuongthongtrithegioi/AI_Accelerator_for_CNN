// input feature map buffer
module ifm_buffer #(parameter DW=24)(
    clk, reset, load,
    A00,A01,A02,
    A10,A11,A12,
    A20,A21,A22,
    cycle,
    a1,a2,a3
);
    input clk, reset, load;
    input [DW-1:0] A00,A01,A02;
    input [DW-1:0] A10,A11,A12;
    input [DW-1:0] A20,A21,A22;
    input [2:0] cycle;
    output reg [DW-1:0] a1,a2,a3;

    reg [DW-1:0] rA00,rA01,rA02;
    reg [DW-1:0] rA10,rA11,rA12;
    reg [DW-1:0] rA20,rA21,rA22;

    always @(posedge clk) begin
        if (reset) begin
            rA00<=0; rA01<=0; rA02<=0;
            rA10<=0; rA11<=0; rA12<=0;
            rA20<=0; rA21<=0; rA22<=0;
        end
        else if (load) begin
            rA00<=A00; rA01<=A01; rA02<=A02;
            rA10<=A10; rA11<=A11; rA12<=A12;
            rA20<=A20; rA21<=A21; rA22<=A22;
        end
    end

    always @(*) begin
        a1=0; a2=0; a3=0;
        if (cycle == 0) begin
            a1 = rA00;
        end
        else if (cycle == 1) begin
            a1 = rA01; a2 = rA10;
        end
        else if (cycle == 2) begin
            a1 = rA02; a2 = rA11; a3 = rA20;
        end
        else if (cycle == 3) begin
            a2 = rA12; a3 = rA21;
        end
        else if (cycle == 4) begin
            a3 = rA22;
        end
    end
endmodule

// weight buffer 
module weight_buffer #(parameter DW=24)(
    clk, reset, load,
    B00,B01,B02,
    B10,B11,B12,
    B20,B21,B22,
    cycle,
    b1,b2,b3
);
    input clk, reset, load;
    input [DW-1:0] B00,B01,B02;
    input [DW-1:0] B10,B11,B12;
    input [DW-1:0] B20,B21,B22;
    input [2:0] cycle;
    output reg [DW-1:0] b1,b2,b3;

    reg [DW-1:0] rB00,rB01,rB02;
    reg [DW-1:0] rB10,rB11,rB12;
    reg [DW-1:0] rB20,rB21,rB22;

    always @(posedge clk) begin
        if (reset) begin
            rB00<=0; rB01<=0; rB02<=0;
            rB10<=0; rB11<=0; rB12<=0;
            rB20<=0; rB21<=0; rB22<=0;
        end
        else if (load) begin
            rB00<=B00; rB01<=B01; rB02<=B02;
            rB10<=B10; rB11<=B11; rB12<=B12;
            rB20<=B20; rB21<=B21; rB22<=B22;
        end
    end

    always @(*) begin
        b1=0; b2=0; b3=0;

        if (cycle == 0) begin
            b1 = rB00;
        end
        else if (cycle == 1) begin
            b1 = rB10; b2 = rB01;
        end
        else if (cycle == 2) begin
            b1 = rB20; b2 = rB11; b3 = rB02;
        end
        else if (cycle == 3) begin
            b2 = rB21; b3 = rB12;
        end
        else if (cycle == 4) begin
            b3 = rB22;
        end
    end
endmodule

// output feature map buffer
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

