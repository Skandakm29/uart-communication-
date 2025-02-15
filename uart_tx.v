`timescale 1ns / 1ps

module uart_tx 
  #(parameter CLKS_PER_BIT=217)
  (
   input wire clk,           // System Clock
   input wire rst,           // Reset
   input wire tx_start,      // Start Transmission
   input wire [7:0] tx_byte, // 8-bit Data to Transmit
   output reg tx_out,        // UART TX Output
   output reg tx_busy        // TX Busy Flag
   );

  parameter IDLE         = 3'b000;
  parameter START        = 3'b001;
  parameter DATA         = 3'b010;
  parameter STOP         = 3'b011;
  parameter CLEANUP      = 3'b100;
   
  reg [2:0] state = IDLE;     // Current State
  reg [7:0] baud_counter = 0; // Baud Rate Counter
  reg [2:0] bit_index = 0;    // Bit Counter
  reg [7:0] shift_reg = 0;    // Shift Register

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      tx_out <= 1'b1;
      tx_busy <= 0;
      shift_reg <= 8'b0;
      baud_counter <= 0;
      bit_index <= 0;
    end else begin
      case (state)
        IDLE: begin
          tx_out <= 1'b1;
          tx_busy <= 0;
          baud_counter <= 0;
          bit_index <= 0;
          if (tx_start) begin
            shift_reg <= tx_byte;
            tx_busy <= 1;
            state <= START;
          end
        end

        START: begin
          tx_out <= 1'b0; // Start bit
          if (baud_counter < CLKS_PER_BIT-1) begin
            baud_counter <= baud_counter + 1;
          end else begin
            baud_counter <= 0;
            state <= DATA;
          end
        end

        DATA: begin
          tx_out <= shift_reg[0]; // Send LSB first
          if (baud_counter < CLKS_PER_BIT-1) begin
            baud_counter <= baud_counter + 1;
          end else begin
            baud_counter <= 0;
            shift_reg <= shift_reg >> 1;
            if (bit_index < 7) begin
              bit_index <= bit_index + 1;
              state <= DATA;
            end else begin
              bit_index <= 0;
              state <= STOP;
            end
          end
        end

        STOP: begin
          tx_out <= 1'b1; // Stop bit
          if (baud_counter < CLKS_PER_BIT-1) begin
            baud_counter <= baud_counter + 1;
          end else begin
            tx_busy <= 0;
            baud_counter <= 0;
            state <= CLEANUP;
          end
        end

        CLEANUP: begin
          state <= IDLE;
        end

        default: state <= IDLE;
      endcase
    end
  end
endmodule
