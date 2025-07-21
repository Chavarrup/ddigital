# Registro D de 4 bits con Enable y Output Enable

## Descripción general
Este módulo implementa un registro tipo D de 4 bits con dos controles adicionales:  
- **EN (Enable de escritura):** Permite cargar nuevos datos al registro.  
- **OE (Output Enable):** Permite habilitar o desconectar la salida (`Q`).

## Entradas
| Señal | Tamaño | Descripción |
|:-----|:-------|:------------|
| `clk` | 1 bit | Señal de reloj. Los datos se capturan en el flanco de subida. |
| `EN` | 1 bit | Habilita la escritura de datos en el registro. |
| `OE` | 1 bit | Habilita la salida de los datos almacenados. |
| `D`  | 4 bits | Datos de entrada que serán almacenados. |

## Salidas
| Señal | Tamaño | Descripción |
|:-----|:-------|:------------|
| `Q` | 4 bits | Datos de salida del registro si `OE` está activo (`1`). Si `OE` es `0`, la salida es alta impedancia (`Z`). |

## Comportamiento
- En cada flanco de subida del reloj (`posedge clk`):
  - Si `EN` es `1`, los datos de entrada `D` se almacenan en el registro interno `Q_internal`.
- La salida `Q` depende del estado de `OE`:
  - Si `OE` es `1`, `Q` muestra el valor almacenado.
  - Si `OE` es `0`, `Q` se desconecta (estado de alta impedancia `Z`).

## Código fuente

```verilog
module registro_D_4bits_OE (
    input wire clk,         // Señal de reloj
    input wire EN,          // Enable de escritura
    input wire OE,          // Output enable
    input wire [3:0] D,     // Datos de entrada
    output wire [3:0] Q     // Salida habilitada solo si OE = 1
);

    reg [3:0] Q_internal;   // Registro interno para almacenar los datos

    // Registro controlado por EN
    always @(posedge clk) begin
        if (EN)
            Q_internal <= D;
    end

    // Control de salida mediante OE
    assign Q = (OE) ? Q_internal : 4'bz;

endmodule
```

---

## Testbench

El archivo `Testbench.v` es un banco de pruebas diseñado para validar el funcionamiento del módulo `registro_D_4bits_OE`. Simula distintas combinaciones de señales para verificar:

- La carga correcta de datos en `Q_internal` cuando `EN` está activo.
- La habilitación/desconexión de la salida `Q` según el estado de `OE`.
- El estado de alta impedancia (`Z`) cuando `OE = 0`.

### ¿Qué hace este testbench?

1. **Genera un reloj de 10 ns** (`clk` cambia cada 5 ns).
2. **Inicializa las señales** `clk`, `EN`, `OE`, y `D` a 0.
3. **Aplica 5 pruebas secuenciales** para simular distintas condiciones de funcionamiento.
4. **Genera un archivo `.vcd`** para visualizar la simulación en GTKWave.
5. **Monitorea en consola** el comportamiento de `EN`, `OE`, `D`, y `Q` durante la simulación.

---
