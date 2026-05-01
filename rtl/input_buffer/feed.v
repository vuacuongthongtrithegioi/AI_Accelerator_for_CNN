module systolic_input_buffer #(parameter DW=24)(
    input clk, reset,
    input load,
    input [2:0] cycle,

    input signed [DW-1:0] A00,A01,A02,
    input signed [DW-1:0] A10,A11,A12,
    input signed [DW-1:0] A20,A21,A22,

    input signed [DW-1:0] B00,B01,B02,
    input signed [DW-1:0] B10,B11,B12,
    input signed [DW-1:0] B20,B21,B22,

    output reg signed [DW-1:0] a1,a2,a3,
    output reg signed [DW-1:0] b1,b2,b3
);

    reg signed [DW-1:0] rA00,rA01,rA02;
    reg signed [DW-1:0] rA10,rA11,rA12;
    reg signed [DW-1:0] rA20,rA21,rA22;

    reg signed [DW-1:0] rB00,rB01,rB02;
    reg signed [DW-1:0] rB10,rB11,rB12;
    reg signed [DW-1:0] rB20,rB21,rB22;

    always @(posedge clk) begin
        if (reset) begin
            rA00<=0; rA01<=0; rA02<=0;
            rA10<=0; rA11<=0; rA12<=0;
            rA20<=0; rA21<=0; rA22<=0;

            rB00<=0; rB01<=0; rB02<=0;
            rB10<=0; rB11<=0; rB12<=0;
            rB20<=0; rB21<=0; rB22<=0;
        end
        else if (load) begin
            rA00<=A00; rA01<=A01; rA02<=A02;
            rA10<=A10; rA11<=A11; rA12<=A12;
            rA20<=A20; rA21<=A21; rA22<=A22;

            rB00<=B00; rB01<=B01; rB02<=B02;
            rB10<=B10; rB11<=B11; rB12<=B12;
            rB20<=B20; rB21<=B21; rB22<=B22;
        end
    end

    always @(*) begin
        case (cycle)

            3'd1: begin
                a1 = rA00; a2 = 0;     a3 = 0;
                b1 = rB00; b2 = 0;     b3 = 0;
            end

            3'd2: begin
                a1 = rA01; a2 = rA10;  a3 = 0;
                b1 = rB10; b2 = rB01;  b3 = 0;
            end

            3'd3: begin
                a1 = rA02; a2 = rA11;  a3 = rA20;
                b1 = rB20; b2 = rB11;  b3 = rB02;
            end

            3'd4: begin
                a1 = 0;     a2 = rA12; a3 = rA21;
                b1 = 0;     b2 = rB21; b3 = rB12;
            end

            3'd5: begin
                a1 = 0;     a2 = 0;     a3 = rA22;
                b1 = 0;     b2 = 0;     b3 = rB22;
            end

            3'd6: begin
                a1 = 0; a2 = 0; a3 = 0;
                b1 = 0; b2 = 0; b3 = 0;
            end

            3'd7: begin
                a1 = 0; a2 = 0; a3 = 0;
                b1 = 0; b2 = 0; b3 = 0;
            end

            default: begin
                a1 = 0; a2 = 0; a3 = 0;
                b1 = 0; b2 = 0; b3 = 0;
            end

        endcase
    end

endmodule