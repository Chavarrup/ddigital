# ddigital  
Trabajo de grado - Diseño Digital  
Lina María Chavarro Meza - Abril 2025

---

## Módulo: `counter_4bit`

Implementa un contador binario de 4 bits con habilitación (`en`) y reinicio asíncrono (`rst`).

### Señales

- **Entradas:**
  - `clk` : Señal de reloj.
  - `rst` : Reset asíncrono (prioridad máxima).
  - `en`  : Habilita el conteo.

- **Salida:**
  - `q[3:0]` : Salida del contador.

### Comportamiento

- `rst = 1` → Reinicia el contador a 0.
- `rst = 0` y `en = 1` → Incrementa `q` en cada flanco de subida de `clk`.
- `en = 0` → Mantiene el valor de `q`.

### Código Verilog

```verilog
module counter_4bit (
  input clk,              
  input rst,              
  input en,               
  output reg [3:0] q      
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 4'b0000;
    else if (en)
      q <= q + 1;
  end

endmodule
