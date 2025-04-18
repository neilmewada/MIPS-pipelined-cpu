module maindec (
        input  wire [5:0] opcode,
        input  wire       is_nop,
        output wire       branch,
        output wire       jump,
        output wire [1:0] reg_dst,
        output wire       we_reg,
        output wire       alu_src,
        output wire       we_dm,
        output wire [1:0] dm2reg,
        output wire [1:0] alu_op
    );

    reg [10:0] ctrl;

    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_op} = ctrl;
    
    initial begin
        ctrl = 11'd0;
    end

    always @ (opcode) begin
        case (opcode)
            6'b00_0000: ctrl = 11'b0_0_01_1_0_0_00_10; // R-type
            6'b00_1000: ctrl = 11'b0_0_00_1_1_0_00_00; // ADDI
            6'b00_0100: ctrl = 11'b1_0_00_0_0_0_00_01; // BEQ
            6'b00_0010: ctrl = 11'b0_1_00_0_0_0_00_00; // J
            6'b00_0011: ctrl = 11'b0_1_10_1_0_0_10_00; // JAL
            6'b10_1011: ctrl = 11'b0_0_00_0_1_1_00_00; // SW
            6'b10_0011: ctrl = 11'b0_0_00_1_1_0_01_00; // LW
            default:    begin
                ctrl = 11'bx_x_xx_x_x_x_xx_xx;
                $display("Unimplemented instruction encountered!");
            end
        endcase
    end

endmodule