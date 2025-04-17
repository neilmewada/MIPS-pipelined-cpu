`timescale 1ns / 1ps

module CNT #(parameter BUS_WIDTH=32) (
    input [BUS_WIDTH-1:0] d,
    input load_cnt,
    input en,
    input clk,
    output reg [BUS_WIDTH-1:0] q);
    
    always @(posedge clk) begin
        if (load_cnt)
            q <= d;
        else if (en)
            q <= q - 1'd1;
    end
    
endmodule

module REG #(parameter BUS_WIDTH=32) (
    input [BUS_WIDTH-1:0] d,
    input load_reg,
    input clk,
    output reg [BUS_WIDTH-1:0] q);
    
    initial begin
    q = 0;
    end
    
    always @(posedge clk) begin
        if (load_reg)
            q <= d;
    end

endmodule

module CMP #(parameter BUS_WIDTH=32) (
    input [BUS_WIDTH-1:0] a,
    input [BUS_WIDTH-1:0] b,
    output gt);
    
    assign gt = (a > b);
    
endmodule

module MUL #(parameter BUS_WIDTH=32) (
    input [BUS_WIDTH-1:0] x,
    input [BUS_WIDTH-1:0] y,
    output [BUS_WIDTH-1:0] z);

    assign z = x * y;
    
endmodule

module MUX2 #(parameter BUS_WIDTH=32) (
    input [BUS_WIDTH-1:0] d0,
    input [BUS_WIDTH-1:0] d1,
    input sel,
    output [BUS_WIDTH-1:0] out);
    
    assign out = (sel == 1) ? d1 : d0;
    
endmodule

module fac_datapath #(parameter BUS_WIDTH=32) (
    // Input
    input [BUS_WIDTH-1:0] number,
    // Control Signals
    input clk,
    input load_cnt,
    input load_reg,
    input cnt_enable,
    input reg_clear,
    input out_enable,
    // Status signals
    output error_status,
    output done_status,
    // Output
    output [BUS_WIDTH-1:0] data_out);
    
    CMP #(.BUS_WIDTH(BUS_WIDTH)) cmp(number, 32'd12, error_status);
    
    wire [BUS_WIDTH-1:0] cnt_q;

    CNT #(.BUS_WIDTH(BUS_WIDTH)) counter(.d(number), 
        .load_cnt(load_cnt),
        .en(cnt_enable),
        .clk(clk),
        .q(cnt_q));

    CMP #(.BUS_WIDTH(BUS_WIDTH)) doneCmp(2, cnt_q, done_status);
        
    wire [BUS_WIDTH-1:0] reg_out;
    wire [BUS_WIDTH-1:0] reg_in;
    wire [BUS_WIDTH-1:0] mul_out;
        
    MUL #(.BUS_WIDTH(BUS_WIDTH)) mul(.x(cnt_q), .y(reg_out), .z(mul_out));
    
    MUX2 #(.BUS_WIDTH(BUS_WIDTH)) regMux(mul_out, 32'd1, reg_clear, reg_in);
    
    REG #(.BUS_WIDTH(BUS_WIDTH)) register(.d(reg_in), .load_reg(load_reg), .clk(clk), .q(reg_out));
    
    MUX2 #(.BUS_WIDTH(BUS_WIDTH)) outMux(.d0(32'd0), .d1(reg_out), .sel(out_enable), .out(data_out));
    
endmodule

module fac_controlunit #(parameter BUS_WIDTH=32) (
    input go,
    input clk,

    // Status signals
    input error_status, // If In > 12
    input done_status,

    // Control signals
    output reg load_cnt,
    output reg cnt_enable,
    output reg reg_clear,
    output reg load_reg,
    output data_clk,
    output reg out_enable,

    // Output signals
    output reg done,
    output reg error);
    
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;
    
    reg [3:0] state, next, prev;

    initial begin
        state = S0;
        error = 0;
        done = 0;
        next = S0;
        load_cnt = 0;
        cnt_enable = 0;
        reg_clear = 0;
        load_reg = 0;
        out_enable = 0;
    end

    // State transition logic

    always @(*) begin
        case (state)
            S0: begin
                if (go)
                    next = error_status ? S1 : S2; // S1 = Error
                else
                    next = S0;
            end
            S1: begin // Error (In > 12)
                done <= 0;
                error <= 1;
                next = S0;
            end
            S2: begin // Set input to counter
                next = S3;
            end
            S3: begin // Set register to 1
                next = S4;
            end
            S4: begin // Check 2 > CNT
                if (done_status)
                    next = S5;
                else
                    next = S6;
            end
            S5: begin // Done!
                next = S0;
            end
            S6: begin // Multiply
                next = S7;
            end
            S7: begin // Decrement counter
                next = S4;
            end
        endcase
    end

    // Update the state flip-flop & apply it's logic:

    always @(posedge clk) begin
        prev = state;
        state = next;

        case (state)
            S0: begin // Idle
                out_enable <= 0;
                done = 0;
                error = 0;
            end
            S1: begin // Error (In > 12)
                out_enable = 0;
                error = 1;
                done = 0;
            end
            S2: begin // Set input to counter
                load_cnt = 1;
                cnt_enable = 0;
                reg_clear = 1;
            end
            S3: begin // Set register to 1
                load_cnt = 0;
                reg_clear = 1;
                load_reg = 1;
            end
            S4: begin // Check 2 > CNT
                cnt_enable = 0;
                reg_clear = 0;
                load_reg = 0;
            end
            S5: begin // Done!
                out_enable = 1;
                error = 0;
                done = 1;
            end
            S6: begin // Multiply and set register
                load_reg = 1;
            end
            S7: begin // Decrement CNT
                load_reg = 0;
                cnt_enable = 1;
            end
        endcase

    end

    assign data_clk = clk;
    
endmodule

module factorial_accelerator #(parameter BUS_WIDTH=32) (input [BUS_WIDTH-1:0] number,
    input clk,
    input go,
    output done,
    output error,
    output [BUS_WIDTH-1:0] data_out);

    wire data_clk;
    // Status signals
    wire error_status, done_status;

    // Control signals
    wire load_cnt;
    wire cnt_enable;
    wire reg_clear;
    wire out_enable;

    fac_controlunit #(.BUS_WIDTH(BUS_WIDTH)) CU(
        .go(go),
        .clk(clk),
        // Input Status Signals
        .error_status(error_status),
        .done_status(done_status),
        // Output Control Signals
        .load_cnt(load_cnt),
        .cnt_enable(cnt_enable),
        .reg_clear(reg_clear),
        .load_reg(load_reg),
        .out_enable(out_enable),
        .data_clk(data_clk),
        .done(done),
        .error(error)
    );

    fac_datapath #(.BUS_WIDTH(BUS_WIDTH)) DP(
        .number(number),
        .clk(data_clk),
        // Input control signals
        .load_cnt(load_cnt),
        .load_reg(load_reg),
        .cnt_enable(cnt_enable),
        .reg_clear(reg_clear),
        .out_enable(out_enable),
        // Output Status Signals
        .error_status(error_status),
        .done_status(done_status),
        // Final data output
        .data_out(data_out)
    );
    
endmodule
