# Sumador de 8 bits

## Descripción General
Este módulo implementa un **sumador de 8 bits** que realiza la suma de dos entradas (`A` y `B`).  
El resultado se entrega en una salida de 8 bits (`O`), y también se genera un bit de acarreo (`cout`) si la suma excede el rango de 8 bits.

## Entradas
| Señal | Ancho | Descripción |
|:------|:-----:|:------------|
| A     | 8 bits | Primer operando de la suma. |
| B     | 8 bits | Segundo operando de la suma. |

## Salidas
| Señal | Ancho | Descripción |
|:------|:-----:|:------------|
| O     | 8 bits | Resultado de la suma de `A` + `B` (sin el bit de acarreo). |
| cout  | 1 bit  | Bit de acarreo de la suma (indica desbordamiento). |

## Comportamiento
- El módulo realiza la operación `O = A + B`.
- Si la suma de `A` y `B` excede 8 bits, `cout` se pone en `1`.
- Si la suma está dentro del rango de 8 bits, `cout` permanece en `0`.

---

# Código Fuente

### Módulo: `hadder8bit.v`
```verilog
module hadder8bit (
  input wire [7:0] A,
  input wire [7:0] B,    // Entrada de datos B
  output wire [7:0] O,
  output wire cout       // Bit de acarreo
);

  // Lógica de suma
  assign {cout, O} = A + B;

endmodule
