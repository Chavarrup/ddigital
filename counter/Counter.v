//Módulo counter_4bit

//Descripción: Este módulo implementa un contador binario de 4 bits con habilitación (en) y reinicio asíncrono (rst). El contador incrementa su valor en cada flanco de subida del reloj (clk) si esta habilitado. Si la señal de rst está activa, el contador se reinicia a cero, sin importar el reloj.

//Entradas:
//-clk: señal de reloj. El contador cambia su valor en el flanco de subida
//-rst: reset asíncrono. Si se activa (1), el contador se reinicia a 0.
//-en: habilitación. Si está en 1 y `rst` no está activo, el contador incrementa.

//Salidas:
//-q: salida de 4 bits que representa el valor actual del contador.

//Comportamiento:
//-Si `rst` es 1, `q` se reinicia a 0 inmediatamente (asíncrono).
//-Si `rst` es 0 y `en` es 1, `q` se incrementa en cada flanco de subida de `clk`.
//   - Si `rst` es 0 y `en` es 0, `q` conserva su valor.

// Design
// Contador de 4 bits
module counter_4bit (clk, rst, en, q);
  input clk;      // Señal de reloj
  input rst;      // Reset asíncrono
  input en;       // Habilitación del contador
  output reg [3:0] q; // Salida de 4 bits

//Se ejecuta cuando hay un flanco de subida (posedge) en clk o reset
  always @(posedge clk or posedge rst) begin
    if (rst)       // Si reset está activo, reiniciar contador
      q <= 4'b0000;
    else if (en)   // Si enable está activo, incrementar
      q <= q + 1;
  end
endmodule
