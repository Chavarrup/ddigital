`timescale 1ns / 1ps

module multiplier (
  input wire clk,
  input wire rst,
  input wire wstrb,
  input wire rstrb,
  input wire [1:0] sel,            // Selector de registro (A, B, START, RESULT)
  input wire [31:0] wdata,         // Datos para escritura
  output reg [31:0] rdata,         // Datos para lectura
  output wire wbusy,               // Indica si está ocupado multiplicando
  output wire rbusy,               // No usado, siempre 0, dejado para mantener compatibilidad? se puede eliminar?
  output reg [7:0] LED             // Salida de LEDs (parte baja del resultado)
);

  // Registros internos para operandos, resultado y contador  // Registros internos para operandos, resultado y contador
  reg [31:0] A;
  reg [31:0] B;
  reg [31:0] result;
  reg [31:0] counter;
  reg busy;
  reg start;

  // Asignaciones para las señales busy (solo escritura activa para busy)
  assign wbusy = busy;
  assign rbusy = 0; // No implementado

 // Proceso de escritura y multiplicación por suma sucesiva
  always @(posedge clk or posedge rst) begin
    if (rst) begin
    // Reset: poner todo en cero
      A <= 0; B <= 0; result <= 0; counter <= 0; start <= 0; busy <= 0;
    end else begin
      if (wstrb) begin
        // Escribir en registros según selector
        case (sel)
          2'b00: A <= wdata;  // Operando A
          2'b01: B <= wdata;  // Operando B
          2'b10: if (!busy) begin  // Inicio (START), solo si no está ocupado
                   result <= 0;
                   counter <= 0;
                   start <= 1;
                   busy <= 1;
                 end
        endcase
      end

      // Si busy, hacer suma repetitiva para multiplicar
      if (busy) begin
        if (counter < B) begin
          result <= result + A;   // Sumar A al acumulador
          counter <= counter + 1; // Incrementar contador
        end else begin
          busy <= 0;   // Multiplicación terminada
          start <= 0;
        end
      end
    end
  end

  // Proceso de lectura del registro seleccionado cuando rstrb está activo
  always @(*) begin
    if (rstrb) begin
      case (sel)
        2'b00: rdata = A;
        2'b01: rdata = B;
        2'b10: rdata = busy;     // Indica si está multiplicando
        2'b11: rdata = result;   // Resultado final
        default: rdata = 32'hDEADBEEF;  // Valor por defecto para depuración
      endcase
    end else begin
      rdata = 32'b0;  // Bus de lectura en cero si no se está leyendo
    end
  end

  // Actualización de LEDs con los 8 bits menos significativos del resultado
  always @(posedge clk)
    LED <= result[7:0];  // Mostrar solo 8 bits del resultado en los LEDs

endmodule
