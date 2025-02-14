`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BMSCE
// Engineer: K M SKANDA
// 
// Create Date: 14.02.2025
// Design Name: uart_communication
// Module Name: uart_tx_tb
// Project Name: UART Communication
// Target Devices: FPGA (VSD Squadcom Mini FPGA)
// Tool Versions: Open-source FPGA Tools (Yosys, NextPNR, IceStorm)
// Description: 
//      Testbench for the uart_tx. 
//
// Dependencies: 
//      Requires the `uart_tx` module.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//u can either include `inlcude "uart_tx.v" or u can runn both in terminal

module uart_tx_tb;
    reg clk;               // System clock
    reg rst;               // Reset
    reg tx_start;          // Start transmission
    reg [7:0] byte;        // Data to transmit
    reg baud_rate_clk;     // Baud rate clock
    wire tx_out;           // UART TX output
    wire tx_busy;          // TX busy flag

    // Instantiate the UART TX module
uart_tx uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .byte(byte),
        .baud_rate_clk(baud_rate_clk),
        .tx_out(tx_out),
        .tx_busy(tx_busy)
    );

    // Generate system clock (50 MHz example)
    always #10 clk = ~clk;  // 10 ns period → 100 MHz clock

    // Generate baud rate clock (115200 baud example)
    always #8680 baud_rate_clk = ~baud_rate_clk;  // 8680 ns period → ~115200 baud rate
    initial begin
    $dumpfile("uart_tx.vcd");  // Creates VCD file
    $dumpvars(0, uart_tx_tb);   // Dumps all signals of the testbench
    end

    initial begin
        // Initialize Signals
        clk = 0;
        baud_rate_clk = 0;
        rst = 1;
        tx_start = 0;
        byte = 8'b00000000;
        #50;  // Wait for reset stabilization

        // Release reset
        rst = 0;
        #50;

        // Test Case 1: Send Byte 0x55 (01010101)
        byte = 8'b01010101;
        tx_start = 1;
        #20;  // Small delay before disabling start signal
        tx_start = 0;

        // Wait for transmission to complete
        wait(tx_busy == 0);
        #10000; // Extra delay for stability

        // Test Case 2: Send Byte 0xA3 (10100011)
        byte = 8'b10100011;
        tx_start = 1;
        #20;
        tx_start = 0;

        // Wait for transmission to complete
        wait(tx_busy == 0);
        #10000;

        // Test Case 3: Send Byte 0xFF (11111111)
        byte = 8'b11111111;
        tx_start = 1;
        #20;
        tx_start = 0;

        // Wait for transmission to complete
        wait(tx_busy == 0);
        #10000;
        // End Simulation
        $finish;
    end

endmodule
