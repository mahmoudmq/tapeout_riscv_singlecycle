module top_tb();

logic clk, reset_n; 
logic [31:0] result;

// instantiate DUT
top top_ins (.clk(clk), .reset_n(reset_n), .result(result));


// clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;   // period = 10
end


// load instructions
initial begin
    $readmemh("instruction_mem.dat", top_ins.ism.mem);
    $readmemh("register_mem.dat", top_ins.rg_file.registers);
    $readmemh("data_mem.dat", top_ins.dm.memory);
    reset_n = 0;
    @(negedge clk);
    reset_n = 1;
    repeat(50)begin
        @(negedge clk);
    end
    $stop;
end


// monitoring
initial begin
    $monitor("Time = %0t | PC = %0d | Result = %0d |||| instruction = %h, ALU_result = %h", $time, top_ins.pc, result, top_ins.inst, top_ins.PCSrc, top_ins.ALU_result);
end



endmodule