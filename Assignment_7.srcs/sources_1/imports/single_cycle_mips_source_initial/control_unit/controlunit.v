module controlunit (
        input  wire [5:0]  opcode,
        input  wire [5:0]  funct,
        output wire        branch,
        output wire        jump,
        output wire        jr,
        output wire        multu,
        output wire [1:0]  wd_rf_signal,
        output wire        hi_lo_write,
        output wire [1:0]  reg_dst,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm,
        output wire [1:0]  dm2reg,
        output wire [2:0]  alu_ctrl
    );
    
    wire [1:0] alu_op;

    maindec md (
        .opcode         (opcode),
        .branch         (branch),
        .jump           (jump),
        .reg_dst        (reg_dst),
        .we_reg         (we_reg),
        .alu_src        (alu_src),
        .we_dm          (we_dm),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op)
    );

    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .alu_ctrl       (alu_ctrl),
        .jr             (jr),
        .multu          (multu),
        .hi_lo_write    (hi_lo_write),
        .wd_rf_signal   (wd_rf_signal)
    );

endmodule