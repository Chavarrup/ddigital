# counter_4bit_with_load

## Descripción General
Este módulo implementa un contador binario de 4 bits con funcionalidad adicional de carga paralela mediante la señal `load` y la entrada `d`.  
Es una extensión del contador clásico sin carga, que se observa en la sección anterior.

---

## Entradas

- **`clk`** (1 bit): Señal de reloj. El contador se actualiza en el flanco positivo.
- **`rst`** (1 bit): Reset asíncrono. Si está activo (`1`), reinicia el contador. Máxima prioridad.
- **`en`** (1 bit): Habilita el conteo cuando `load` está inactivo.
- **`load`** (1 bit): Si está activo (`1`), se carga el valor de `d` en `q`.
- **`d`** (4 bits): Valor de entrada a cargar en `q` cuando `load = 1`.

---

## Salida

- **`q`** (4 bits): Valor actual del contador o valor cargado desde `d`.

---

## Comportamiento

- Si `rst = 1`: el contador se reinicia a `0000` (asíncrono).
- Si `load = 1` y `rst = 0`: se carga el valor de `d` en `q`.
- Si `load = 0` y `en = 1`: se incrementa el valor de `q`.
- Si `load = 0` y `en = 0`: el valor de `q` se mantiene constante.

---

## Código Fuente

```verilog
module counter_4bit_with_load (
  input clk,              // Señal de reloj
  input rst,              // Reset asíncrono
  input en,               // Habilitación del contador
  input load,             // Carga paralela
  input [3:0] d,          // Valor paralelo a cargar si load=1
  output reg [3:0] q      // Salida del contador
);

// Proceso secuencial: flanco de subida del clk o reset
  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 4'b0000;              // Reinicia contador
    else if (load)
      q <= d;                    // Carga valor de d en q
    else if (en)
      q <= q + 1;                // Incrementa si está habilitado
    // Si load = 0 y en = 0, mantiene valor
  end

endmodule
```

## Detalles del Testbench

El archivo `testbench.v` simula diferentes escenarios para validar el comportamiento completo del módulo `counter_4bit_with_load`.

### ¿Qué hace este testbench?

- Inicializa todas las señales (`clk`, `rst`, `en`, `load`, `d`).
- Aplica un **reset asíncrono** al inicio.
- Activa el conteo (`en = 1`) y observa el incremento de `q`.
- Usa la señal `load` para cargar valores específicos (`5` y `12`).
- Pausa el contador (`en = 0`) para verificar que `q` se mantiene constante.
- Guarda el comportamiento en un archivo `.vcd` para visualización con **GTKWave**.
- Incluye mensajes `$display` para seguimiento en consola.

### Comportamiento esperado

| Tiempo | rst | en | load | d     | Acción                             | q esperada |
|--------|-----|----|------|-------|------------------------------------|------------|
| 0 ns   | 1   | 0  | 0    | 0000  | Reset                              | 0000       |
| 10 ns  | 0   | 1  | 0    | xxxx  | Comienza conteo                    | 0001 → ... |
| 30 ns  | 0   | 0  | 1    | 0101  | Carga valor 5                      | 0101       |
| 40 ns  | 0   | 1  | 0    | xxxx  | Sigue contando desde 5             | 0110 → ... |
| 80 ns  | 0   | 0  | 0    | xxxx  | Pausa el contador                  | constante  |
| 90 ns  | 0   | 0  | 1    | 1100  | Carga valor 12                     | 1100       |
| 100 ns | 0   | 1  | 0    | xxxx  | Conteo desde 12                    | 1101 → ... |

---

## Utilidad del Módulo

El módulo `counter_4bit_with_load` es versátil y adecuado para múltiples aplicaciones:

- **Contadores programables** en sistemas digitales.
- **Temporizadores ajustables** por software o señales externas.
- **Módulos de control** donde es necesario iniciar desde un estado definido.
- **Sistemas embebidos** con reinicio externo o arranque desde valores predeterminados.
- **Diseños secuenciales**, como controladores de estado finito (FSM), que requieren control preciso del conteo.

Este tipo de módulo combina eficiencia con flexibilidad, permitiendo tanto operación automática como control manual del valor interno del contador.
