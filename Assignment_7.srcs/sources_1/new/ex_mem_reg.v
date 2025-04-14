`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 03:12:14 PM
// Design Name: 
// Module Name: ex_mem_reg
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


module ex_mem_reg(
        input  wire [31:0]  alu_outE,
        input  wire         zeroE,
        input  wire [31:0]  btaE,
        input  wire [4:0]   rf_waE,
        input  wire [31:0]  wd_dmE,
        input  wire [1:0]   wd_rf_signalE,
        input  wire         hi_reg_outE,
        input  wire         lo_reg_outE,
        input  wire [31:0]  alu_paE,
        input  wire [31:0]  pc_plus4E,
        input  wire [31:0]  instrE,

        input wire          branchE,
        input wire          jumpE,
        input wire          jrE,
        input wire  [1:0]   dm2regE,
        input wire          we_dmE,
        input wire          we_regE,

        input  wire         clk,

        output reg [31:0]  alu_outM,
        output reg         zeroM,
        output reg [31:0]  btaM,
        output reg [4:0]   rf_waM,
        output reg [31:0]  wd_dmM,
        output reg [1:0]   wd_rf_signalM,
        output reg         hi_reg_outM,
        output reg         lo_reg_outM,
        output reg [31:0]  alu_paM,
        output reg [31:0]  pc_plus4M,
        output reg [31:0]  instrM,

        output reg          branchM,
        output reg          jumpM,
        output reg          jrM,
        output reg  [1:0]   dm2regM,
        output reg          we_dmM,
        output reg          we_regM
    );
    
    initial begin
        alu_outM = 0;
        zeroM = 0;
        btaM = 0;
        rf_waM = 0;
        wd_dmM = 0;
        wd_rf_signalM = 0;
        hi_reg_outM = 0;
        lo_reg_outM = 0;
        alu_paM = 0;
        pc_plus4M = 0;
        instrM = 0;

        branchM = 0;
        jumpM = 0;
        jrM = 0;
        dm2regM = 0;
        we_dmM = 0;
        we_regM = 0;
    end

    always @(posedge clk) begin
        alu_outM <= alu_outE;
        zeroM <= zeroE;
        btaM <= btaE;
        rf_waM <= rf_waE;
        wd_dmM <= wd_dmE;
        wd_rf_signalM <= wd_rf_signalE;
        hi_reg_outM <= hi_reg_outE;
        lo_reg_outM <= lo_reg_outE;
        alu_paM <= alu_paE;
        pc_plus4M <= pc_plus4E;
        instrM <= instrE;

        branchM <= branchE;
        jumpM <= jumpE;
        jrM <= jrE;
        dm2regM <= dm2regE;
        we_dmM <= we_dmE;
        we_regM <= we_regE;
    end

endmodule
