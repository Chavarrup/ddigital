# Contador Controlado de 4 bits

## Descripción General
Este módulo implementa un contador de 4 bits que puede ser habilitado o deshabilitado mediante una señal `EN`.  
Además, cuando está habilitado, puede ser limpiado (reseteado a cero) mediante la señal `CLR`.  
El conteo ocurre en flancos positivos del reloj (`clk`).

## Entradas
| Señal | Ancho | Descripción |
|:-----|:-----:|:------------|
| clk  |  1 bit | Señal de reloj. El contador actualiza su estado en el flanco positivo. |
| EN   |  1 bit | Habilita o deshabilita el conteo. Si está en `0`, el contador mantiene su valor actual. |
| CLR  |  1 bit | Si está en `1` y `EN` es `1`, limpia el contador a `0000`. |

## Salidas
| Señal | Ancho | Descripción |
|:-----|:-----:|:------------|
| Q    | 4 bits | Valor actual del contador. |

## Comportamiento
- En cada flanco positivo del reloj:
  - Si `EN = 1`:
    - Si `CLR = 1`, el contador se limpia a `0`.
    - Si `CLR = 0`, el contador incrementa su valor en 1.
  - Si `EN = 0`, el contador mantiene su valor actual, sin importar `CLR`.
  
---

# Código Fuente

### Módulo: `contador_controlado.v`
```verilog
module contador_controlado (
    input wire clk,       // Señal de reloj
    input wire EN,        // Enable de conteo (habilita la operación)
    input wire CLR,       // Limpieza del contador (activo cuando EN = 1)
    output reg [3:0] Q    // Salida del contador de 4 bits
);

    always @(posedge clk) begin
        if (EN) begin
            if (CLR)
                Q <= 4'b0000;          // Si CLR está activo, se limpia el contador a 0
            else
                Q <= Q + 1;            // Si CLR no está activo, incrementa el contador en 1
        end
        else begin
            Q <= Q;                    // Si EN está desactivado, mantiene el valor actual
        end
    end

endmodule
