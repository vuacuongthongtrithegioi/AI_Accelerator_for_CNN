module NPU_Ctrl (
    clk, reset, start, 
    // Signals from submodules
    done_input_buffer,
    done_mac,
    done_cut_bit,
    done_relu,
    done_output_buffer,
    // Valid signal to indicate when the NPU is ready for the next operation
    valid_input_buffer,
    valid_mac,
    valid_cut_bit,
    valid_relu,
    valid_output_buffer,
    // done signal to indicate the entire NPU operation is complete
    done
);
    input wire clk, reset, start;
    input wire done_input_buffer;
    input wire done_mac;
    input wire done_cut_bit;
    input wire done_relu;
    input wire done_output_buffer;
    output reg valid_input_buffer;
    output reg valid_mac;
    output reg valid_cut_bit;
    output reg valid_relu;
    output reg valid_output_buffer;
    output reg done;

    localparam IDLE = 4'b0;
    localparam READ_FROM_DRAM = 4'b1; // Read data from DRAM and write it to the buffer.
    localparam MAC = 4'b2; // Read data from the buffer and write it to the MAC unit and implement the MAC operation.
    localparam CUT_BIT = 4'b3; // Perform bit-cutting operation.
    localparam RELU = 4'b4; // Perform ReLU operation.
    localparam WRITE_TO_BUFFER = 4'b5; // Write the output data back to the buffer.
    localparam WRITE_TO_DRAM = 4'b6; // Write the output data back to DRAM.

    reg [3:0] state, next_state;
    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
     always @(*) begin

        next_state = state;

        case(state)
            IDLE: begin
                if(start)
                    next_state = READ_FROM_DRAM;
                else
                    next_state = IDLE;
            end
            READ_FROM_DRAM: begin
                if(done_input_buffer)
                    next_state = MAC;
                else
                    next_state = READ_FROM_DRAM;
            end
            MAC: begin
                if(done_mac)
                    next_state = CUT_BIT;
                else
                    next_state = MAC;
            end
            CUT_BIT: begin
                if(done_cut_bit)
                    next_state = RELU;
                else
                    next_state = CUT_BIT;
            end
            RELU: begin
                if(done_relu)
                    next_state = WRITE_TO_BUFFER;
                else
                    next_state = RELU;
            end
            WRITE_TO_BUFFER: begin
                if(done_output_buffer)
                    next_state = WRITE_TO_DRAM;
                else
                    next_state = WRITE_TO_BUFFER;
            end
            WRITE_TO_DRAM: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        valid_input_buffer  = 1'b0;
        valid_mac           = 1'b0;
        valid_cut_bit       = 1'b0;
        valid_relu          = 1'b0;
        valid_output_buffer = 1'b0;
        done                = 1'b0;
        case(state)
            IDLE: begin
                done = 1'b0;
            end
            READ_FROM_DRAM: begin
                valid_input_buffer = 1'b1;
            end
            MAC: begin
                valid_mac = 1'b1;
            end
            CUT_BIT: begin
                valid_cut_bit = 1'b1;
            end
            RELU: begin
                valid_relu = 1'b1;
            end
            WRITE_TO_BUFFER: begin
                valid_output_buffer = 1'b1;
            end
            WRITE_TO_DRAM: begin
                done = 1'b1;
            end
        endcase
    end
endmodule