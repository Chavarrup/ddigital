# Multiplexor 8 bits, 2 canales

## Descripción General
Este módulo implementa un **multiplexor de 8 bits** con **2 canales** de entrada (`A` y `B`).  
La selección de cuál entrada pasa a la salida se realiza mediante la señal `sel`.  
Dependiendo del valor de `sel`, la salida `O` será igual a `A` o a `B`.

## Entradas
| Señal | Ancho | Descripción |
|:------|:-----:|:------------|
| sel   | 1 bit | Señal de selección. Decide qué entrada se conecta a la salida. |
| A     | 8 bits | Entrada de datos A. |
| B     | 8 bits | Entrada de datos B. |

## Salidas
| Señal | Ancho | Descripción |
|:------|:-----:|:------------|
| O     | 8 bits | Salida de datos seleccionada (A o B). |

## Comportamiento
- Si `sel = 0`, la salida `O` toma el valor de la entrada `A`.
- Si `sel = 1`, la salida `O` toma el valor de la entrada `B`.

---

# Código Fuente

### Módulo: `mux8_2ch.v`
```verilog
module mux8_2ch (
  input wire sel,
  input wire [7:0] A,    // Entrada de datos
  input wire [7:0] B,    
  output wire [7:0] O    // Salida habilitada
);

  // Lógica de salida
  assign O = sel ? B : A;

endmodule
```

## Detalles del Testbench

El archivo `testbench.v` es un banco de pruebas diseñado para simular el comportamiento del multiplexor `mux8_2ch`.

### ¿Qué hace este testbench?

- **Inicializa las señales** `sel`, `A` y `B`.
- **Genera una secuencia automática**:
  - `sel` cambia cada **5 ns** (alternancia entre A y B).
  - `A` incrementa cada **10 ns**.
  - `B` incrementa cada **20 ns**.
- **Crea un archivo `.vcd`** para inspección de señales en **GTKWave**.
- **Finaliza la simulación automáticamente** después de **80 ns**.

Este patrón de estímulos permite verificar que el multiplexor responde correctamente al cambio de `sel` y que enruta la entrada adecuada hacia la salida `O`.

---

## Utilidad del módulo

Este multiplexor es útil en:

- **Selección condicional de rutas de datos**
- **Sistemas de control donde se alterna entre dos fuentes**
- **Diseños de microprocesadores para seleccionar operandos**
- **Control de flujos de entrada/salida**

Debido a su simplicidad y eficiencia, este módulo es ideal para integrarse en **datapaths**, **ALUs** y **controladores de buses**.
