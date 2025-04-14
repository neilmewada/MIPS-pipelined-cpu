`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 08:18:34 PM
// Design Name: 
// Module Name: mem_wb_reg
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


module mem_wb_reg(
        input wire [1:0]  wd_rf_signalM,
        input wire [31:0] hi_reg_outM,
        input wire [31:0] lo_reg_outM,
        input wire [31:0] alu_outM,
        input wire        we_regM,
        input wire [4:0]  rf_waM,
        input wire [1:0]  dm2regM,
        input wire [31:0] rd_dmM,
        input wire [31:0] pc_plus4M,
        
        input wire clk,

        output reg [1:0]  wd_rf_signalW,
        output reg [31:0] hi_reg_outW,
        output reg [31:0] lo_reg_outW,
        output reg [31:0] alu_outW,
        output reg        we_regW,
        output reg [4:0]  rf_waW,
        output reg [1:0]  dm2regW,
        output reg [31:0] rd_dmW,
        output reg [31:0] pc_plus4W
    );
    
    initial begin
        wd_rf_signalW = 0;
        hi_reg_outW = 0;
        lo_reg_outW = 0;
        alu_outW = 0;
        we_regW = 0;
        rf_waW = 0;
        dm2regW = 0;
        rd_dmW = 0;
        pc_plus4W = 0;
    end

    always @(posedge clk) begin
        wd_rf_signalW <= wd_rf_signalM;
        hi_reg_outW <= hi_reg_outM;
        lo_reg_outW <= lo_reg_outM;
        alu_outW <= alu_outM;
        we_regW <= we_regM;
        rf_waW <= rf_waM;
        dm2regW <= dm2regM;
        rd_dmW <= rd_dmM;
        pc_plus4W <= pc_plus4M;
    end
    
endmodule
