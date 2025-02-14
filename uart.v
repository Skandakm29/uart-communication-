`timescale 1ns / 1ps
`include "uart_tx.v"
`include "uart_rx.v"
module uart (
    input wire clk,             // System Clock
    input wire rst,             // Reset Signal
    input wire tx_start,        // TX Start Signal
    input wire [7:0] tx_byte,   // Data to Transmit
    input wire rx_serial,       // RX Serial Data Line
    input wire baud_rate_clk,   // Shared Baud Rate Clock
    output wire tx_out,         // UART TX Output
    output wire tx_busy,        // TX Busy Flag
    output wire [7:0] rx_byte,  // Received Data
    output wire rx_done         // RX Done Flag
);

    // Instantiate UART TX Module
    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .byte(tx_byte),
        .baud_rate_clk(baud_rate_clk),
        .tx_out(tx_out),
        .tx_busy(tx_busy)
    );

    // Instantiate UART RX Module
    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx_serial(rx_serial),
        .baud_rate_clk(baud_rate_clk),
        .rx_byte(rx_byte),
        .rx_done(rx_done)
    );

endmodule
