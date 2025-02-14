//////////////////////////////////////////////////////////////////////////////////
// Company: BMSCE
// Engineer: K M SKANDA
// 
// Create Date: 14.02.2025
// Design Name: uart_communication
// Module Name: baud_rate_generator_tb
// Project Name: UART Communication
// Target Devices: FPGA (VSD Squadcom Mini FPGA)
// Tool Versions: Open-source FPGA Tools (Yosys, NextPNR, IceStorm)
// Description: 
//      Testbench for the baud rate generator. It verifies that the baud clock
//      toggles correctly for all baud rate selections.
//
// Dependencies: 
//      Requires the `baude_rate_generator` module.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "baud_rate_generator.v"
module baud_rate_generator_tb;

    // Testbench signals
    reg clk;                     // System clock (50 MHz)
    reg rst;                     // Active-high reset
    reg [1:0] baud_rate;         // Baud rate selection
    wire baud_clk;               // Output baud clock

    // Instantiate the Baud Rate Generator module
    baude_rate_generator uut ( 
        .clk(clk), 
        .rst(rst), 
        .baud_rate(baud_rate), 
        .baud_clk(baud_clk)
    );

    // Generate a 50 MHz system clock (20 ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Toggle every 10 ns
    end
    initial begin
    $dumpfile("waveform.vcd");  // VCD file to store waveform
    $dumpvars(0, baud_rate_generator_tb);
    end

    // Apply Reset at the beginning
    initial begin
        rst = 1'b1;      // Assert reset
        #50 rst = 1'b0;  // Deassert reset after 50 ns
    end

    // Test each baud rate and observe baud clock toggling
    integer i;
    initial begin
        // Wait for reset to clear
        #100; 
    
        // Cycle through all baud rate settings
        for (i = 0; i < 4; i = i + 1) begin
            baud_rate = i[1:0];   // Set baud rate selection
       rgb(57, 0, 80);              // Wait enough time to observe output toggling
        end
        
        $stop; // End simulation
    end


endmodule
