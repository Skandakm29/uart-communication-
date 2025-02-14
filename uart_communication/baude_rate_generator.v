//////////////////////////////////////////////////////////////////////////////////
// Company: BMSCE
// Engineer: K M SKANDA
// 
// Create Date: 14.02.2025 
// Design Name: uart_communication
// Module Name: baude_rate_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generates baud rate clock signals based on selection.
//
// Dependencies: None.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module baude_rate_generator (
    input wire clk,            // Input clock signal (50 MHz)
    input wire rst,            // Reset signal (active high)
    input wire [1:0] baud_rate,// Baud rate selection (2-bit input)
    output reg baud_clk        // Output baud clock signal
);

    reg [9:0] clock_baud = 10'd0;  // Initialize counter
    reg [9:0] final_value = 10'd0; // Initialize final value

    // Baud rate selection logic
    always @(*) begin
        case (baud_rate)
            2'b00: final_value = 10'd651;  // 2400 baud
            2'b01: final_value = 10'd326;  // 4800 baud
            2'b10: final_value = 10'd163;  // 9600 baud
            2'b11: final_value = 10'd81;   // 19200 baud
            default: final_value = 10'd163;// Default to 9600 baud
        endcase
    end

    // Clock division logic with correct toggling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            baud_clk <= 1'b0;       // Reset baud clock signal
            clock_baud <= 10'd0;    // Reset baud counter
        end else begin
            if (clock_baud >= (final_value * 2) - 1) begin
                baud_clk <= ~baud_clk;  // Toggle baud clock every 2*final_value cycles
                clock_baud <= 10'd0;    // Reset the counter
            end else begin
                clock_baud <= clock_baud + 1'd1;
            end
        end
    end

endmodule
