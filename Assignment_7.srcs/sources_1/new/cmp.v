`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2025 11:52:55
// Design Name: 
// Module Name: cmp
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


module cmp #(parameter WIDTH = 32) (
        input  wire [WIDTH-1:0]     a,
        input  wire [WIDTH-1:0]     b,
        output wire                 y
    );
    
    assign y = (a == b);
    
endmodule
