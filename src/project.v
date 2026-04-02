/*
 * Copyright (c) 2024 Mahmoud 
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output reg [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  logic [31:0] result;
  // instantiate top module
  top top_inst (
    .clk(ui_in[0]),
    .reset_n(ui_in[1]),
    .result(result)
  );

  always @(*) begin
      case (result[31:8])
          24'h000000: uo_out = result[7:0]; // Connect the lower 8 bits of the result to the output
          24'h000001: uo_out = 8'b1; // Example: Output a constant value when the upper bits are 0x000001
          default:uo_out = 8'b0; // Default case to prevent latches
      endcase
  end
  assign uio_out = 8'b0; // Set all bidirectional outputs to 0 (not used)
  assign uio_oe = 8'b0; // Set all bidirectional pins to input mode (not used)

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0, ui_in, uio_in};

endmodule
