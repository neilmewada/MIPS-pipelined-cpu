`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 10:06:43 PM
// Design Name: 
// Module Name: address_decoder
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


module address_decoder(
        input  wire        we,
        input  wire [1:0]  a, // a = address[15:14]
        
        output reg         we_mem,
        output reg         we_fac,
        output reg         we_gpio,
        output wire [1:0]  rd_sel
    );
    
    // Memory base addr     : 0x0000
    // Factorial base addr  : 0x8000
    // GPIO base addr       : 0xC000
    
    initial begin
    we_mem = 0;
    we_fac = 0;
    we_gpio = 0;
    end
    
    always @(*) begin
        case (a)
            2'b00: begin
                we_mem <= we;
                we_fac <= 0;
                we_gpio <= 0; 
            end
            2'b10: begin // 0x8
                we_mem <= 0;
                we_fac <= we;
                we_gpio <= 0; 
            end
            2'b11: begin // 0xC
                we_mem <= 0;
                we_fac <= 0;
                we_gpio <= we; 
            end
        endcase
    end
    
    assign rd_sel = a;
    
endmodule
