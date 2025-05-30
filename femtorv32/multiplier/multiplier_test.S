
.include "femtorv32.inc"

.globl main
.type main, @function

main:
    addi sp, sp, -4          # Reservar espacio en pila
    sw ra, 0(sp)             # Guardar registro de retorno

    li t0, 7                 # Cargar 7 en t0 (A)
    li t1, 5                 # Cargar 5 en t1 (B)

    sw t0, IO_MULT(gp)       # Escribir A en registro multiplicador (offset 0)
    sw t1, IO_MULT+4(gp)     # Escribir B en registro multiplicador (offset 4)

    li t2, 1
    sw t2, IO_MULT+8(gp)     # Escribir 1 en START para iniciar multiplicación (offset 8)

wait_start_done:
    lw t3, IO_MULT+8(gp)     # Leer START para verificar si sigue activa
    bnez t3, wait_start_done # Si START=1, esperar (polling)

    lw t5, IO_MULT+12(gp)    # Leer resultado (offset 12)

    li t4, 0xFF              # Máscara para 8 bits
    and t5, t5, t4           # Aplicar máscara

    sw t5, IO_LEDS(gp)       # Mostrar resultado en LEDs

    li a0, 0                 # Código retorno 0
    lw ra, 0(sp)             # Restaurar registro retorno
    add sp, sp, 4            # Liberar espacio pila
    ret                      # Retornar
