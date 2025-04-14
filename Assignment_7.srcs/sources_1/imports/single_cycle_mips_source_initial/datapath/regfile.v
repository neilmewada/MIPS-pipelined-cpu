module regfile (
        input  wire        clk,
        input  wire        we,
        input  wire [4:0]  ra1,
        input  wire [4:0]  ra2,
        input  wire [4:0]  ra3,
        input  wire [4:0]  wa,
        input  wire [31:0] wd,
        output reg  [31:0] rd1,
        output reg  [31:0] rd2,
        output reg  [31:0] rd3,
        input  wire        rst
    );

    reg [31:0] rf [0:31];

    integer n;
    
    initial begin
        for (n = 0; n < 32; n = n + 1) rf[n] = 32'h0;
        rf[29] = 32'h100; // Initialze $sp
    end
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            for (n = 0; n < 32; n = n + 1) rf[n] = 32'h0;
            rf[29] = 32'h100; // Initialze $sp
        end
        //else if (clk && we) rf[wa] <= wd;
        $display("Writing 0x%h to register %d", wd, wa);
    end
    
    always @(*) begin
        if (clk && we) begin
            rf[wa] <= wd;
        end
    end
    
    always @ (negedge clk) begin
        rd1 <= (ra1 == 0) ? 0 : rf[ra1];
        rd2 <= (ra2 == 0) ? 0 : rf[ra2];
        rd3 <= (ra3 == 0) ? 0 : rf[ra3];
    end

    //assign rd1 = (ra1 == 0) ? 0 : rf[ra1];
    //assign rd2 = (ra2 == 0) ? 0 : rf[ra2];
    //assign rd3 = (ra3 == 0) ? 0 : rf[ra3];

endmodule