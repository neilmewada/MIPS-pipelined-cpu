`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 07:30:44 PM
// Design Name: 
// Module Name: tb_mips
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


module tb_mips;

    reg clk;
    reg rst;
    reg [4:0] ra3D;
    wire [31:0] rd3D;
    
    wire [31:0] pc_current;
    wire [31:0]  instr;
    
    wire [31:0]  wd_dmM;
    wire [31:0] alu_outM;
    wire we_mem;
    wire we_fact;
    wire we_gpio;
    wire [1:0] rd_sel;
    
    reg [31:0] gpI1;
    reg [31:0] gpI2;
    wire [31:0] gpO1;
    wire [31:0] gpO2;
    
    integer i;

    initial begin
        clk = 0;
        rst = 0;
        //ra3D = 0;
        //ra_dm2 = 0;
    end
    
    mips DUT (
        .clk        (clk),
        .rst        (rst),
        .ra3D       (ra3D),
        .rd3D       (rd3D),
        .pc_current (pc_current),
        .instr      (instr),
        .gpI1       (gpI1),
        .gpI2       (gpI2),
        
        .wd_dmM     (wd_dmM),
        .alu_outM   (alu_outM),
        .we_mem     (we_mem),
        .we_fact    (we_fact),
        .we_gpio    (we_gpio),
        .rd_sel     (rd_sel),
        .gpO1       (gpO1),
        .gpO2       (gpO2)
    );
    
    task tick; 
    begin 
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end
    endtask
    
    task reset;
    begin 
        rst = 1'b0; #5;
        rst = 1'b1; #5;
        rst = 1'b0;
    end
    endtask
    
    initial begin
        #5 // Wait for a delay before starting the test
        reset;
        
        gpI1 = 32'd6;
        gpI2 = 32'd0;
        
        ra3D = 5'd4;
        ra3D = 5'd16;
        //ra_dm2 = 32'h10; // Read dmem at address 0x10
        tick;
        tick;
        
        // 1000 max iterations
        for (i = 0; i < 1000; i = i + 1) begin
            if (instr == 32'd0) begin
                clk = 1'b0; #5;
                $finish;
            end
            
            tick;
        end
        
        
        $finish;
    end

endmodule
