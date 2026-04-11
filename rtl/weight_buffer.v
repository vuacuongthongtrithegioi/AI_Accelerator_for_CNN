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