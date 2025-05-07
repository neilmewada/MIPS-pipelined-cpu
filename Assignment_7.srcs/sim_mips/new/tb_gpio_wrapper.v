`timescale 1ns / 1ps


module tb_gpio_wrapper();

    reg Clk, Rst, WE;
    reg [1:0] A;
    reg [31:0] gpI1;
    reg [31:0] gpI2;
    reg [31:0] WD;
    
    wire [31:0] RD;
    wire [31:0] gpO1;
    wire [31:0] gpO2;
    
    initial begin
        Clk = 0;
        Rst = 0;
        WE = 0;
        A = 0;
        gpI1 = 0;
        gpI2 = 0;
    end
        
    
    gpio_wrapper gpio(
        .Clk(Clk),
        .Rst(Rst),
        .WE(WE),
        .A(A),
        .gpI1(gpI1),
        .gpI2(gpI2),
        .WD(WD),
        .RD(RD),
        .gpO1(gpO1),
        .gpO2(gpO2)
    );
    
    task reset;
    begin
        Rst = 1'b0; #5;
        Rst = 1'b1; #5;
        Rst = 1'b0;
    end
    endtask
    
    task tick;
    begin
        Clk = 1'b1; #5;
        Clk = 1'b0; #5;
    end
    endtask
    
    initial begin
        #5
        reset;
        #5
         
        tick;
        
        // Read input reg 1
        A = 2'b00;
        WE = 0;
        gpI1 = 32'h00000001; 
        gpI2 = 0;
        WD = 0;
        
        tick;

        tick;
        
        // Read input reg 2
        A = 2'b01;
        WE = 0;
        gpI1 = 0;
        gpI2 = 32'h00000002;
        WD = 0;
        
        tick;
        
        tick;
        
        // Write to output reg 1 but no WriteEnable
        A = 2'b10;
        WE = 0;
        gpI1 = 0;
        gpI2 = 0;
        WD = 32'h00010000;
        
        tick;
        
        tick;
        
        // Write to output reg 1 with WriteEnable
        A = 2'b10;
        WE = 1;
        gpI1 = 0;
        gpI2 = 0;
        WD = 32'h00010000;
        
        tick;
        tick;
        
        tick;
        
        // Write to output reg 2 but no WriteEnable
        A = 2'b11;
        WE = 0;
        gpI1 = 0;
        gpI2 = 0;
        WD = 32'h00020000;
        
        tick;
        tick;
        
        tick;
        
        // Write to output reg 2 with WriteEnable
        A = 2'b11;
        WE = 1;
        gpI1 = 0;
        gpI2 = 0;
        WD = 32'h00020000;
        
        tick;
        tick;
        
        $finish;
         
    
    end
endmodule
