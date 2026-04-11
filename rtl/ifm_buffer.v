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