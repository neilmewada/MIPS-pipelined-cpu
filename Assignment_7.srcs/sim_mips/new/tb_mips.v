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
        .instr      (instr)
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
        
        ra3D = 5'd4;
        ra3D = 5'd16;
        //ra_dm2 = 32'h10; // Read dmem at address 0x10
        tick;
        tick;
        
        // 1000 max iterations
        for (i = 0; i < 1000; i = i + 1) begin
            if (pc_current == 32'h30d0) begin
                clk = 1'b0; #5;
                $finish;
            end
            
            if (instr == 32'd0) begin
                clk = 1'b0; #5;
                $finish;
            end
            
            tick;
        end
        
        
        $finish;
    end

endmodule
