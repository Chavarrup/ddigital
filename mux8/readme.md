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
