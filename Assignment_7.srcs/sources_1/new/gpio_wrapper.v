`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 04:19:13 PM
// Design Name: 
// Module Name: gpio_wrapper
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

module gpio_ad(
    input wire [1:0] A,
    input wire WE,
    
    output reg WE1,
    output reg WE2,
    output wire [1:0] RdSel
    );
    
    always@(*) begin
        case(A)
        
             2'b00: begin
                 WE1 = 1'b0;
                 WE2 = 1'b0;
             end
             
             2'b01: begin
                 WE1 = 1'b0;
                 WE2 = 1'b0;
             end
             
             2'b10: begin
                 WE1 = WE;
                 WE2 = 1'b0;
             end
             
             2'b11: begin
                 WE1 = 1'b0;
                 WE2 = WE;
             end
         
             default: begin
                WE1 = 1'bx;
                WE2 = 1'bx;
             end
         endcase
     end
     
     assign RdSel = A;
         
endmodule


module fw_mux4 #(parameter WIDTH = 32) (
        input  wire [1:0]       sel,
        input  wire [WIDTH-1:0] a,
        input  wire [WIDTH-1:0] b,
        input  wire [WIDTH-1:0] c,
        input  wire [WIDTH-1:0] d,
        
        output reg  [WIDTH-1:0] y
    );
    
    initial begin
        y = 0;
    end
    
    always @(*) begin
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            2'b11: y = d;
        endcase
    end
    
endmodule

module gpO_Reg#(parameter w = 32) (
    input wire Clk, Rst,
    input wire [w-1:0] D,
    input wire WriteEnable,
    output reg [w-1:0] Q
    );
    
    always @(posedge Clk, posedge Rst)
        if(Rst)
            Q <= 0;
        else if(WriteEnable)
            Q <= D;
        else
            Q <= Q;
endmodule

module gpio_wrapper#(parameter w = 32) (
    input wire Clk, Rst, WE,
    input wire [1:0] A,
    input wire [w-1:0] gpI1,
    input wire [w-1:0] gpI2,
    input wire [w-1:0] WD,
    
    output wire [w-1:0] RD,
    output wire [w-1:0] gpO1,
    output wire [w-1:0] gpO2
    );
    
    wire ad_to_reg_WE1;
    wire ad_to_reg_WE2;
    wire [1:0] ad_to_mux_RdSel;
    wire [w-1:0] reg_out1;
    wire [w-1:0] reg_out2;
    
    gpio_ad ad(
               .A(A),
               .WE(WE),
               .WE1(ad_to_reg_WE1),
               .WE2(ad_to_reg_WE2),
               .RdSel(ad_to_mux_RdSel)
               );
    
    fw_mux4 mux(
                .a(gpI1),
                .b(gpI2),
                .c(reg_out1),
                .d(reg_out2),
                .sel(ad_to_mux_RdSel),
                .y(RD)
                );
                
    gpO_Reg O1(
               .Clk(Clk),
               .Rst(Rst),
               .D(WD),
               .WriteEnable(ad_to_reg_WE1),
               .Q(reg_out1)
               );

    gpO_Reg O2(
               .Clk(Clk),
               .Rst(Rst),
               .D(WD),
               .WriteEnable(ad_to_reg_WE2),
               .Q(reg_out2)
               );
        
    assign gpO1 = reg_out1;
    assign gpO2 = reg_out2;
endmodule
