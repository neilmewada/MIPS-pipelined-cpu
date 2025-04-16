module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        input  wire [4:0]  ra3D,

        output wire [31:0] pc_current,
        output wire [31:0] alu_outE,
        output wire [31:0] wd_dmM,
        output wire we_dmM,
        
        // Debugging wires
        output wire [4:0] rf_waW,
        output wire [31:0] rd3D,
        output wire we_regW,
        output wire [31:0] wd_rfW,
        output wire [31:0] alu_outM
    );

    
    wire [31:0] pc_plus4F;
    wire [31:0] pc_currentF;
    wire [31:0] pc_preE;
    wire [31:0] pc_next;
    wire [31:0] pc_after_jrM;
    wire pc_changeM;
    wire [31:0] sext_immD;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jtaM;
    wire [31:0] alu_paE;
    wire [31:0] alu_pbE;
    wire [31:0] wd_rf;
    wire [31:0] mult_hi_outE;     // MULTU output
    wire [31:0] mult_lo_outE;     // MULTU output
    wire [31:0] hi_reg_outE;     // hi_lo reg output
    wire [31:0] lo_reg_outE;     // hi_lo reg output
    
    wire we_regD;
    wire we_regE;
    wire we_regM;
    
    //wire [4:0]       rf_waW;
    //wire        wd_rfW;
    //wire        we_regW;
    
    //assign pc_src = branch & zero;
    //assign ba = {sext_imm[29:0], 2'b00};
    //assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};

    // ----------------------------------------------------------
    // --- IF Stage ---

    wire [31:0] pc_finalF;

    mux2 #(32) pc_reg_mux (
        .sel (pc_changeM),
        .a   (pc_plus4F),
        .b   (pc_after_jrM),
        .y   (pc_finalF)
    );

    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_finalF), // Change this to it's stage
            .q              (pc_currentF)
        );

    adder pc_plus_4 (
            .a              (pc_currentF),
            .b              (32'd4),
            .y              (pc_plus4F)
        );
        
    assign pc_current = pc_currentF;
    
    wire [31:0] instrD;
    wire [31:0] pc_plus4D;
    
    if_id_reg if_id (
        .instrF     (instr),
        .pc_plus4F  (pc_plus4F),
        .en         (1'b1),
        .clk        (clk),

        .instrD     (instrD),
        .pc_plus4D  (pc_plus4D)
    );

    // ----------------------------------------------------------
    // --- ID Stage ---

    wire [31:0] rd1D;
    wire [31:0] rd2D;
    wire [4:0]  rsD;
    wire [4:0]  rtD;
    wire [4:0]  rdD;

    wire [31:0] pc_plus4E;
    wire [31:0] sext_immE;
    wire [31:0] instrE;
    wire [31:0] rd1E;
    wire [31:0] rd2E;
    wire [4:0]  rsE;
    wire [4:0]  rtE;
    wire [4:0]  rdE;

    wire branchD;
    wire jumpD;
    wire jrD;
    wire multuD;
    wire [1:0] wd_rf_signalD;
    wire hi_lo_writeD;
    wire [1:0] reg_dstD;
    //wire we_regD;
    wire alu_srcD;
    wire we_dmD;
    wire [1:0] dm2regD;
    wire [2:0] alu_ctrlD;

    wire branchE;
    wire jumpE;
    wire jrE;
    wire multuE;
    wire [1:0] wd_rf_signalE;
    wire hi_lo_writeE;
    wire [1:0] reg_dstE;
    //wire we_regE;
    wire alu_srcE;
    wire we_dmE;
    wire [1:0] dm2regE;
    wire [2:0] alu_ctrlE;

    controlunit cu(
        .opcode         (instrD[31:26]),
        .funct          (instrD[5:0]),
        
        .branch         (branchD),
        .jump           (jumpD),
        .jr             (jrD),
        .multu          (multuD),
        .wd_rf_signal   (wd_rf_signalD),
        .hi_lo_write    (hi_lo_writeD),
        .reg_dst        (reg_dstD),
        .we_reg         (we_regD),
        .alu_src        (alu_srcD),
        .we_dm          (we_dmD),
        .dm2reg         (dm2regD),
        .alu_ctrl       (alu_ctrlD)
    );

    regfile rf (
            .clk            (clk),
            .we             (we_regW),
            .ra1            (instrD[25:21]),
            .ra2            (instrD[20:16]),
            .ra3            (ra3D),
            .wa             (rf_waW),
            .wd             (wd_rfW),
            .rd1            (rd1D),
            .rd2            (rd2D),
            .rd3            (rd3D),
            .rst            (rst)
        );

    signext se (
            .a              (instrD[15:0]),
            .y              (sext_immD)
        );

    id_ex_reg id_ex (
        .branchD         (branchD),
        .jumpD           (jumpD),
        .jrD             (jrD),
        .multuD          (multuD),
        .wd_rf_signalD   (wd_rf_signalD),
        .hi_lo_writeD    (hi_lo_writeD),
        .reg_dstD        (reg_dstD),
        .we_regD         (we_regD),
        .alu_srcD        (alu_srcD),
        .we_dmD          (we_dmD),
        .dm2regD         (dm2regD),
        .alu_ctrlD       (alu_ctrlD),

        .rd1D       (rd1D),
        .rd2D       (rd2D),
        .rsD        (rsD),
        .rtD        (rtD),
        .rdD        (rdD),
        .pc_plus4D  (pc_plus4D),
        .sext_immD  (sext_immD),
        .instrD     (instrD),

        .clr        (1'd0),
        .clk        (clk),

        .pc_plus4E  (pc_plus4E),
        .sext_immE  (sext_immE),
        .rd1E       (rd1E),
        .rd2E       (rd2E),
        .rsE        (rsE),
        .rtE        (rtE),
        .rdE        (rdE),
        .instrE     (instrE),

        .branchE         (branchE),
        .jumpE           (jumpE),
        .jrE             (jrE),
        .multuE          (multuE),
        .wd_rf_signalE   (wd_rf_signalE),
        .hi_lo_writeE    (hi_lo_writeE),
        .reg_dstE        (reg_dstE),
        .we_regE         (we_regE),
        .alu_srcE        (alu_srcE),
        .we_dmE          (we_dmE),
        .dm2regE         (dm2regE),
        .alu_ctrlE       (alu_ctrlE)
    );

    // ----------------------------------------------------------
    // --- EXE Stage ---

    wire [31:0] btaE;
    wire zeroE;
    wire [4:0]  rf_waE;
    //wire [31:0] alu_outE;

    wire [31:0] instrM;
    wire [31:0] alu_paM;
    wire [31:0] btaM;
    wire zeroM;
    wire [4:0]  rf_waM;
    wire [31:0] pc_plus4M;
    //wire [31:0] alu_outM;

    wire [1:0] wd_rf_signalM;
    wire hi_lo_writeM;

    wire branchM;
    wire jumpM;
    wire jrM;
    wire [1:0] dm2regM;
    //wire we_dmM;
    //wire we_regM;
    wire [31:0] wd_dmE;

    wire [31:0] hi_reg_outM;     // hi_lo reg output
    wire [31:0] lo_reg_outM;     // hi_lo reg output

    wire [31:0] rf_wd_outE;      // output of mux to input of last mux for wd

    mux2 #(32) alu_pb_mux (
        .sel            (alu_srcE),
        .a              (rd2E),
        .b              (sext_immE),
        .y              (alu_pbE)
    );

    assign alu_paE = rd1E;
    assign wd_dmE = rd2E;

    alu alu (
        .op             (alu_ctrlE),
        .a              (alu_paE),
        .b              (alu_pbE),
        .shamt          (instrE[10:6]),
        .zero           (zeroE),
        .y              (alu_outE)
    );

    mux3 #(5) rf_wa_mux (
        .sel            (reg_dstE),
        .a              (instrE[20:16]),
        .b              (instrE[15:11]),
        .c              (5'b11111),
        .y              (rf_waE)
    );

    assign ba = {sext_immE[29:0], 2'b00};

    adder pc_plus_br (
        .a  (ba),
        .b  (pc_plus4E),
        .y  (btaE)
    );

    multu my_multu (
        .multu              (multuE),
        .rs                 (alu_paE),       // alu_pa = rd1 = instr[25:21]
        .rt                 (rd2E),        // wd_dm = rd2 = instr[20:16]
        .hi                 (mult_hi_outE),  // connected to hi_lo_regs
        .lo                 (mult_lo_outE)
    );
    
    hi_lo_regs hi_lo_regs (
        .hi_lo_write        (hi_lo_writeE),
        .hi_input           (mult_hi_outE),
        .lo_input           (mult_lo_outE),
        .hi_reg             (hi_reg_outE),   // use for MFHI
        .lo_reg             (lo_reg_outE)    // use for MFLO
    );
    
    // EXE to MEM register
    ex_mem_reg ex_mem (
        .alu_outE   (alu_outE),
        .btaE       (btaE),
        .zeroE      (zeroE),
        .rf_waE     (rf_waE),
        .wd_dmE     (wd_dmE),
        .wd_rf_signalE (wd_rf_signalE),
        .hi_reg_outE (hi_reg_outE),
        .lo_reg_outE (lo_reg_outE),
        .alu_paE     (alu_paE),
        .pc_plus4E   (pc_plus4E),
        .instrE        (instrE),

        .branchE    (branchE),
        .jumpE      (jumpE),
        .jrE        (jrE),
        .dm2regE    (dm2regE),
        .we_dmE     (we_dmE),
        .we_regE    (we_regE),

        .clk        (clk),

        .alu_outM   (alu_outM),
        .btaM       (btaM),
        .zeroM      (zeroM),
        .rf_waM     (rf_waM),
        .wd_rf_signalM (wd_rf_signalM),
        .hi_reg_outM   (hi_reg_outM),
        .lo_reg_outM   (lo_reg_outM),
        .alu_paM     (alu_paM),
        .pc_plus4M   (pc_plus4M),
        .instrM       (instrM),

        .branchM    (branchM),
        .jumpM      (jumpM),
        .jrM        (jrM),
        .dm2regM    (dm2regM),
        .we_dmM     (we_dmM),
        .we_regM    (we_regM),
        .wd_dmM     (wd_dmM)
    );

    // ----------------------------------------------------------
    // --- MEM Stage ---

    wire        pc_srcM;
    wire [31:0] pc_preM;
    wire [31:0] pc_nextM;
    wire [31:0] alu_outW;
    wire [31:0] pc_plus4W;

    wire [1:0] wd_rf_signalW;
    wire [31:0] rf_wd_outW;
    wire [31:0] hi_reg_outW;
    wire [31:0] lo_reg_outW;
    wire [1:0] dm2regW;

    wire [31:0] rd_dmW;

    assign pc_srcM = branchM & zeroM;
    assign jtaM = {pc_plus4M[31:28], instrM[25:0], 2'b00};
    assign pc_changeM = pc_srcM | jumpM | jrM;

    mux2 #(32) pc_src_mux (
        .sel            (pc_srcM),
        .a              (pc_plus4M),
        .b              (btaM),
        .y              (pc_preM)
    );

    mux2 #(32) pc_jmp_mux (
            .sel            (jumpM),
            .a              (pc_preM),
            .b              (jtaM),
            .y              (pc_nextM)
        );
    
    mux2 #(32) pc_jr_mux (
            .sel            (jrM),
            .a              (pc_nextM),
            .b              (alu_paM),
            .y              (pc_after_jrM)
        );
        
    mem_wb_reg mem_wb(
        .wd_rf_signalM  (wd_rf_signalM),
        .hi_reg_outM    (hi_reg_outM),
        .lo_reg_outM    (lo_reg_outM),
        .alu_outM       (alu_outM),
        .we_regM        (we_regM),
        .rf_waM         (rf_waM),
        .dm2regM        (dm2regM),
        .rd_dmM         (rd_dm),
        .pc_plus4M      (pc_plus4M),

        .clk            (clk),

        .wd_rf_signalW  (wd_rf_signalW),
        .hi_reg_outW    (hi_reg_outW),
        .lo_reg_outW    (lo_reg_outW),
        .alu_outW       (alu_outW),
        .we_regW        (we_regW),
        .rf_waW         (rf_waW),
        .dm2regW        (dm2regW),
        .rd_dmW         (rd_dmW),
        .pc_plus4W      (pc_plus4W)
    );  

    // ----------------------------------------------------------
    // --- WB Stage ---

    mux3 #(32) rf_wd_mux (
        .sel            (dm2regW),
        .a              (alu_outW),
        .b              (rd_dmW),
        .c              (pc_plus4W),
        .y              (rf_wd_outW)
    );

    // --- Mux to Choose a) rf_wd_mux output | b) hi_reg_out | c) lo_reg_out 
    // will be input to wd of register file
    mux3 #(32) rf_wd_final (
        .sel            (wd_rf_signalW),
        .a              (rf_wd_outW),
        .b              (hi_reg_outW),
        .c              (lo_reg_outW),
        .y              (wd_rfW)
    );

endmodule