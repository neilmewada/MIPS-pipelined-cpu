module alu (
        input  wire [2:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        input  wire [4:0]  shamt,
        output wire        zero,
        output reg  [31:0] y
    );
    
    initial begin
        y = 32'd0;
    end

    assign zero = (y == 0);

    always @ (op, a, b) begin
        case (op)
            3'b000: y = a & b;
            3'b001: y = a | b;
            3'b010: y = a + b;
            3'b011: y = b << shamt; // SLL
            3'b100: y = b >> shamt; // SRL
            3'b110: y = a - b;
            3'b111: y = (a < b) ? 1 : 0;
        endcase
    end

endmodule