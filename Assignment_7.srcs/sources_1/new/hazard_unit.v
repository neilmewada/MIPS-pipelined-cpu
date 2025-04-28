`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2025 08:45:23 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
        input  wire         clk,
        input  wire         we_regE,
        input  wire         we_regM,
        input  wire         we_regW,
        
        output wire         stallF,
        output wire         stallD,
        output wire         flushE,
        output wire [1:0]   ForwardAE,
        output wire [1:0]   ForwardBE
    );
    
endmodule
