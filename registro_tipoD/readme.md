# Registro Tipo D de 4 Bits

## Descripción General
Este proyecto implementa un **registro tipo D** de 4 bits en Verilog. El registro captura el valor de entrada `D` en el flanco positivo del reloj (`clk`) y lo almacena en la salida `Q`, **únicamente si** la señal de habilitación (`EN`) está activa.

---

## Entradas
| Señal | Tamaño | Descripción |
|:-----:|:------:|:-----------:|
| `clk` | 1 bit  | Señal de reloj. El registro actualiza `Q` en el flanco positivo. |
| `EN`  | 1 bit  | Señal de habilitación. Si es 1, `Q` captura el valor de `D`. |
| `D`   | 4 bits | Datos a cargar en el registro. |

---

## Salidas
| Señal | Tamaño | Descripción |
|:-----:|:------:|:-----------:|
| `Q`   | 4 bits | Salida del registro. Contiene los datos almacenados. |

---

## Comportamiento
- En cada **flanco positivo del reloj**:
  - Si `EN = 1`, el registro **captura** el valor de `D` y lo guarda en `Q`.
  - Si `EN = 0`, el registro **mantiene** su valor anterior en `Q`, sin cambios.
- Si el reloj no cambia, el contenido de `Q` permanece estable.

### Tabla de funcionamiento:

| clk (flanco) | EN  | D    | Q (nuevo) |
|:------------:|:---:|:----:|:---------:|
| ↑            | 1   | 1010 | 1010      |
| ↑            | 0   | 0101 | Sin cambio|
| ↑            | 1   | 1111 | 1111      |
| ↑            | 0   | 0000 | Sin cambio|

---

## Código Fuente

### Módulo `registro_D_4bits`
```verilog
module registro_D_4bits (
    input wire clk,        // Señal de reloj
    input wire EN,         // Señal de habilitación
    input wire [3:0] D,    // Entrada de datos
    output reg [3:0] Q     // Salida de datos
);

// Al flanco positivo de reloj, actualiza Q si EN está activo
always @(posedge clk) begin
    if (EN)
        Q <= D;
end

endmodule
