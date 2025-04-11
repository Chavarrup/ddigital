# counter_4bit_with_load

## Descripción General
Este módulo implementa un contador binario de 4 bits con funcionalidad adicional de carga paralela mediante la señal `load` y la entrada `d`.  
Es una extensión del contador clásico sin carga, que se observa en la sección anterior.

---

## Entradas

- **`clk`** (1 bit): Señal de reloj. El contador se actualiza en el flanco positivo.
- **`rst`** (1 bit): Reset asíncrono. Si está activo (`1`), reinicia el contador. Máxima prioridad.
- **`en`** (1 bit): Habilita el conteo cuando `load` está inactivo.
- **`load`** (1 bit): Si está activo (`1`), se carga el valor de `d` en `q`.
- **`d`** (4 bits): Valor de entrada a cargar en `q` cuando `load = 1`.

---

## Salida

- **`q`** (4 bits): Valor actual del contador o valor cargado desde `d`.

---

## Comportamiento

- Si `rst = 1`: el contador se reinicia a `0000` (asíncrono).
- Si `load = 1` y `rst = 0`: se carga el valor de `d` en `q`.
- Si `load = 0` y `en = 1`: se incrementa el valor de `q`.
- Si `load = 0` y `en = 0`: el valor de `q` se mantiene constante.

---

## Código Fuente

```verilog
module counter_4bit_with_load (
  input clk,              // Señal de reloj
  input rst,              // Reset asíncrono
  input en,               // Habilitación del contador
  input load,             // Carga paralela
  input [3:0] d,          // Valor paralelo a cargar si load=1
  output reg [3:0] q      // Salida del contador
);

// Proceso secuencial: flanco de subida del clk o reset
  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 4'b0000;              // Reinicia contador
    else if (load)
      q <= d;                    // Carga valor de d en q
    else if (en)
      q <= q + 1;                // Incrementa si está habilitado
    // Si load = 0 y en = 0, mantiene valor
  end

endmodule
