`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 11:11:38 PM
// Design Name: 
// Module Name: factorial_wrapper
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

module fact_ad(
        input  wire [1:0]  a,
        input  wire        we,
        
        output reg         we1,
        output reg         we2,
        output wire [1:0]  rd_sel
    );
    
    initial begin
    we1 = 0;
    we2 = 0;
    end
    
    always @(*) begin
        case (a)
            2'b00: begin
                we1 <= we;
                we2 <= 0;
            end
            2'b01: begin
                we1 <= 0;
                we2 <= we;
            end
        endcase
    end
    
    assign rd_sel = a;

endmodule

module fact_reg #(parameter WIDTH = 32) (
        input  wire          clk,
        input  wire          rst,
        input  wire [WIDTH-1:0]  d,
        input  wire          load_reg,
        
        output reg  [WIDTH-1:0]  q
    );
    
    initial begin
    q = 0;
    end
    
    always @(posedge clk, posedge rst) begin
        if (rst)
            q <= 0;
        else if (load_reg)
            q <= d;
    end
    
endmodule

module mux4 #(parameter WIDTH = 32) (
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

module factorial_wrapper(
        input  wire        rst,
        input  wire        clk,
        input  wire        we,
        input  wire [1:0]  a,
        input  wire [3:0]  wd,
        
        output wire [31:0] rd
    );
    
    reg res_done;
    reg res_err;
    wire go_pulse_cmb;
    
    wire we1;
    wire we2;
    wire [1:0] rd_sel;
    
    wire zero;
    assign zero = 1'b0;
    
    wire one;
    assign one = 1'b1;
    
    wire done;
    wire err;
    
    wire [3:0] n;
    wire go;
    wire go_pulse;
    
    wire [31:0] result;
    
    initial begin
        res_done = 0;
        res_err = 0;
    end
    
    fact_ad ad(
        .a      (a),
        .we     (we),
        .we1    (we1),
        .we2    (we2),
        .rd_sel (rd_sel)
    );
    
    fact_reg #(.WIDTH(4)) n_reg(
        .clk      (clk),
        .rst      (zero),
        .d        (wd),
        .load_reg (we1),
        .q        (n)
    );
    
    fact_reg #(.WIDTH(1)) go_reg(
        .clk        (clk),
        .rst        (zero),
        .d          (wd[0]),
        .load_reg   (we2),
        .q          (go)
    );
    
    assign go_pulse_cmb = wd[0] & we2;
    
    fact_reg #(.WIDTH(1)) go_pulse_reg(
        .clk        (clk),
        .rst        (zero),
        .d          (go_pulse_cmb),
        .load_reg   (one),
        .q          (go_pulse)
    );
    
    wire [31:0] data_out;
    
    factorial_accelerator fact_acc(
        .clk        (clk),
        .go         (go_pulse),
        .number     ({28'd0, n}),
        .done       (done),
        .error      (error),
        .data_out   (data_out)
    );
    
    fact_reg #(.WIDTH(32)) result_reg(
        .clk        (clk),
        .rst        (zero),
        .d          (data_out),
        .load_reg   (done),
        .q          (result)
    );
    
    // res_done register
    always @(posedge clk, posedge rst) begin
        if (rst)
            res_done <= 1'b0;
        else
            res_done <= (~go_pulse_cmb) & (done | res_done);
    end
    
    // res_err register
    always @(posedge clk, posedge rst) begin
        if (rst)
            res_err <= 1'b0;
        else
            res_err <= (~go_pulse_cmb) & (err | res_err);
    end
    
    mux4 out_mux(
        .sel        (rd_sel),
        .a          ({28'd0, wd[3:0]}),
        .b          ({31'd0, go}),
        .c          ({30'd0, res_err, res_done}),
        .d          (result),
        .y          (rd)
    );
    
endmodule
