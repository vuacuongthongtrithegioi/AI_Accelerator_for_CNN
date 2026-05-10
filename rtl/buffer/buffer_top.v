module buffer_top #(
    parameter DW = 216,
    parameter DEPTH = 4
) (
    input clk, reset, start,
    input mode,

    input  signed [DW-1:0] data_in,
    output signed [DW-1:0] data_out,

    output full, empty,

    output done
);
    wire write_en, read_en; // 0 for write, 1 for read

    buffer_ctl #(.DEPTH(DEPTH)) ctl (
        .clk(clk), .reset(reset), .start(start), 
        .mode(mode),
        .full(full), .empty(empty),
        .write_en(write_en), .read_en(read_en), .done(done)
    );

    buffer_block #(.DW(DW), .DEPTH(DEPTH)) block (
        .clk(clk), .reset(reset),
        .write_en(write_en), .read_en(read_en),
        .data_in(data_in), .data_out(data_out),
        .full(full), .empty(empty)
    );    
endmodule