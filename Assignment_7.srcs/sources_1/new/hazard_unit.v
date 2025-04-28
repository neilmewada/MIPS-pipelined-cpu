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
        input  wire [4:0]   rf_waM,
        input  wire [4:0]   rf_waW,
        input  wire [4:0]   rsD,
        input  wire [4:0]   rsE,
        input  wire [4:0]   rtD,
        input  wire [4:0]   rtE,
        input  wire [1:0]   dm2regE,
        
        output reg          stallF,
        output reg          stallD,
        output reg          flushE,
        output reg  [1:0]   ForwardAE,
        output reg  [1:0]   ForwardBE
    );
    
    initial begin
        stallF = 0;
        stallD = 0;
        flushE = 0;
        ForwardAE = 0;
        ForwardBE = 0;
    end
    
    always @(*) begin
        if (clk) begin
            if (we_regM && (rsE != 0) && (rf_waM == rsE))
                ForwardAE = 2'b10;
            else if (we_regW && (rsE != 0) && (rf_waW == rsE))
                ForwardAE = 2'b01;
            else
                ForwardAE = 2'b00;
                
            if (we_regM && (rtE != 0) && (rf_waM == rtE))
                ForwardBE = 2'b10;
            else if (we_regW && (rtE != 0) && (rf_waW == rtE))
                ForwardBE = 2'b01;
            else
                ForwardBE = 2'b00;     
                
            if ((rsD == rtE || rtD == rtE) && dm2regE) begin
                stallF = 1;
                stallD = 1;
                flushE = 1;
            end
            else begin
                stallF = 0;
                stallD = 0;
                flushE = 0;
            end
        end
    end
    
endmodule
