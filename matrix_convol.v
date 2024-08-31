`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2024 18:12:41
// Design Name: 
// Module Name: matrix_convol
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


module matrix_convol#(parameter m=3,f=2)(clk,rst,a,b,stride,out,done);
input clk,rst;
input [7:0]a,b;
input [3:0]stride;
output reg [15:0]out;
output reg done;

reg [1:0]state,next_state;
reg [7:0]x[m*m-1:0];
reg [7:0]h[f*f-1:0];
reg [15:0]sum;
reg [m:0]index;

reg [f:0]row,col;
reg [m:0]count_row,count_col;

always@(posedge clk)
begin
if(rst)
    state<=0;
else
    state<=next_state;
end

always@(posedge clk)
begin
case(state)
    0:  begin
        index<=0;
        row<=0;
        col<=0;
        count_row<=0;
        count_col<=0;
        done<=0;
        out<=0;
        end
        
    1:  begin
        x[index]<=a;
        if(index<f*f)
            h[index]<=b;
            
        if(index<m*m)
            index<=index+1;
        else
            index<=0;
        end
        
    2:  begin
        done=0;
        if(row==0 && col==0)
            begin
            sum = x[m*(count_row+row)+count_col]*h[f*row+col];
            end
        else
            begin
            sum = sum + x[m*(count_row+row)+count_col+col]*h[f*row+col];
            end
        if(row==f-1 && col==f-1)
            begin
            out = sum;
            done = 1;
            end
        end
        
    3:  begin
        if(col<f-1)
            begin
            col<=col+1;
            end
        else
            begin
            col<=0;
            if(row<f-1)
                begin
                row<=row+1;
                end
            else
                begin
                row<=0;
                if(count_col+f<m)
                    begin
                    count_col<=count_col+stride;
                    end
                else
                    begin
                    count_col<=0;
                    if(count_row+f<m)
                        begin
                        count_row<=count_row+stride;
                        end
                    else
                        begin
                        count_row<=0;
                        end
                    end
                end
            end
        end

endcase
end

always@(*)
begin
case(state)
    0:  begin
        next_state=1;
        end
    1:  begin
        if(index==m*m)
            begin
            next_state=2;
            end
        end
    2:  begin
        next_state=3;
        end
    3:  begin
        next_state=2;
        if((count_col+f>m || count_row+f>m)||(count_col+f==m && count_row+f==m && col>=f-1 && row>=f-1))
            begin
            next_state=0;
            end
        end

endcase
end

endmodule
