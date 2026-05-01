module input_buffer_block_ctrl (
    input clk, reset,
    input start,

    output reg write_en,
    output reg read_en,
    output reg done
);

    reg [1:0] state;

    localparam IDLE  = 2'd0,
               WRITE = 2'd1,
               READ  = 2'd2,
               DONE  = 2'd3;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else begin
            case (state)

                IDLE:
                    if (start) state <= WRITE;

                WRITE:
                    state <= READ;

                READ:
                    state <= DONE;

                DONE:
                    state <= IDLE;

            endcase
        end
    end

    always @(*) begin
        write_en = 0;
        read_en  = 0;
        done     = 0;

        case (state)
            WRITE: write_en = 1;
            READ:  read_en  = 1;
            DONE:  done     = 1;
        endcase
    end

endmodule