module mips (
        input  wire        clk,
        input  wire        rst,
        //input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm
        //output wire [31:0] rd3
    );
    
    /*wire       branch;
    wire       jump;
    wire       jr;
    wire [1:0] reg_dst;
    wire       we_reg;
    wire       alu_src;
    wire [1:0] dm2reg;
    wire [2:0] alu_ctrl;
    wire       multu;           // MULTU
    wire       hi_lo_write;     // Enable Hi and Lo overwrite
    wire [1:0] wd_rf_signal;    // For MFHI and MFLO
    */
    
    datapath dp (
            .clk            (clk),
            .rst            (rst),
            //.branch         (branch),
            //.jump           (jump),
            //.jr             (jr),
            //.reg_dst        (reg_dst),
            //.we_reg         (we_reg),
            //.alu_src        (alu_src),
            //.dm2reg         (dm2reg),
            //.alu_ctrl       (alu_ctrl),
            //.ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            //.multu          (multu),
            //.wd_rf_signal   (wd_rf_signal),
            //.hi_lo_write    (hi_lo_write),
            .pc_current     (pc_current),
            .alu_outM        (alu_out),
            .wd_dmM          (wd_dm)
            //.rd3            (rd3)
        );
    /*
    controlunit cu (
            .opcode         (instr[31:26]),
            .funct          (instr[5:0]),
            .branch         (branch),
            .jump           (jump),
            .jr             (jr),
            .multu          (multu),
            .wd_rf_signal   (wd_rf_signal),
            .hi_lo_write    (hi_lo_write),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .we_dm          (we_dm),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl)
        );
    */

endmodule