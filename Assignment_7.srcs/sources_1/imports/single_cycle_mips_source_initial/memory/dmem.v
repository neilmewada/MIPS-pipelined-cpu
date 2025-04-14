 module dmem (
        input  wire        clk,
        input  wire        we,
        input  wire [5:0]  a,
        input  wire [31:0] d,
        output wire [31:0] q,
        input  wire        rst,
        
        // For debugging only
        input  wire [5:0]  a2,
        output wire [31:0] q2
    );

    reg [31:0] ram [0:63];

    integer n;

    initial begin
        for (n = 0; n < 64; n = n + 1) ram[n] = 32'hFFFFFFFF;
    end
    
    always @ (posedge rst) begin
    end

    always @ (posedge clk, posedge rst) begin
        if (rst) for (n = 0; n < 64; n = n + 1) ram[n] = 32'hFFFFFFFF;
        else if (we) begin
            ram[a] <= d;
        end
    end

    assign q = ram[a];
    
    // For debugging only
    assign q2 = ram[a2];
    
endmodule