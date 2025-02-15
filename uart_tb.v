`timescale 1ns / 1ps

`include "uart_tx.v"
`include "uart_rx.v"

module uart_full_duplex_tb ();

  // Testbench Configuration
  parameter CLOCK_PERIOD_NS = 20;      // 50 MHz clock
  parameter CLKS_PER_BIT = 217;        // Matches your TX & RX modules
  parameter BIT_PERIOD = 4340;         // Approximate bit duration (CLKS_PER_BIT * CLOCK_PERIOD_NS)
   
  reg clk = 0;
  reg rst = 1;
  reg tx_start = 0;
  reg [7:0] tx_byte = 8'h00;
  wire tx_out, tx_busy;
  wire [7:0] rx_byte;
  wire rx_done;
  reg rx_serial;

  // Instantiate TX and RX UART Modules
  uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_tx_inst (
      .clk(clk),
      .rst(rst),
      .tx_start(tx_start),
      .tx_byte(tx_byte),
      .tx_out(tx_out),
      .tx_busy(tx_busy)
  );

  uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_rx_inst (
      .clk(clk),
      .rst(rst),
      .rx_serial(rx_serial),
      .rx_done(rx_done),
      .rx_byte(rx_byte)
  );

  // Generate 50 MHz System Clock
  always #(CLOCK_PERIOD_NS/2) clk = ~clk;

  // Task to Simulate UART Reception
  task UART_WRITE_BYTE;
    input [7:0] data;
    integer i;
    begin
      rx_serial = 0; // Start Bit
      #(BIT_PERIOD);
      
      for (i = 0; i < 8; i = i + 1) begin
          rx_serial = data[i]; // Send each bit
          #(BIT_PERIOD);
      end

      rx_serial = 1; // Stop Bit
      #(BIT_PERIOD);
    end
  endtask

  // Main Test Sequence
  initial begin
      $dumpfile("uart_full_duplex.vcd");
      $dumpvars(0, uart_full_duplex_tb);

      // Initialization
      rx_serial = 1;  // Default high (idle)
      #50 rst = 0;

      // Test Case 1: TX Sends 0xA5, RX Receives It
      #100;
      tx_byte = 8'hA5;
      tx_start = 1;
      #20 tx_start = 0;

      // Wait for TX to complete
      @(negedge tx_busy);

      // Simulate RX Receiving 0xA5
      UART_WRITE_BYTE(8'hA5);

      // Verify Correct Reception
      #20000;
      if (rx_byte == 8'hA5)
          $display("Test Passed: RX Received Correct Byte 0xA5");
      else
          $display("Test Failed: RX Received Incorrect Byte 0x%h", rx_byte);

      $finish;
  end
endmodule
