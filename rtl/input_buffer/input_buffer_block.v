module input_buffer_block (
    input clk, reset,
    input write_en,
    input read_en,

    input  signed [215:0] data_in,   
    output reg signed [215:0] data_out
);

    reg signed [215:0] buffer;

    always @(posedge clk) begin
        if (reset)
            buffer <= 0;
        else if (write_en)
            buffer <= data_in;
    end

    always @(posedge clk) begin
        if (reset)
            data_out <= 0;
        else if (read_en)
            data_out <= buffer;
    end

endmodule