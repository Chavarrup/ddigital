.include "femtorv32.inc"

.globl main
.type main, @function

main:
    addi sp, sp, -4          # Reservar espacio en pila
    sw ra, 0(sp)             # Guardar registro de retorno

    li t0, 7                 # Cargar 7 en t0 (operando A)
    li t1, 5                 # Cargar 5 en t1 (operando B)

    # Escribir operando A en registro multiplicador
    sw t0, IO_MULT(gp)       # IO_MULT + 0, offset del operando A
    
    # Escribir operando B en registro multiplicador
    sw t1, IO_MULT+4(gp)     # IO_MULT + 4, offset del operando B

    # Iniciar multiplicación escribiendo 1 en registro START
    li t2, 1
    sw t2, IO_MULT+8(gp)     # IO_MULT + 8, offset START

wait_busy:
    lw t3, IO_MULT+8(gp)     # Leer registro START para verificar estado
    bnez t3, wait_busy       # Si START != 0, esperar (polling)

    # Leer resultado de multiplicación
    lw t5, IO_MULT+12(gp)    # IO_MULT + 12, offset RESULTADO
    # Mostrar resultado en LEDs
    sw t5, IO_LEDS(gp)

    li a0, 0                 # Código de retorno 0
    lw ra, 0(sp)             # Restaurar registro de retorno
    add sp, sp, 4            # Liberar espacio de pila
    ret                      # Retornar

