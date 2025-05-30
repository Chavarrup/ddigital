# Multiplicador FemtoRV32: Documentación Técnica

## Descripción General
Este conjunto de códigos implementa y prueba un periférico multiplicador para FemtoRV32 que realiza multiplicación por hardware usando un método directo (no suma sucesiva). El código ensamblador escribe los operandos, inicia la multiplicación, espera que termine y muestra el resultado en LEDs. El módulo `multiplier` realiza la multiplicación en un solo ciclo después de recibir la señal de inicio. El banco de pruebas valida este comportamiento mediante simulación.

---

## Características
- Multiplicación directa en hardware (no suma sucesiva).
- Escritura de operandos a través de registros mapeados.
- Control mediante señal `start` para iniciar la operación.
- Resultado disponible para lectura y mostrado en LEDs.
- Testbench simula todo el flujo y verifica resultado.
- Máscara de 8 bits aplicada para visualización LED en ensamblador.

---

## Registros y Señales

| Registro / Señal   | Offset / Nombre | Función                                 |
|-------------------|-----------------|----------------------------------------|
| A                 | IO_MULT + 0     | Primer operando                        |
| B                 | IO_MULT + 4     | Segundo operando                      |
| START             | IO_MULT + 8     | Señal para iniciar multiplicación    |
| RESULTADO         | IO_MULT + 12    | Resultado de la multiplicación        |
| LED               | IO_LEDS         | Visualización del resultado en LEDs   |

---

## Código Ensamblador: Flujo

1. Reserva espacio en pila y guarda `ra`.
2. Carga operandos en registros `t0`, `t1`.
3. Escribe operandos en registros de multiplicador.
4. Escribe `1` en registro `START` para iniciar multiplicación.
5. Espera (polling) hasta que `START` se autolimite a 0.
6. Lee resultado, aplica máscara 8 bits y escribe en LEDs.
7. Finaliza restaurando pila y retornando.

---

## Código Testbench: Flujo

1. Genera reloj de 10 ns periodo.
2. Aplica reset inicial.
3. Escribe operandos en registros.
4. Activa señal `start` para iniciar multiplicación.
5. Espera un tiempo fijo (30 ns) para que termine la multiplicación.
6. Lee resultado y LEDs.
7. Muestra valores en consola.
8. Finaliza simulación.

---

## Módulo Verilog `multiplier`: Funcionamiento

- Registros internos A, B, `result` y `start`.
- Al escribir `start=1` se multiplica `A*B` en el siguiente ciclo.
- Resultado se guarda en `result`.
- `start` se limpia automáticamente para indicar fin.
- Lectura multiplexada por `sel` para retornar A, B, start o resultado.
- LEDs muestran los 8 bits menos significativos del resultado.
- Señales `wbusy` y `rbusy` no utilizadas (siempre 0).

---