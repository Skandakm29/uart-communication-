//////////////////////////////////////////////////////////////////////////////////
// Company: BMSCE
// Engineer: K M SKANDA
// 
// Create Date: 14.02.2025
// Design Name: uart_communication
// Module Name: uart_rx
// Project Name: UART Communication
// Target Devices: FPGA (VSD Squadcom Mini FPGA)
// Tool Versions: Open-source FPGA Tools (Yosys, NextPNR, IceStorm)
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module uart_rx (
    input wire clk,            // System Clock
    input wire rst,            // Reset
    input wire rx_serial,      // Serial RX Data Line
    input wire baud_rate_clk,  // Baud rate clock
    output reg [7:0] rx_byte,  // Received Byte Output
    output reg rx_done         // RX Complete Flag
);

    // FSM States
    parameter IDLE  = 3'b000;
    parameter START = 3'b001;
    parameter DATA  = 3'b010;
    parameter STOP  = 3'b011;
    parameter DONE  = 3'b100;

    reg [2:0] state = IDLE;     // Current State
    reg [3:0] bit_index = 0;    // Bit Counter
    reg [7:0] shift_reg = 0;    // Shift Register

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            rx_done <= 0;
            rx_byte <= 8'b0;
            shift_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    rx_done <= 0;
                    if (rx_serial == 0)  // Start bit detected
                        state <= START;
                end

                START: begin
                    if (baud_rate_clk)
                        state <= DATA;
                end

                DATA: begin
                    if (baud_rate_clk) begin
                        shift_reg[bit_index] <= rx_serial;  // Sample data
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) 
                            state <= STOP;
                    end
                end

                STOP: begin
                    if (baud_rate_clk) begin
                        if (rx_serial == 1) begin  // Valid stop bit
                            rx_byte <= shift_reg;
                            rx_done <= 1;
                            state <= DONE;
                        end else begin
                            state <= IDLE;  // Error detected, restart
                        end
                    end
                end

                DONE: begin
                    state <= IDLE;
                end

            endcase
        end
    end
endmodule
