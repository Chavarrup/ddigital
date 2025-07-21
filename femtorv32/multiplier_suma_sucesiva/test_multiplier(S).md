# Programa Ensamblador para Multiplicador FemtoRV32

## Descripción General
Este programa en lenguaje ensamblador RISC-V utiliza el periférico multiplicador integrado en FemtoRV32 para multiplicar dos números enteros. El programa escribe los operandos en los registros del periférico, inicia la operación, espera a que la multiplicación termine, luego lee el resultado y lo muestra en los LEDs.

## Características
- Carga dos valores enteros en registros temporales.
- Escribe los operandos en las direcciones de memoria mapeadas para el multiplicador.
- Activa la señal de inicio para comenzar la multiplicación.
- Espera el fin del proceso mediante polling de la señal `START`.
- Lee el resultado del multiplicador.
- Muestra el resultado a través de LEDs mapeados en memoria.
- Finaliza la ejecución limpiamente restaurando el stack pointer y el registro de retorno.

## Registros Utilizados
| Registro | Uso                       |
|----------|---------------------------|
| sp       | Stack pointer             |
| ra       | Return address            |
| t0       | Primer operando    |
| t1       | Segundo operando   |
| t2       | Valor para iniciar la multiplicación (START = 1) |
| t3       | Valor leído para polling (estado START)           |
| t5       | Resultado leído del multiplicador                  |
| a0       | Código de retorno (0)                              |

## Direcciones de memoria (offsets)
| Dirección                  | Función                   |
|----------------------------|---------------------------|
| `IO_MULT + 0`              | Registro A (operando 1)   |
| `IO_MULT + 4`              | Registro B (operando 2)   |
| `IO_MULT + 8`              | Registro START (control)  |
| `IO_MULT + 12`             | Registro RESULTADO        |
| `IO_LEDS`                  | LEDs para mostrar resultado|

## Flujo de Operación
1. Reserva espacio en la pila y guarda el registro de retorno.
2. Carga los valores en registros temporales `t0` y `t1`.
3. Escribe ambos valores en los registros de entrada del periférico multiplicador.
4. Escribe el valor `1` en el registro `START` para iniciar la multiplicación.
5. Entra en un ciclo de espera (`polling`) verificando el registro `START` hasta que sea cero, indicando que la multiplicación terminó.
6. Lee el resultado del registro de resultado del multiplicador.
7. Escribe el resultado en la dirección de los LEDs para mostrarlo.
8. Limpia la pila, restaura el registro `ra` y retorna con código 0.

---

## test_multiplier.S
```asm
.include "femtorv32.inc"

.globl main
.type main, @function

main:
    addi sp, sp, -4
    sw ra, 0(sp)

    li t0, 7               # A = 7
    li t1, 5               # B = 5

    # Escribir A y B
    sw t0, IO_MULT(gp)         # offset 0 (A)
    sw t1, IO_MULT+4(gp)       # offset 1 (B)

    # START = 1
    li t2, 1
    sw t2, IO_MULT+8(gp)       # offset 2 (START)

wait_busy:
    lw t3, IO_MULT+8(gp)
    bnez t3, wait_busy

    # Leer el resultado
    lw t5, IO_MULT+12(gp)
    sw t5, IO_LEDS(gp)

    li a0, 0
    lw ra, 0(sp)
    add sp, sp, 4
    ret