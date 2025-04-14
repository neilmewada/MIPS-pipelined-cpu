module auxdec (
        input  wire [1:0] alu_op,
        input  wire [5:0] funct,
        output wire [2:0] alu_ctrl,
        output wire       jr,
        output wire       multu,
        output wire       hi_lo_write,
        output wire [1:0] wd_rf_signal
    );
    
    reg jr_en;
    reg [2:0] ctrl;
    reg multu_en;
    reg hi_lo;
    reg [1:0] wd_rf;
    
    assign {alu_ctrl}     = ctrl;
    assign {jr}           = jr_en;
    assign {multu}        = multu_en;
    assign {hi_lo_write}  = hi_lo;
    assign {wd_rf_signal} = wd_rf;
    
    initial begin
        jr_en = 0;
        ctrl = 3'd0;
        multu_en = 0;
        hi_lo = 0;
        wd_rf = 2'd0;
    end
     
    always @ (alu_op, funct) begin
        jr_en = 0;
        multu_en = 0;
        hi_lo = 0;
        wd_rf = 2'b00;
        
        case (alu_op)
            2'b00: ctrl = 3'b010;          // ADD
            2'b01: ctrl = 3'b110;          // SUB
            default: case (funct)
                
               
                6'b10_0100: ctrl = 3'b000; // AND
                6'b10_0101: ctrl = 3'b001; // OR
                6'b10_0000: ctrl = 3'b010; // ADD
                6'b00_0000: ctrl = 3'b011; // SLL
                6'b00_0010: ctrl = 3'b100; // SRL
                6'b10_0010: ctrl = 3'b110; // SUB
                6'b10_1010: ctrl = 3'b111; // SLT
                6'b00_1000: begin          // JR
                    ctrl = 3'bxxx;
                    jr_en = 1'b1;
                    end
                6'b01_1001: begin           // MULTU
                    ctrl = 3'bxxx;
                    hi_lo = 1;  
                    multu_en = 1;
                    $display("MULTU called, multu = %d", multu);
                    end
                6'b01_0010: begin           // MFLO
                    ctrl = 3'bxxx;
                    wd_rf = 2'b10;
                    $display("MFLO called");
                    end
                6'b01_0000: begin           // MFHI
                    ctrl = 3'bxxx;
                    wd_rf = 2'b01;
                    $display("MFHI called");
                    end
                    
                default:    begin
                    ctrl = 3'bxxx;
                    end
            endcase
        endcase
    end

endmodule