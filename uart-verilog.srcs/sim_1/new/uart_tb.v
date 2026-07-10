`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2026 15:07:39
// Design Name: 
// Module Name: uart_tb
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


module uart_tb;
reg rst;
reg [7:0] data_in ;
reg clk , wr_en;
reg rdy_clr;
wire ready, busy;
wire [7:0] data_out;

uart_top dut(
   .clk(clk), .rst(rst) , .data_in(data_in) , .wr_en(wr_en) , .rdy_clr(rdy_clr),
   .ready(ready) , .busy(busy) , .data_out(data_out)
    );

initial begin
    {clk , rst , rdy_clr , data_in} = 0;
end

always #5 clk = ~clk;

task send_byte(input [7:0] din);
begin
    @(negedge clk);
    data_in = din;
    wr_en = 1'b1;
    @(negedge clk);
    wr_en = 0;
end
endtask

task clear_ready;
begin
    @ (negedge clk);
    rdy_clr = 1'b1;
    @(negedge clk);
    rdy_clr  = 1'b0;  
end
endtask

initial begin

    @(negedge clk);
    rst = 1'b1;
    
    @(negedge clk);
    rst = 1'b0;
    
    send_byte(8'h41);
    wait(!busy);
    wait(ready);
    $display("received data is %h" , data_out);
    clear_ready;
    
    
    send_byte(8'h55);
    wait(!busy);
    wait(ready);
    $display("received data is %h" , data_out);
    clear_ready;
    
    send_byte(8'h66);
    wait(!busy);
    wait(ready);
    $display("received data is %h" , data_out);
    clear_ready;   
    
    #400 $finish;
end

//initial begin
//    #10
//    rst = 1'b1;
    
//    #10
//    rst = 1'b0;
    
//    #20 wr_en = 1; data_in = 8'h41;
//    #10  wr_en = 0;
//    #4000 $finish;
//end

endmodule
