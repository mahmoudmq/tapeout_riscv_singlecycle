module top(input clk, input reset_n, output [31:0] result);

reg [31:0] pc;
wire [31:0] inst;

wire PCSrc;
wire [1:0]ResultSrc;
wire [2:0] ALUControl; 
wire ALUSrc; 
wire [1:0] ImmSrc; 
wire RegWrite;
wire MemWrite;


wire [31:0]RD1, RD2;

wire  [31:0] extend_out;


wire Zero;

wire [31:0] ALU_result;

wire [31:0] read_data;

wire [31:0] src_b;

wire [31:0] PC_Plus_4;
wire [31:0] PC_Target;

instruction_mem ism (.PC(pc), .inst(inst));

control_unit ctr_u(.opcode(inst[6:0]), .funct7_5(inst[30]), .funct3(inst[14:12]), .Zero(Zero), 
                    .PCSrc(PCSrc), .ResultSrc(ResultSrc), .ALUControl(ALUControl),  .ALUSrc(ALUSrc),  .ImmSrc(ImmSrc),  .RegWrite(RegWrite), 
                    .MemWrite(MemWrite));

register_file rg_file (.A1(inst[19:15]), .A2(inst[24:20]), .A3(inst[11:7]), .WD3(result), 
                       .w_en(RegWrite), .clk(clk), .RD1(RD1), .RD2(RD2));

// // code for extend
// assign  extend_out  = {7'b0, $signed(inst[31:7])};

extend ex (.imm_Src(ImmSrc), .Instr(inst), .imm_extend(extend_out));



assign src_b = (!ALUSrc) ? RD2: extend_out;
alu al (.src_a(RD1), .src_b(src_b), .alu_control(ALUControl), .Zero(Zero), .result(ALU_result));



data_mem dm (.clk(clk), .WriteEnable(MemWrite), .WriteData(RD2), .Address(ALU_result), .ReadData(read_data));



assign result = (ResultSrc == 2'b00)? ALU_result: 
                (ResultSrc == 2'b01)? read_data: 
                (ResultSrc == 2'b10)? PC_Plus_4: 0;

PCPlus4 pc4 (.PC(pc), .PC_Plus_4(PC_Plus_4));

PCTarget pct (.PC(pc), .ImmExt(extend_out), .PC_Target(PC_Target));



always @(posedge clk, negedge reset_n) begin
    if (!reset_n)begin
        pc <= 0;
    end
    else begin
        pc <= (PCSrc)? PC_Target: PC_Plus_4;
    end
end

endmodule