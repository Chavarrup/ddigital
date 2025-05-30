`timescale 1ns / 1ps

module multiplier (
  input wire clk,
  input wire rst,
  input wire wstrb,
  input wire rstrb,
  input wire [1:0] sel,         
  input wire [31:0] wdata,
  output reg [31:0] rdata,
  output wire wbusy,
  output wire rbusy,
  output wire [7:0] LED         
);

  reg [31:0] A = 0;
  reg [31:0] B = 0;
  reg [31:0] result = 0;
  reg start = 0;

  assign wbusy = 0;
  assign rbusy = 0;

  assign LED = result[7:0];  // Mostrar 8 bits menos significativos

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      A <= 0;
      B <= 0;
      result <= 0;
      start <= 0;
    end else begin
      if (wstrb) begin
        case (sel)
          2'b00: A <= wdata;     // Escribir A
          2'b01: B <= wdata;     // Escribir B
          2'b10: start <= 1;     // Iniciar multiplicación
        endcase
      end

      if (start) begin
        result <= A * B;         // Multiplicar en un ciclo
        start <= 0;              // Apagar start automáticamente
      end
    end
  end

  always @(*) begin
    case (sel)
      2'b00: rdata = A;
      2'b01: rdata = B;
      2'b10: rdata = start;
      2'b11: rdata = result;
      default: rdata = 32'hDEADBEEF;
    endcase
  end

endmodule
