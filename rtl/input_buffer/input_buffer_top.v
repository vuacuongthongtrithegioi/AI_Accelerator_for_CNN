module input_buffer_block_top (
    input clk, reset, start,

    input  signed [215:0] IFM_in,
    input  signed [215:0] WGT_in,

    output signed [215:0] IFM_out,
    output signed [215:0] WGT_out,

    output done
);

    wire write_en, read_en;

    input_buffer_block_ctrl ctrl (
        .clk(clk),
        .reset(reset),
        .start(start),
        .write_en(write_en),
        .read_en(read_en),
        .done(done)
    );

    input_buffer_block ifm_buf (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(IFM_in),
        .data_out(IFM_out)
    );

    input_buffer_block wgt_buf (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(WGT_in),
        .data_out(WGT_out)
    );

endmodule