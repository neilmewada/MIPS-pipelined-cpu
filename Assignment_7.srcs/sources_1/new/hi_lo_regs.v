module hi_lo_regs(
        input wire        hi_lo_write,
        input wire [31:0] hi_input,
        input wire [31:0] lo_input,
        output reg [31:0] hi_reg,
        output reg [31:0] lo_reg
    );
    
    initial begin
        hi_reg = 0;
        lo_reg = 0;
    end
    
    always@(*) begin
        if(hi_lo_write) begin
            hi_reg <= hi_input;
            lo_reg <= lo_input;
            $display("hi = 0x%h, lo = 0x%h", hi_reg, lo_reg);
        end
    end

endmodule