`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 23:04:54
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
input clk, rst , rdy_clr , clk_en , rx,
output reg ready,
output reg [7:0] data_out  
    );
    
always @(posedge clk)
begin
    if(rst)begin
        ready <= 0;
        data_out <= 0;
    end
end

parameter start_state = 2'b00;
parameter dataout_state = 2'b01;
parameter stop_state = 2'b10;

reg [1:0] state = start_state;
reg [3:0] sample = 0;
reg [3:0] bit_pos = 0;
reg [7:0] temp_reg = 8'b0;

always @(posedge clk) 
begin
    if(rdy_clr) ready <= 0;
    if(clk_en) begin
        case(state)
            start_state: begin
                if(!rx || sample!= 0)
                    sample <= sample + 1'b1;
                if(sample == 15) begin
                    state <= dataout_state;
                    bit_pos <= 0;
                    sample <= 0;
                    temp_reg <= 0;
                end 
            end
           dataout_state: begin
               sample <= sample + 1'b1;
               if(sample == 4'h8)
               begin
                    temp_reg[bit_pos] <= rx;
                    bit_pos <= bit_pos + 1'b1;
               end
               if(sample == 15 && bit_pos == 8)
                    state <= stop_state;
           end
           
           stop_state: begin
                if(sample == 15)begin
                    state <= start_state;
                    data_out <= temp_reg;
                    ready <= 1'b1;
                    sample <= 0;
                end
                else sample <= sample + 4'b1;
           end
           
           default: begin
                state <= start_state;
           end
        endcase
    end
end
endmodule
