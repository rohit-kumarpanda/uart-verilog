`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 18:36:55
// Design Name: 
// Module Name: baud_rate_gen
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


module baud_rate_gen(
input clk , rst,
output tx_enable , rx_enable
    );
reg [15:0] tx_counter;
reg [15:0] rx_counter;

parameter clk_freq = 100000000; // SYSTEM CLOCK FREQUENCY
parameter baud_rate = 9600; //REQUIRED BAUD RATE
parameter divisor_tx = clk_freq/baud_rate; //PRESCALAR OF SENDER
parameter divisor_rx = clk_freq/(16 *baud_rate);    //PRESCALAR OF RECIEVER


always @(posedge clk)
begin
    if(rst)begin
        tx_counter <= 0;
    end
//end

//always @ (posedge clk)
//begin
    else if(tx_counter == divisor_tx - 1) tx_counter = 0;
    else tx_counter <= tx_counter + 1;
end

always @ (posedge clk)
begin
        if(rst)begin
        rx_counter <= 0;
    end
    else if(rx_counter == divisor_rx - 1) rx_counter <= 0;
    else rx_counter <= rx_counter + 1;
end

assign tx_enable = (tx_counter == 0);
assign rx_enable = (rx_counter == 0);

endmodule
