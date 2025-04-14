`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 11:36:25 PM
// Design Name: 
// Module Name: if_id_reg
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


module if_id_reg(
        input  wire [31:0] instrF,
        input  wire [31:0] pc_plus4F,
        input  wire        en,
        input  wire        clk,
        output reg  [31:0] instrD,
        output reg  [31:0] pc_plus4D  
    );
    
    initial begin
        instrD = 0;
        pc_plus4D = 0;
    end
    
    always @(posedge clk) begin
        if (en) begin
            instrD <= instrF;
            pc_plus4D <= pc_plus4F;
        end
    end
    
endmodule
