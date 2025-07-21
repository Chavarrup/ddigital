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
```
---

## Detalles del Testbench

El archivo `testbench.v` es un banco de pruebas utilizado para simular el comportamiento del sumador `hadder8bit`.

### ¿Qué hace este testbench?

- **Inicializa las entradas** `A` y `B` en cero.
- **Genera estímulos periódicos**:
  - `A` incrementa en **50** cada **10 ns**.
  - `B` incrementa en **37** cada **20 ns**.
- **Registra las señales** en un archivo `.vcd` para su visualización en **GTKWave**.
- **Finaliza la simulación automáticamente** después de **80 ns**.

### Comportamiento esperado

A medida que los valores de `A` y `B` se incrementan, se pueden observar:

- El resultado de la suma en `O`.
- El estado de `cout` cuando la suma excede 255 (desbordamiento de 8 bits).

---

## Utilidad del módulo

Este sumador es esencial en:

- **Unidades aritméticas y lógicas (ALU)** de microprocesadores.
- **Cálculo de direcciones de memoria** o **desplazamientos**.
- **Acumuladores y registros de suma**.
- **Controladores digitales** que requieren operaciones básicas de suma.

La salida `cout` permite detectar condiciones de **desbordamiento**, lo cual es útil para:

- Operaciones multibit (por ejemplo, suma de 16 o 32 bits en etapas).
- Sistemas que requieren control de errores o verificación de saturación.
