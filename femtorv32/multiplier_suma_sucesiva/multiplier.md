
# `multiplier.v` — Multiplicador por desplazamiento y suma condicional (FemtoRV32)

Este módulo implementa un multiplicador secuencial de 32 bits usando el método clásico de **doble y suma**, mediante **desplazamientos binarios** y acumulación condicional. Es un diseño liviano, ideal para sistemas como FemtoRV32.

---

## Características

- Multiplicación A × B usando lógica binaria (shift-and-add).
- Funciona en 32 ciclos como máximo.
- Interfaz de 4 registros accesibles vía memoria mapeada.
- Indicación visual del resultado parcial con LEDs.
- Bajo uso de recursos: no requiere multiplicadores dedicados.

---

## Registros mapeados

| Offset (bytes) | Nombre    | Descripción               |
|----------------|-----------|---------------------------|
| `0`            | A         | Operando A                |
| `4`            | B         | Operando B                |
| `8`            | START     | Inicia la operación       |
| `12`           | RESULT    | Resultado final           |

---

## Señales

### Entradas
- `clk`: reloj del sistema.
- `rst`: reset asíncrono.
- `wstrb`: escritura activa.
- `rstrb`: lectura activa.
- `sel[1:0]`: selección de registro.
- `wdata[31:0]`: datos de entrada.

### Salidas
- `rdata[31:0]`: datos de salida según el registro leído.
- `wbusy`: indica si la multiplicación está en curso.
- `rbusy`: no implementado (siempre 0, reservado).
- `LED[7:0]`: bits menos significativos del resultado.

---

## Funcionamiento paso a paso

1. **Carga de operandos:**  
   - Se escriben los valores A y B en sus respectivos registros.

2. **Inicio de la operación:**  
   - Escribir en el registro `START` inicia la multiplicación, si no está ocupado (`busy = 0`).

3. **Multiplicación iterativa por desplazamiento y suma condicional:**  
   - Si el bit menos significativo (`B[0]`) es `1`, se suma `A` al acumulador `result`.
   - Luego:
     - `A` se multiplica por 2 (`A << 1`).
     - `B` se divide por 2 (`B >> 1`).
   - El proceso se repite 32 veces como máximo.

4. **Finalización:**  
   - Cuando se han procesado todos los bits de `B`, `busy` se desactiva y el resultado queda disponible.

5. **Lectura del resultado:**  
   - Se puede leer el resultado parcial o final accediendo al registro `RESULT`.

6. **Visualización con LEDs:**  
   - Se reflejan los 8 bits menos significativos del resultado en la salida `LED`.

---

## Método de multiplicación usado: Shift and Add

Este módulo implementa una multiplicación binaria tradicional por desplazamiento y suma, basada en los siguientes principios:

- En binario, multiplicar `A × B` puede verse como sumar `A × 2ⁿ` para cada bit `B[n]` que sea 1.
- Por cada ciclo de reloj:
  - Se evalúa el bit menos significativo de `B`.
  - Si ese bit es `1`, se suma `A` al resultado acumulado.
  - Luego, `A` se multiplica por 2 (`A << 1`), y `B` se divide por 2 (`B >> 1`).

---

## Ejemplo de operación

Supongamos:

```
A = 3 (binario: 0000...0011)
B = 5 (binario: 0000...0101)
```

B tiene bits en 1 en las posiciones 0 y 2. Entonces:

- Ciclo 1: `B[0] = 1` → sumar A (3) → resultado = 3
- Ciclo 2: `B[0] = 0` → no se suma
- Ciclo 3: `B[0] = 1` → sumar A × 4 = 12 → resultado final = 3 + 12 = **15**

---

## 🧾 Código fuente

```verilog
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
  output reg [7:0] LED
);

  reg [31:0] A;
  reg [31:0] B;
  reg [31:0] result;
  reg [31:0] counter;
  reg busy;
  reg start;

  assign wbusy = busy;
  assign rbusy = 0;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      A <= 0; B <= 0; result <= 0; counter <= 0; start <= 0; busy <= 0;
    end else begin
      if (wstrb) begin
        case (sel)
          2'b00: A <= wdata;
          2'b01: B <= wdata;
          2'b10: if (!busy) begin
                   result <= 0;
                   counter <= 0;
                   start <= 1;
                   busy <= 1;
                 end
        endcase
      end

      if (busy) begin
        if (counter < 32) begin
          if (B[0]) result <= result + A;
          A <= A << 1;
          B <= B >> 1;
          counter <= counter + 1;
        end else begin
          busy <= 0;
          start <= 0;
        end
      end
    end
  end

  always @(*) begin
    if (rstrb) begin
      case (sel)
        2'b00: rdata = A;
        2'b01: rdata = B;
        2'b10: rdata = busy;
        2'b11: rdata = result;
        default: rdata = 32'hDEADBEEF;
      endcase
    end else begin
      rdata = 32'b0;
    end
  end

  always @(posedge clk)
    LED <= result[7:0];

endmodule
```

---
