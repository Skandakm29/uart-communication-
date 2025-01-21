`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineering College: BMS College of Engineering (BMSCE)
// Engineer: K M Skanda
// 
// Create Date: 21.01.2025 06:05:46
// Design Name: Baud Rate Generator
// Module Name: baud_rate_generator
// Project Name: UART Communication
// Target Devices: FPGA or ASIC
// Tool Versions: Vivado 2025.1, ModelSim 2025.1
// Description: 
// This module generates a configurable baud clock signal based on the input
// clock frequency (50 MHz) and the selected baud rate. The supported baud rates 
// are:
// - 2400
// - 4800
// - 9600
// - 19200
module baud_rate_generator (
    input wire clk,           // Input clock signal (50 MHz)
    input wire rst,           // Reset signal (active high)
    input wire [1:0] baud_rate, // Baud rate selection (2-bit input)
    output reg baud_clk       // Output baud clock signal
);
    reg [9:0] clock_baud = 10'd0;  // Initialize counter
    reg [9:0] final_value = 10'd0; // Initialize final value

    // Baud rate selection logic
    always @(*) begin
        case (baud_rate)
            2'b00: final_value = 10'd651;  // For 2400 baud rate
            2'b01: final_value = 10'd326;  // For 4800 baud rate
            2'b10: final_value = 10'd163;  // For 9600 baud rate
            2'b11: final_value = 10'd81;   // For 19200 baud rate
            default: final_value = 10'd163; // Default to 9600 baud rate
        endcase
    end

    // Clock division logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            baud_clk <= 1'b0;        // Reset baud clock signal
            clock_baud <= 10'd0;    // Reset baud counter
        end else if (clock_baud == final_value) begin
            baud_clk <= ~baud_clk;  // Toggle baud clock when counter matches final value
            clock_baud <= 10'd0;    // Reset the baud counter
        end else begin
            clock_baud <= clock_baud + 1'd1; // Increment the baud counter
        end
    end
endmodule


