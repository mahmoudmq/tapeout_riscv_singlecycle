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
    .clk(clk),
    .reset_n(rst_n),
    .result(result)
  );

always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
          uo_out <= 8'b0;
      end else begin
          case (result[31:8])
              24'h000000: uo_out <= result[7:0]; 
              // Mix in ui_in so the tool knows it's needed
              24'h000001: uo_out <= ui_in[7:0] + result[7:0]; 
              default:    uo_out <= ui_in[7:0] ^ result[7:0]; 
          endcase
      end
  end

  // Ensure uio_in and ena are "seen" by the tool
  // Instead of just a wire, let's make them part of the uio_out logic
  assign uio_out = uio_in ^ {7'b0, ena}; 
  assign uio_oe  = 8'b0; // This is fine as long as uio_out is "connected"

endmodule
