`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2025 
// Design Name: 
// Module Name: uart_rx
// Project Name: uart_communication
// Target Devices: vsdsquadcom mini fpga board
// Tool Versions:  
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_tx 
(
    input wire clk,           // System clock
    input wire rst,           // Reset
    input wire tx_start,      // Start transmission
    input wire [7:0] byte,    // 8-bit data to transmit
    input wire baud_rate_clk, // Baud rate clock
    output reg tx_out,        // UART TX output
    output reg tx_busy        // TX busy flag
);

    // UART FSM States
parameter [2:0] 
        IDLE  = 3'b000,  
        LOAD  = 3'b001,  
        START = 3'b010,  
        DATA  = 3'b011,  
        STOP  = 3'b100;
       reg [2:0]state;

    reg [7:0] shift_reg = 8'b0; // Shift register
    reg [3:0] bit_counter = 0;  // Bit counter

always @(posedge clk ) begin
            case (state)
                // IDLE State: Wait for Start Signal
                IDLE: begin
                    tx_out <= 1'b1;  // TX line stays HIGH
                    tx_busy <= 1'b0; // TX is idle
                    if (tx_start) begin
                        shift_reg <= byte;  // Load data
                        tx_busy <= 1'b1;    // TX is now busy
                        state <= LOAD;
                    end
                end

                //  LOAD State: Move Data into Shift Register
                LOAD: begin
                    state <= START;
                end

                // START State: Send Start Bit (0)
                START: begin
                    tx_out <= 1'b0; // Start bit
                    if (baud_rate_clk) begin
                        bit_counter <= 4'b0000;
                        state <= DATA;
                    end
                end

                //  DATA State: Transmit 8 Data Bits
                DATA: begin
                    if (baud_rate_clk) begin
                        tx_out <= shift_reg[0]; // Send LSB first
                        shift_reg <= shift_reg >> 1; // Shift data
                        bit_counter <= bit_counter + 1;
                        if (bit_counter == 7) begin
                            state <= STOP;
                        end
                    end
                end

                //  STOP State: Send Stop Bit (1)
                STOP: begin
                    if (baud_rate_clk) begin
                        tx_out <= 1'b1; // Stop bit
                        state <= IDLE;  // Go back to IDLE
                        tx_busy <= 1'b0; // TX is now idle
                    end
                end

                default: state <= IDLE;
            endcase
        end
endmodule
