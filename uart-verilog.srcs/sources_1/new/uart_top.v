`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2026 01:21:57
// Design Name: 
// Module Name: uart_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_top(
input rst,
input [7:0] data_in ,
input clk , wr_en,
input rdy_clr,
output ready, busy,
output [7:0] data_out
    );

wire rx_clk_en;
wire tx_clk_en;
wire tx_temp;

baud_rate_gen bg(clk ,rst, tx_clk_en , rx_clk_en);
uart_tx tx(clk , wr_en , rst , tx_clk_en , data_in ,tx_temp , busy);
uart_rx rx(clk , rst , rdy_clr , rx_clk_en , tx_temp ,ready , data_out );
endmodule
