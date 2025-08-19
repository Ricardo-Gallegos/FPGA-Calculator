# FPGA-Calculator
Verilog Calculator System

This project implements a 4-digit BCD calculator using Verilog that can perform various arithmetic operations based on switch inputs. The results are displayed on a 7-segment 8-digit display using time-division multiplexing.

🧠 Overview

The system uses a variety of interconnected Verilog modules to:

Input BCD values via switches

Perform operations like addition, subtraction, multiplication, division, and modulus

Convert results back to BCD

Display them using 7-segment displays

⚙️ Top-Level Module
main_top
module main_top(clk, sw, an, seg);
Inputs:

clk: System clock

sw[12:0]: Switch inputs

sw[0]: Reset

sw[1]: Mode selector (which pair of inputs to update)

sw[5:2]: First 4-bit BCD input

sw[9:6]: Second 4-bit BCD input

sw[12:10]: Operation selector (a, b, c)

Outputs:

an: Anode signals for 7-segment multiplexing

seg: 7-segment segment values (A-G)

This module instantiates the entire calculator system.

🧮 Calculator Core
calculator_com

The core logic that connects all major modules:

Accepts inputs and control signals

Routes data through input selection, BCD-to-binary conversion, arithmetic operations, binary-to-BCD conversion

Drives display modules

🧩 Module Descriptions
mulswitch
module mulswitch(clk, m, reset, inp1, inp2, num11, num12, num21, num22);
Stores two 2-digit BCD numbers (inp1, inp2) based on the mode m.

Outputs: num11, num12 (mode 0) and num21, num22 (mode 1).

clockdivide
module clockdivide(clk, nclk);

Divides the system clock to generate a slower clock (nclk) for multiplexing the display.

r_counter
module r_counter(rclk, rcount);
3-bit ring counter to cycle through 8 display digits (0–7).

anode_control
module anode_control(rcount, an);

Drives active-low anode signals to enable one digit at a time on the display.

bcd_control
module bcd_control(num11, num12, num21, num22, num4, num3, num2, num1, rcount, bcd);
Based on rcount, selects which 4-bit BCD digit to show on the active 7-segment display.

segment7
module segment7(bcd, seg);
Converts a 4-bit BCD value to its 7-segment code.

bcd2bin
module bcd2bin(num11, num12, num21, num22, bin2, bin1);
Converts BCD pairs into binary:

bin1 = num12 * 10 + num11

bin2 = num22 * 10 + num21

operations
module operations(a, b, c, bin2, bin1, cout);
Performs one of the following operations based on inputs a, b, c:

a	b	c	Operation
0	0	1	Addition
0	1	0	Subtraction
0	1	1	Multiplication
1	0	0	Division
1	0	1	Modulus

Outputs a 14-bit result (cout).

bin_to_bcd
module bin_to_bcd(cout, num4, num3, num2, num1);
Converts binary result into 4-digit BCD (thousands, hundreds, tens, units) for display.

🖥️ Display Format

The 8-digit 7-segment display is used as:

Digit	Value
0	num11 (Input 1 LSB)
1	num12 (Input 1 MSB)
2	num21 (Input 2 LSB)
3	num22 (Input 2 MSB)
4	Result LSB (num1)
5	Result tens (num2)
6	Result hundreds (num3)
7	Result thousands (num4)

Example Use Case

If you want to:

Input number A = 23, B = 17

Perform A + B

Set:

m = 0 to enter number A (23)

inp1 = 3, inp2 = 2 → num11 = 3, num12 = 2

m = 1 to enter number B (17)

inp1 = 7, inp2 = 1 → num21 = 7, num22 = 1

Set operation selector: a=0, b=0, c=1 (addition)

Display will show:

Left 4 digits: 0023

Right 4 digits: 0017

Output: 0040 (result)

🔧 Compilation & Simulation

You can simulate this project using:

ModelSim

Vivado Simulator

Icarus Verilog with GTKWave

Each module is designed to be testable independently.

📁 File Structure

All code is in a single file/module for simplicity. For large projects, consider splitting each module into its own .v file and managing with a top-level testbench.

