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
```

## Testbench

El archivo `tb_registro_D_4bits.v` es un **banco de pruebas** diseñado para validar el comportamiento del módulo `registro_D_4bits`. Su función es simular diferentes combinaciones de señales de entrada (`clk`, `EN`, `D`) y observar la salida `Q` para comprobar si el módulo se comporta como se espera.

### ¿Qué hace este testbench?

1. **Genera la señal de reloj (`clk`)**:  
   Se utiliza un `always` que cambia `clk` cada 5 ns, generando un reloj con periodo de 10 ns.

2. **Inicializa señales**:  
   Al comienzo de la simulación, `clk`, `EN` y `D` se inicializan en 0.

3. **Ejecuta pruebas específicas**:  
   Se aplican distintas combinaciones de `EN` y `D` para comprobar si el módulo captura o mantiene datos correctamente en función del estado de `EN`.

4. **Registra señales para análisis en GTKWave**:  
   Mediante `$dumpfile` y `$dumpvars` se genera un archivo `.vcd` que permite observar el comportamiento del módulo visualmente.

5. **Monitorea por consola**:  
   Con `$monitor`, se imprime el valor de `EN`, `D` y `Q` en cada instante relevante de la simulación.

---

## Utilidad del módulo

Este tipo de registro es útil en diversos sistemas digitales para:

- **Almacenamiento temporal de datos**
- **Etapas intermedias en datapaths**
- **Sistemas secuenciales**
- **Buffers controlados por habilitación**

Su simplicidad lo convierte en una unidad fundamental en el diseño de procesadores, controladores, periféricos y más.
