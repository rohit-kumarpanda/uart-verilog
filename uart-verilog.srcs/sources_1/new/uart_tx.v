`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 21:05:23
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
input clk , wr_en , rst , clk_en,
input [7:0] data_in ,
output reg tx ,
output busy
    );

parameter idle_state = 2'b00;
parameter start_state = 2'b01;
parameter data_state = 2'b10;
parameter stop_state = 2'b11;

reg [7:0] data;
reg [2:0] bit_count;
reg [1:0] state = idle_state;

always @(posedge clk)
begin
    if(rst) tx <= 1'b1;
end

always @(posedge clk) 
begin
    case(state)
    idle_state: begin
        if(wr_en) begin
            state <= start_state;
            data <= data_in;
            bit_count <= 3'h0;
        end
        else state <= idle_state;
    end
    
    start_state: begin
        if(clk_en) begin
            tx <= 1'b0;
            state <= data_state;
        end
        else state <= start_state;
    end
    
    data_state: begin
        if(clk_en) begin
            tx <= data[bit_count];
            bit_count <= bit_count + 3'h1;
            if(bit_count == 3'h7)
                state <= stop_state;
        end
        
    end
    
    stop_state: begin
        if(clk_en)
        begin
            tx <= 1'b1;
            state <= idle_state;
        end
    end
    
    default: begin
        tx <= 1'b1;
        state <= idle_state;
    end 
endcase
end

assign busy = (state != idle_state);
endmodule
