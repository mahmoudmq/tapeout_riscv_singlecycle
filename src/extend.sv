module extend (input [1:0] imm_Src, input [31:0] Instr, output reg [31:0] imm_extend);

always @(*) begin
    case(imm_Src)
    2'b00:  begin 
        imm_extend = {{20{Instr[31]}}, Instr[31:20]};
    end
    2'b01: begin 
        imm_extend = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
    end
    2'b10: begin 
        imm_extend = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
    end
    default:
        imm_extend = 32'b0;
    endcase
end


endmodule