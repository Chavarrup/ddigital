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
```

##  Detalles del Testbench

El archivo `testbench.v` es un banco de pruebas que **verifica todos los estados funcionales del contador**, incluyendo:

- Reinicio (`rst = 1`)
- Conteo con habilitación (`en = 1`)
- Pausa del conteo (`en = 0`)
- Reanudación posterior
- Reinicio y posterior reanudación

Además, se genera un archivo de simulación `.vcd` que puede abrirse en **GTKWave** para visualizar el comportamiento temporal del contador.

### ¿Qué hace este testbench?

1. Inicializa el contador en estado de reset (`rst = 1`).
2. Activa `en` para habilitar el conteo.
3. Pausa el conteo momentáneamente (`en = 0`).
4. Reinicia el contador nuevamente (`rst = 1`).
5. Reanuda el conteo desde cero.
6. Finaliza la simulación tras varias iteraciones.

---

## Utilidad del Módulo

Este contador puede ser aplicado en diversos contextos digitales:

-  **Temporizadores digitales**
-  **Divisores de frecuencia**
-  **Máquinas de estados (FSM)**
-  **Sistemas de control embebido**
-  **Sistemas de conteo de eventos o pulsos**

Es un **componente fundamental** en múltiples diseños secuenciales y sistemas digitales de propósito general.
