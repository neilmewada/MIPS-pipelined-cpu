`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 01:34:13 AM
// Design Name: 
// Module Name: tb_factorial_wrapper
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


module tb_factorial_wrapper;

    reg rst;
    reg clk;
    
    reg we;
    reg [1:0] a;
    reg [3:0] wd;
    wire [31:0] rd;
    
    integer i;
    
    initial begin
        rst = 0;
        clk = 0;
        we = 0;
        a = 2'd0;
        wd = 4'd0;
        
        i = 0;
    end
    
    wire go;
    wire [3:0] n;
    wire go_pulse;
    
    factorial_wrapper fact(
        .rst    (rst),
        .clk    (clk),
        .we     (we),
        .a      (a),
        .wd     (wd),
        .rd     (rd),
        
        .go     (go),
        .n      (n),
        .go_pulse (go_pulse)
    );
    
    task reset;
    begin
        rst = 1'b0; #5;
        rst = 1'b1; #5;
        rst = 1'b0;
    end
    endtask
    
    task tick;
    begin
        clk = 1'b1; #5;
        clk = 1'b0; #5;
    end
    endtask
    
    initial begin
        #5 // Wait for a delay before starting the test
        reset;
        #5
        
        tick;
        
        a = 2'b00;  // Write mode: n
        wd = 4'd5;  // n = 5
        we = 1;
        tick;
        tick;
        
        a = 2'b01;  // Write mode: Go
        wd = 4'd1;  // Go = 1
        we = 1;
        tick;
        tick;
        
        we = 0;
        
        a = 2'b10; // Read mode: Done,Err
        wd = 4'd0;
        tick;
        
        tick;
        
        /*for (i = 0; i < 32; i = i + 1) begin
            if (rd != 0) begin
                a = 2'b11; // Read mode: data output
                tick;
                $finish;
            end
            
            tick;
        end*/
    
        $finish;
    end

endmodule
