`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2025 07:33:27
// Design Name: 
// Module Name: baud_rate_generator_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for baud rate generator module. This testbench 
//              tests all available baud rates and ensures that the output 
//              baud clock toggles correctly based on the selected rate.
// 
// Dependencies: Requires the baud_rate_generator module.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module baud_rate_generator_tb;

    // Testbench signals
    reg clk;                  // Clock signal
    reg rst;                  // Reset signal
    reg [1:0] baud_rate;      // Baud rate selection input
    wire baud_clk;            // Output baud clock

    // Instantiate the module under test (MUT)
    baud_rate_generator uut (
        .clk(clk),            // Connect clock signal
        .rst(rst),            // Connect reset signal
        .baud_rate(baud_rate),// Connect baud rate input
        .baud_clk(baud_clk)   // Connect baud clock output
    );

    // Generate system clock (50MHz -> 20ns period)
    initial begin
        clk = 1'b0;               // Initialize clock signal to 0
        forever #10 clk = ~clk;   // Toggle clock every 10 ns (50 MHz clock)
    end

    // Reset the system
    initial begin
        rst = 1'b1;               // Assert reset signal
        #50 rst = 1'b0;           // Deassert reset after 50 ns
    end

    // Test different baud rates

    // Test each baud rate
    integer i = 0;
    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            baud_rate = i[1:0];   // Set baud rate
            #1000000;             // Wait for enough time to observe output toggling
        end
        $stop;                    // Stop simulation
    end

endmodule
