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
endmodule