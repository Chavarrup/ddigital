# counter_4bit

## Descripción General
Este módulo implementa un contador binario de 4 bits con habilitación (`en`) y reinicio asíncrono (`rst`).  
El contador incrementa su valor en cada flanco de subida de la señal de reloj (`clk`) si está habilitado.  
Si la señal de `rst` está activa, el contador se reinicia a cero inmediatamente, sin importar el reloj.

---

## Entradas

- **`clk`** (1 bit): Señal de reloj. El contador se actualiza en el flanco positivo.
- **`rst`** (1 bit): Reset asíncrono. Si está activo (`1`), reinicia el contador.
- **`en`** (1 bit): Habilita el conteo si `rst` no está activo.

---

## Salida

- **`q`** (4 bits): Valor actual del contador binario.

---

## Comportamiento

- Si `rst = 1`: el contador se reinicia a `0000` (asíncrono).
- Si `rst = 0` y `en = 1`: se incrementa el valor de `q` en cada flanco de subida de `clk`.
- Si `rst = 0` y `en = 0`: el valor de `q` se mantiene constante.

---

## Código Fuente

```verilog
module counter_4bit (
  input clk,              // Señal de reloj
  input rst,              // Reset asíncrono
  input en,               // Habilitación del contador
  output reg [3:0] q      // Salida del contador
);

  // Proceso secuencial: flanco de subida del clk o reset
  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 4'b0000;              // Reinicia contador
    else if (en)
      q <= q + 1;                // Incrementa si está habilitado
    // Si en = 0, mantiene valor
  end

endmodule
