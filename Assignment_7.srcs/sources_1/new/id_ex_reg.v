`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 10:50:57 AM
// Design Name: 
// Module Name: id_ex_reg
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


module id_ex_reg(
        input wire         branchD,      
        input wire         jumpD,        
        input wire         jrD,          
        input wire         multuD,       
        input wire  [1:0]  wd_rf_signalD,
        input wire         hi_lo_writeD, 
        input wire  [1:0]  reg_dstD,     
        input wire         we_regD,      
        input wire         alu_srcD,     
        input wire         we_dmD,       
        input wire  [1:0]  dm2regD,      
        input wire  [2:0]  alu_ctrlD,

        input  wire [31:0] rd1D,
        input  wire [31:0] rd2D,
        input  wire [4:0]  rsD,
        input  wire [4:0]  rtD,
        input  wire [4:0]  rdD,
        input  wire [31:0] pc_plus4D,
        input  wire [31:0] sext_immD,
        input  wire [31:0] instrD,
        input  wire [31:0] btaD,
        
        input  wire        clr,
        input  wire        clk,
        
        output reg  [31:0] pc_plus4E,
        output reg  [31:0] sext_immE,
        output reg  [31:0] rd1E,
        output reg  [31:0] rd2E,
        output reg  [4:0]  rsE,
        output reg  [4:0]  rtE,
        output reg  [4:0]  rdE,
        output reg [31:0]  instrE,
        output reg [31:0]  btaE,

        output reg         branchE,      
        output reg         jumpE,        
        output reg         jrE,          
        output reg         multuE,       
        output reg  [1:0]  wd_rf_signalE,
        output reg         hi_lo_writeE, 
        output reg  [1:0]  reg_dstE,     
        output reg         we_regE,      
        output reg         alu_srcE,     
        output reg         we_dmE,       
        output reg  [1:0]  dm2regE,      
        output reg  [2:0]  alu_ctrlE
    );
    
    initial begin
        pc_plus4E = 32'd0;
        sext_immE = 32'd0;
        
        rd1E = 32'd0;
        rd2E = 32'd0;
        rsE = 5'd0;
        rtE = 5'd0;
        rdE = 5'd0;
        instrE = 32'd0;
        btaE = 32'd0;

        branchE = 0;
        jumpE = 0;
        jrE = 0;
        multuE = 0;
        wd_rf_signalE = 0;
        hi_lo_writeE = 0;
        reg_dstE = 0;
        we_regE = 0;
        alu_srcE = 0;
        we_dmE = 0;
        dm2regE = 0;
        alu_ctrlE = 0;
    end
    
    always @(posedge clk) begin
        if (clr) begin
            pc_plus4E <= 32'd0;
            sext_immE <= 32'd0;
            
            rd1E <= 32'd0;
            rd2E <= 32'd0;
            rsE <= 5'd0;
            rtE <= 5'd0;
            rdE <= 5'd0;
            instrE <= 32'd0;
            btaE <= 32'd0;

            branchE <= 0;
            jumpE <= 0;
            jrE <= 0;
            multuE <= 0;
            wd_rf_signalE <= 0;
            hi_lo_writeE <= 0;
            reg_dstE <= 0;
            we_regE <= 0;
            alu_srcE <= 0;
            we_dmE <= 0;
            dm2regE <= 0;
            alu_ctrlE <= 0;
        end else begin
            pc_plus4E <= pc_plus4D;
            sext_immE <= sext_immD;
            instrE <= instrD;
            btaE <= btaD;
            
            rd1E <= rd1D;
            rd2E <= rd2D;
            rsE <= rsD;
            rtE <= rtD;
            rdE <= rdD;

            branchE <= branchD;
            jumpE <= jumpD;
            jrE <= jrD;
            multuE <= multuD;
            wd_rf_signalE <= wd_rf_signalD;
            hi_lo_writeE <= hi_lo_writeD;
            reg_dstE <= reg_dstD;
            we_regE <= we_regD;
            alu_srcE <= alu_srcD;
            we_dmE <= we_dmD;
            dm2regE <= dm2regD;
            alu_ctrlE <= alu_ctrlD;
        end
    end
    
endmodule
