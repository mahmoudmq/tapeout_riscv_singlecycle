module PCPlus4(
    input [31:0] PC,
    output reg [31:0] PC_Plus_4
);
    always @(*) begin
        PC_Plus_4 = PC + 4; // Calculate PC + 4
    end
endmodule