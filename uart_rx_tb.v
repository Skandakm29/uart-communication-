//////////////////////////////////////////////////////////////////////////////////
// Company: BMSCE
// Engineer: K M SKANDA
// 
// Create Date: 14.02.2025
// Design Name: uart_communication
// Module Name: uart_rx_tb
// Project Name: UART Communication
// Target Devices: FPGA (VSD Squadcom Mini FPGA)
// Tool Versions: Open-source FPGA Tools (Yosys, NextPNR, IceStorm)
//
// Dependencies: 
//      Requires the uart_rx module.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "uart_rx.v"
module uart_rx_tb;
    reg clk, rst, rx_serial, baud_rate_clk;
    wire [7:0] rx_byte;
    wire rx_done;

    uart_rx uut (
        .clk(clk),
        .rst(rst),
        .rx_serial(rx_serial),
        .baud_rate_clk(baud_rate_clk),
        .rx_byte(rx_byte),
        .rx_done(rx_done)
    );

    always #10 clk = ~clk;  // System Clock (50MHz)
    always #8680 baud_rate_clk = ~baud_rate_clk;  // 115200 baud rate clock

    initial begin
        $dumpfile("uart_rx.vcd");
        $dumpvars(0, uart_rx_tb);

        clk = 0; rst = 1; rx_serial = 1; baud_rate_clk = 0;
        #50 rst = 0;

        // Send Start Bit
        #8680 rx_serial = 0; 

        // Send 8-bit Data (0xA3 = 10100011)
        #8680 rx_serial = 1;
        #8680 rx_serial = 1;
        #8680 rx_serial = 0;
        #8680 rx_serial = 0;
        #8680 rx_serial = 0;
        #8680 rx_serial = 1;
        #8680 rx_serial = 0;
        #8680 rx_serial = 1;

        // Send Stop Bit
        #8680 rx_serial = 1;

        #20000;
        $finish;
    end
endmodule
