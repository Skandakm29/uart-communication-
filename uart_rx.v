`timescale 1ns / 1ps

module uart_rx 
  #(parameter CLKS_PER_BIT=217)
  (
   input wire clk,             // System Clock
   input wire rst,             // Reset
   input wire rx_serial,       // Serial RX Data Line
   output reg rx_done,         // RX Complete Flag
   output reg [7:0] rx_byte    // Received Byte Output
   );
    
  parameter IDLE         = 3'b000;
  parameter START        = 3'b001;
  parameter DATA         = 3'b010;
  parameter STOP         = 3'b011;
  parameter CLEANUP      = 3'b100;
   
  reg [2:0] state = IDLE;     // Current State
  reg [7:0] baud_counter = 0; // Baud rate counter
  reg [2:0] bit_index = 0;    // Bit Counter
  reg [7:0] shift_reg = 0;    // Shift Register

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      rx_done <= 0;
      rx_byte <= 8'b0;
      shift_reg <= 8'b0;
      baud_counter <= 0;
      bit_index <= 0;
    end else begin
      case (state)
        IDLE: begin
          rx_done <= 0;
          baud_counter <= 0;
          bit_index <= 0;
          if (rx_serial == 0)   // Start bit detected
            state <= START;
        end

        START: begin
          if (baud_counter == (CLKS_PER_BIT-1)/2) begin
            if (rx_serial == 0) begin
              baud_counter <= 0;
              state <= DATA;
            end else
              state <= IDLE;
          end else begin
            baud_counter <= baud_counter + 1;
            state <= START;
          end
        end

        DATA: begin
          if (baud_counter < CLKS_PER_BIT-1) begin
            baud_counter <= baud_counter + 1;
          end else begin
            baud_counter <= 0;
            shift_reg[bit_index] <= rx_serial;

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
          if (baud_counter < CLKS_PER_BIT-1) begin
            baud_counter <= baud_counter + 1;
          end else begin
            rx_done <= 1;  // Indicate data received
            rx_byte <= shift_reg;
            baud_counter <= 0;
            state <= CLEANUP;
          end
        end

        CLEANUP: begin
          rx_done <= 0;
          state <= IDLE;
        end

        default: state <= IDLE;
      endcase
    end
  end
endmodule
