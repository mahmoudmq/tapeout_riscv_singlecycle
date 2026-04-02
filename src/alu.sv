module alu(
input [31:0] src_a, src_b,
input [2:0] alu_control,
output Zero,
output reg [31:0] result
);

always @(*) begin

    case (alu_control)

        3'b000: result = src_a + src_b;     // ADD
        3'b001: result = src_a - src_b;     // SUB
        3'b101: result = src_a < src_b;     // SLT
        3'b011: result = src_a | src_b;     // OR
        3'b010: result = src_a & src_b;     // AND


        default: result = 32'b0;

    endcase

end

assign Zero = (result == 0);

endmodule