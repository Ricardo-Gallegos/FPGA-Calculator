`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2022 09:21:11 AM
// Design Name: 
// Module Name: exhaustive_multiplication_self_check_tb
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


module exhaustive_multiplication_self_check_tb();
//create registers and wires and variables
reg a_tb,b_tb,c_tb,bin2_tb,bin1_tb, result;
wire cout_tb;
integer i; 
//duration for earch bit
localparam period = 20;
//instantiate the module
m8 - operations uut(.a(a_tb), .b(b_tb), .c(c_tb), .bin2(bin2_tb), .bin1(bin1_tb), .out(out_tb));

initial begin
    for(i=0; i<257; i=i+1) begin
        {a_tb,b_tb,c_tb,bin2_tb,bin1_tb} = i;
        result = bin2_tb * bin1_tb;
        #period;
        if(result == cout_tb) begin 
        $display(a_tb,b_tb,c_tb,bin2_tb,bin1_tb, " passed.");
        end else begin 
        $display(a_tb,b_tb,c_tb,bin2_tb,bin1_tb, " failed.");
        end
        end
        $finish;
        end 
        
endmodule

