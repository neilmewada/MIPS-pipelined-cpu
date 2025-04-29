`timescale 1ns / 1ps

module mips(
        input  wire         clk,
        input  wire         rst,
        input  wire [4:0]   ra3D,
        
        output wire [31:0]  rd3D,
        output wire [31:0]  pc_current,
        output wire [31:0]  instr,
        
        // Debugging wires
        output wire [31:0]  wd_dmM,
        output wire [31:0] alu_outM,
        output wire we_mem,
        output wire we_fact,
        output wire [1:0] rd_sel
    );
    
    //reg [4:0] ra3D;
    //wire [31:0] rd3D;
    
    reg [31:0] ra_dm2;
    wire [31:0] rd_dm2;
    
    //wire [31:0]  instr;
    wire [31:0]  rd_dm;
    //wire [31:0]  wd_dmM;
    wire [4:0]   rf_waW;
    wire we_dmM;
    wire we_regW;
    wire [31:0] wd_rfW;
    
    //wire [31:0] pc_current;
    //wire [31:0] alu_outM;
    
    initial begin
        //ra3D = 0;
        ra_dm2 = 0;
    end
    
    integer i;

    datapath DUT (
        .clk            (clk),
        .rst            (rst),
        .ra3D           (ra3D),
        .instr          (instr),
        .rd_dm          (rd_dm),
        .pc_current     (pc_current),
        .wd_dmM         (wd_dmM),
        .we_dmM         (we_dmM),
        .rf_waW         (rf_waW),
        .rd3D           (rd3D),
        .we_regW        (we_regW),
        .wd_rfW         (wd_rfW),
        .alu_outM       (alu_outM)
    );
    
    imem imem (
        .a              (pc_current[9:2]),
        .y              (instr)
    );
    
    //wire we_mem;
    //wire we_fact;
    wire we_gpio;
    //wire [1:0] rd_sel;
    
    wire [31:0] mem_data;
    wire [31:0] fact_data;
    
    address_decoder ad (
        .we             (we_dmM),
        .a              (alu_outM[15:14]),
        .we_mem         (we_mem),
        .we_fact        (we_fact),
        .we_gpio        (we_gpio),
        .rd_sel         (rd_sel)
    );

    dmem dmem (
        .clk            (clk),
        .we             (we_dmM),
        .a              (alu_outM[9:2]),
        .d              (wd_dmM),
        .q              (mem_data),
        .rst            (rst),
        
        .a2             (ra_dm2[9:2]),
        .q2             (rd_dm2)
    );
    
    
    factorial_wrapper fact (
        .rst    (rst),
        .clk    (clk),
        .we     (we_fact),
        .a      (alu_outM[3:2]),
        .wd     (wd_dmM[3:0]),
        .rd     (fact_data)
    );
    
    fw_mux4 #(.WIDTH(32)) read_mux (
        .sel        (rd_sel),
        .a          (mem_data),
        .b          (mem_data),
        .c          (fact_data),
        .d          (32'd0),
        .y          (rd_dm)
    );
    
    // TODO: Add GPIO here

endmodule