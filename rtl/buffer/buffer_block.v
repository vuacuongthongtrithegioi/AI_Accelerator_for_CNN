module buffer_block #(
    parameter DW = 216,
    parameter DEPTH = 4
)(
    input clk, reset,
    input write_en, read_en,

    input  signed [DW-1:0] data_in,
    output reg signed [DW-1:0] data_out,

    output reg full,
    output reg empty
);
    reg signed [DW-1:0] mem [0:DEPTH-1];
    reg [1:0] wr_addr;
    reg [1:0] rd_addr;
    reg [2:0] count;
    integer i;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            wr_addr <= 0;
            rd_addr <= 0;
            count   <= 0;
            full  <= 0;
            empty <= 1;
            data_out <= 0;
            for(i=0; i<DEPTH; i=i+1)
                mem[i] <= 0;
        end
        else begin
            if(write_en && !full) begin
                mem[wr_addr] <= data_in;
                wr_addr <= wr_addr + 1;
                count <= count + 1;
            end
            if(read_en && !empty) begin
                data_out <= mem[rd_addr];
                rd_addr <= rd_addr + 1;
                count <= count - 1;
            end
            full  <= (count == DEPTH);
            empty <= (count == 0);
        end
    end
endmodule