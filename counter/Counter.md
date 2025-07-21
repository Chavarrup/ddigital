# counter_4bit

## Descripción General
Este módulo implementa un contador binario de 4 bits con habilitación (`en`) y reinicio asíncrono (`rst`).  
El contador incrementa su valor en cada flanco de subida de la señal de reloj (`clk`) si está habilitado.  
Si la señal de `rst` está activa, el contador se reinicia a cero inmediatamente, sin importar el reloj.

Es un diseño simple pero esencial en sistemas digitales secuenciales.

---

## Entradas

| Señal | Tamaño | Descripción |
|-------|--------|-------------|
| `clk` | 1 bit  | Señal de reloj. Dispara el conteo en flanco positivo. |
| `rst` | 1 bit  | Reset asíncrono. Reinicia el contador a 0 al activarse. |
| `en`  | 1 bit  | Habilita el conteo. Si está en 0, `q` se mantiene. |

---

## Salida

| Señal | Tamaño | Descripción |
|-------|--------|-------------|
| `q`   | 4 bits | Valor actual del contador. Se incrementa si `en=1` y `rst=0`. |

---

## Comportamiento

- Si `rst = 1`: el contador se reinicia a `0000` (asíncrono).
- Si `rst = 0` y `en = 1`: se incrementa el valor de `q` en cada flanco de subida de `clk`.
- Si `rst = 0` y `en = 0`: el valor de `q` se mantiene constante.

---

## Código Fuente

```verilog
module counter_4bit (
  input clk,              // Señal de reloj
  input rst,              // Reset asíncrono
  input en,               // Habilitación del contador
  output reg [3:0] q      // Salida del contador
);

  // Proceso secuencial: flanco de subida del clk o reset
  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 4'b0000;              // Reinicia contador
    else if (en)
      q <= q + 1;                // Incrementa si está habilitado
    // Si en = 0, mantiene valor
  end

endmodule
```

## Detalles del Testbench

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
