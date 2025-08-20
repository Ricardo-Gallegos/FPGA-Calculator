module mulswitch(clk,m,reset,inp1,inp2,num11,num12,num21,num22);
input m,reset,clk;
input [3:0]inp1,inp2;
output [3:0]num11,num12,num21,num22;
 reg[3:0] num11,num12,num21,num22;
always@(posedge clk)
begin
if(reset==1)
{num11,num12,num21,num22}<=0;

if(m==0)
begin
num11<=inp1;
num12<=inp2;
end

if(m==1)
begin
num21<=inp1;
num22<=inp2;
end
end
endmodule



module clockdivide(clk, nclk);
input clk;
output reg nclk;
reg [31:0]count=32'd0;
always@(posedge clk)
begin
count=count+1;
nclk=count[16];
end
endmodule

module r_counter(rclk,rcount);
input rclk;
output reg[2:0]rcount=3'b000;
always@(posedge rclk)
rcount<=rcount+1;
endmodule

module anode_control(rcount,an);
input [2:0]rcount;
output reg [7:0]an;
always@(rcount)
begin
case(rcount)
3'b000: an=8'b11111110;
3'b001: an=8'b11111101;
3'b010: an=8'b11111011;
3'b011: an=8'b11110111;
3'b100: an=8'b11101111;
3'b101: an=8'b11011111;
3'b110: an=8'b10111111;
3'b111: an=8'b01111111;
endcase
end
endmodule

module bcd_control(num11,num12,num21,num22,num4,num3,num2,num1,rcount,bcd);
input [3:0]num11,num12,num21,num22,num4,num3,num2,num1;
input [2:0]rcount;
output reg [3:0]bcd=4'b0000;
always@(rcount,num11,num12,num21,num22,num4,num3,num2,num1)
begin
case(rcount)
3'b000: bcd=num11;
3'b001: bcd=num12;
3'b010: bcd=num21;
3'b011: bcd=num22;
3'b100: bcd=num1;
3'b101: bcd=num2;
3'b110: bcd=num3;
3'b111: bcd=num4;
endcase
end
endmodule

module segment7(bcd,seg);
input [3:0] bcd;
output [6:0] seg;
reg [6:0] seg;
always @(bcd)
begin
case (bcd) 
0 : seg = 7'b1000000;
1 : seg = 7'b1111001;
2 : seg = 7'b0100100;
3 : seg = 7'b0110000;
4 : seg = 7'b0011001;
5 : seg = 7'b0010010;
6 : seg = 7'b0000010;
7 : seg = 7'b1111000;
8 : seg = 7'b0000000;
9 : seg = 7'b0010000;

default : seg = 7'b1111111;
endcase
end
endmodule



module bcd2bin(num11,num12,num21,num22,bin2,bin1);
    input wire [3:0] num11; 
    input wire [3:0] num12; 
    input wire [3:0] num21; 
    input wire [3:0] num22; 
    output wire [6:0] bin2;
    output wire [6:0] bin1;
   

   assign bin2 = (num22*4'd10) + num21;
   assign bin1 = (num12*4'd10) + num11;

endmodule



module operations(a,b,c,bin2,bin1,cout);
input a,b,c;
input [6:0]bin2;
input [6:0]bin1;
output reg[13:0]cout;
always@(a,b,c,bin1,bin2)
begin 
if(a==0 && b==0 && c==1)
cout = bin2 + bin1;

else if(a==0 && b==1 && c==0)
begin
if(bin2 > bin1)
cout = bin2 - bin1;
else
cout = bin1 - bin2;
end

else if(a==0 && b==1 && c==1)
cout = bin2 * bin1;

else if(a==1 && b==0 && c==0)
cout = bin2 / bin1;

else if(a==1 && b==0 && c==1)
cout = bin2 % bin1;

end
endmodule


module bin_to_bcd(cout,num4,num3,num2,num1);
input[13:0] cout;
output reg[3:0] num4,num3,num2,num1;
reg[13:0] temp;
always @ (cout)
begin
temp=cout;
num4=temp/1000;
temp=temp%1000;
num3=temp/100;
temp=temp%100;
num2=temp/10;
num1=temp%10;
end
endmodule


module calculator_com(clk,reset,m,inp1,inp2,a,b,c,seg,an);
input clk,reset,m,a,b,c;
input [3:0]inp1,inp2;
output [6:0]seg;
output [7:0]an;
wire [3:0]num11,num12,num21,num22,num4,num3,num2,num1;
wire nclk;
wire [2:0]rcount;
wire [3:0]bcd;
wire [6:0]bin2,bin1;
wire [13:0]cout;
mulswitch m1(clk,m,reset,inp1,inp2,num11,num12,num21,num22);
clockdivide m2(clk, nclk);
r_counter m3(nclk,rcount);
anode_control m4(rcount,an);
bcd_control m5(num11,num12,num21,num22,num4,num3,num2,num1,rcount,bcd);
segment7 m6(bcd,seg);
bcd2bin m7(num11,num12,num21,num22,bin2,bin1);
operations m8(a,b,c,bin2,bin1,cout);
bin_to_bcd m9(cout,num4,num3,num2,num1);

endmodule


module main_top(clk,sw,an,seg);
input clk;
input [12:0]sw;
output [7:0]an;
output [6:0]seg;
calculator_com m10(clk,sw[0],sw[1],sw[5:2],sw[9:6],sw[12],sw[11],sw[10],seg,an);
endmodule

