`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2024 19:27:47
// Design Name: 
// Module Name: matrix_convol_tb
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


module matrix_convol_tb();
reg clk,rst;
reg [7:0]a,b;
reg [3:0]stride;
wire [15:0]out;
wire done;
parameter m=3,f=2;

matrix_convol #(m,f)mc1(clk,rst,a,b,stride,out,done);

initial clk=1;
always #10 clk=~clk;

initial
begin
rst=1;stride=1;  a=0; b=0;
#200 rst=0;
#20 a=1; b=1;
#20 a=2; b=2;
#20 a=3; b=3;
#20 a=4; b=4;
#20 a=5; b=2;
#20 a=6; b=2;
#20 a=7; b=2;
#20 a=8; b=2;
#20 a=9; b=2;
#2000 $stop;
end

endmodule
