module data_mem #(
    parameter DATA_WIDTH = 32, // Width of data
    parameter ADDR_WIDTH = 32, 
    parameter MEM_SIZE = 32 
)(
    input clk,
    input WriteEnable,
    input [DATA_WIDTH-1:0] WriteData,
    input [ADDR_WIDTH-1:0] Address,
    output [DATA_WIDTH-1:0] ReadData
);

    reg [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];

    assign ReadData = memory[Address[ADDR_WIDTH-1:0]]; 

    always @(posedge clk) begin
        if (WriteEnable) begin
            memory[Address[ADDR_WIDTH-1:0]] = WriteData; // Write data to memory
        end
    end

endmodule