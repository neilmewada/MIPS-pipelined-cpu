`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 10:02:26 AM
// Design Name: 
// Module Name: tb_datapath
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


module tb_datapath;

    reg         clk;
    reg         rst;
    
    reg [4:0] ra3D;
    wire [31:0] rd3D;
    
    reg [31:0] ra_dm2;
    wire [31:0] rd_dm2;
    
    wire [31:0]  instr;
    wire [31:0]  rd_dm;
    wire [31:0]  wd_dmM;
    wire [4:0]   rf_waW;
    wire we_dmM;
    wire we_regW;
    wire [31:0] wd_rfW;
    
    wire [31:0] pc_current;
    wire [31:0] alu_outM;
    
    initial begin
        clk = 0;
        rst = 0;
        
    end
    
    integer i;

    datapath DUT (
        .clk            (clk),
        .rst            (rst),
        .ra3D           (ra3D),
        .instr          (instr),
        .rd_dm          (rd_dm),
        .pc_current     (pc_current),
        .wd_dmM         (wd_dmM),
        .we_dmM         (we_dmM),
        .rf_waW         (rf_waW),
        .rd3D           (rd3D),
        .we_regW        (we_regW),
        .wd_rfW         (wd_rfW),
        .alu_outM       (alu_outM)
    );
    
    imem imem (
        .a              (pc_current[9:2]),
        .y              (instr)
    );

    dmem dmem (
        .clk            (clk),
        .we             (we_dmM),
        .a              (alu_outM[9:2]),
        .d              (wd_dmM),
        .q              (rd_dm),
        .rst            (rst),
        
        .a2             (ra_dm2[9:2]),
        .q2             (rd_dm2)
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
        ra_dm2 = 32'h10; // Read dmem at address 0x10
        
        for (i = 0; i < 1000; i = i + 1) begin // Never loop more than 1000 times
            //if (pc_current == 32'h3074) begin
            if (pc_current == 32'h30d0) begin
                clk = 1'b0; #5;
                $finish;
            end
        
            if (i == 32'h15) begin
                $display("Break");
            end
           tick; 
        end
        
        $finish;
    end

endmodule
