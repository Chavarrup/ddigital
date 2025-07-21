# Contador/Registro Controlado de 4 bits

## Descripción General
Este módulo implementa un **contador de 4 bits** que también puede **cargar un valor paralelo** proveniente de una entrada `D`.  
El contador puede ser habilitado o detenido mediante una señal `EN`, y su salida puede ser habilitada o puesta en **alta impedancia** (`Z`) mediante `OE`.  
El conteo y la carga ocurren en flancos positivos del reloj (`clk`).

## Entradas
| Señal | Ancho | Descripción |
|:------|:-----:|:------------|
| clk   | 1 bit | Señal de reloj. El contador o registro se actualiza en el flanco positivo. |
| EN    | 1 bit | Habilita la operación (contar o cargar). Si está en `0`, mantiene su valor actual. |
| LD    | 1 bit | Permite cargar el valor de `D` al contador cuando está en `1`. |
| OE    | 1 bit | Habilita la salida de datos. Si está en `0`, la salida queda en alta impedancia (`Z`). |
| D     | 4 bits | Datos de entrada para carga paralela en el contador. |

## Salidas
| Señal | Ancho | Descripción |
|:------|:-----:|:------------|
| Y     | 4 bits | Valor de salida controlado por `OE`. Refleja el contenido del contador o queda en alta impedancia. |

## Comportamiento
- En cada flanco positivo del reloj:
  - Si `EN = 1`:
    - Si `LD = 1`, el contador carga el valor de `D`.
    - Si `LD = 0`, el contador incrementa su valor en 1.
  - Si `EN = 0`, el contador mantiene su valor actual.
- La salida `Y` depende de `OE`:
  - Si `OE = 1`, `Y` muestra el valor interno del contador.
  - Si `OE = 0`, `Y` se pone en alta impedancia (`Z`).

---

# Código Fuente

### Módulo: `contador_registro_4bits.v`
```verilog
module contador_registro_4bits (
    input wire clk,
    input wire EN,          // Enable general
    input wire LD,          // Load paralelo
    input wire OE,          // Output enable
    input wire [3:0] D,     // Entrada de datos
    output wire [3:0] Y     // Salida habilitada
);

    reg [3:0] Q;

    // Lógica del registro/contador
    always @(posedge clk) begin
        if (EN) begin
            if (LD)
                Q <= D;         // Carga paralela
            else
                Q <= Q + 1;     // Cuenta
        end
        else begin
            Q <= Q;             // Se mantiene
        end
    end

    // Salida controlada por OE (alta impedancia cuando OE = 0)
    assign Y = (OE) ? Q : 4'bz;

endmodule
```

## Testbench

El archivo `testbench.v` es un banco de pruebas que simula distintas combinaciones de señales para verificar el funcionamiento completo del contador con carga, habilitación y salida triestado.

### ¿Qué hace este testbench?

- Inicializa señales en cero (`clk`, `EN`, `LD`, `OE`, `D`).
- Activa `EN` y `OE` para permitir contar y observar la salida.
- Carga valores específicos en el contador (`1010`, luego `1100`) usando `LD`.
- Deshabilita la salida temporalmente (`OE = 0`) para comprobar el estado de alta impedancia.
- Detiene el conteo (`EN = 0`) y verifica que el valor se mantenga.
- Registra las señales en un archivo `.vcd` para visualización en **GTKWave**.

### Comportamiento esperado

| Etapa | EN | LD | OE | D     | Acción esperada                        |
|:-----:|:--:|:--:|:--:|:-----:|:--------------------------------------:|
| 1     | 1  | 1  | 1  | 1010  | Carga el valor `1010`                  |
| 2     | 1  | 0  | 1  | ---   | Comienza el conteo (`1011`, `1100`,…) |
| 3     | 1  | 0  | 0  | ---   | Salida `Y` en alta impedancia (`Z`)   |
| 4     | 1  | 0  | 1  | ---   | `Y` vuelve a mostrar el valor contado |
| 5     | 0  | -  | 1  | ---   | Contador se detiene, valor se mantiene |
| 6     | 1  | 1  | 1  | 1100  | Carga nuevo valor y continúa el conteo |

---

## Utilidad del módulo

Este tipo de módulo es útil en múltiples contextos:

- **Contadores programables** para temporización, PWM o división de frecuencia.
- **Registros configurables** que pueden iniciar desde un valor arbitrario.
- **Sistemas con buses compartidos**, gracias a su salida en alta impedancia.
- **Unidades de control** que requieren contar ciclos y activar otras señales de forma secuencial.

