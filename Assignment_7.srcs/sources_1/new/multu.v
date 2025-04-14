module multu (
        input  wire        multu,
        input  wire [31:0] rs,
        input  wire [31:0] rt,
        output reg  [31:0] hi,
        output reg  [31:0] lo
    );

    always @ (*) begin
        if(multu) begin
            $display("Inside if");
            {hi, lo} = rs * rt;
        end
        else begin
            $display("Inside else");
            {hi, lo} = 64'b0;
        end
        $display("multu = %d", multu);
    end

endmodule