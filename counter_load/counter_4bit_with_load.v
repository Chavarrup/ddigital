// Módulo: counter_4bit_with_load
// Descripción:
// Extensión del contador de 4 bits básico para incluir funcionalidad de carga paralela a través de la señal 'load' y la entrada de datos 'd'.

// Comportamiento adicional:
//-Si 'load' está activo (1) en el flanco positivo del reloj, el contador cargará el valor de entrada 'd' en la salida 'q'.
//- Esta operación tiene prioridad sobre la habilitación 'en'.
//- Si 'load' está inactivo (0) y 'en' está activo (1), el contador se incrementa en 1 en cada flanco de reloj.
//- Si 'load' = 0 y 'en' = 0, el valor de 'q' se mantiene constante.
//- Si 'rst' está activo, el contador se reinicia a cero de forma asíncrona. =============================================================

module counter_4bit_with_load (
  input clk,              // Señal de reloj
  input rst,              // Reset asíncrono
  input en,               // Habilitación del contador
  input load,             // Carga paralela
  input [3:0] d, //Entrada paralela a cargar si load está en 1
  output reg [3:0] q      // Salida del contador
);

  // Proceso secuencial: flanco de subida del clk o reset
  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 4'b0000;              // Reinicia contador
    else if (load)
      q <= d;                    // Carga valor de d en q
    else if (en)
      q <= q + 1;            // Incrementa si está habilitado
  // Si load = 0 y en = 0 → mantiene valor
  end

endmodule