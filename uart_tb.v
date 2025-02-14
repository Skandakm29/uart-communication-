//////////////////////////////////////////////////////////////////////////////////
// Company: BMSCE
// Engineer: K M SKANDA
// 
// Create Date: 14.02.2025
// Design Name: uart_communication
// Module Name: uart
// Project Name: UART Communication
// Target Devices: FPGA (VSD Squadcom Mini FPGA)
// Tool Versions: Open-source FPGA Tools (Yosys, NextPNR, IceStorm)
//
// Dependencies: 
//      Requires the uart module.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "uart.v"
module uart_full_duplex_tb;
    reg clk, rst, tx_start, rx_serial, baud_rate_clk;
    reg [7:0] tx_byte;
    wire tx_out, tx_busy;
    wire [7:0] rx_byte;
    wire rx_done;

    // Instantiate Full-Duplex UART Module
    uart uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_byte(tx_byte),
        .rx_serial(rx_serial),
        .baud_rate_clk(baud_rate_clk),
        .tx_out(tx_out),
        .tx_busy(tx_busy),
        .rx_byte(rx_byte),
        .rx_done(rx_done)
    );

    always #10 clk = ~clk;  // 50 MHz System Clock
    always #8680 baud_rate_clk = ~baud_rate_clk;  // 115200 Baud Rate Clock

    initial begin
        $dumpfile("uart_full_duplex.vcd");
        $dumpvars(0, uart_full_duplex_tb);

        clk = 0; rst = 1; tx_start = 0; tx_byte = 8'h00; baud_rate_clk = 0;
        #50 rst = 0;

        // Test Case 1: TX Sends 0xA5, RX Receives It
        tx_byte = 8'hA5;
        tx_start = 1;
        #20 tx_start = 0;

        // Simulate receiving 0xA5 on rx_serial
        #8680 rx_serial = 0;  // Start Bit
        #8680 rx_serial = 1;  // Data Bit 0
        #8680 rx_serial = 0;  // Data Bit 1
        #8680 rx_serial = 1;  // Data Bit 2
        #8680 rx_serial = 0;  // Data Bit 3
        #8680 rx_serial = 1;  // Data Bit 4
        #8680 rx_serial = 0;  // Data Bit 5
        #8680 rx_serial = 1;  // Data Bit 6
        #8680 rx_serial = 1;  // Data Bit 7
        #8680 rx_serial = 1;  // Stop Bit

        #20000;
        $finish;
    end
endmodule
