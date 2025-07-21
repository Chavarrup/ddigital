# Módulos Integrados para el Periférico `multiplier` en FemtoRV32

Este documento describe los archivos clave que fueron modificados o creados para integrar un **periférico multiplicador personalizado** dentro del sistema `FemtoSoC` basado en la arquitectura `FemtoRV32`.

La integración permite acceder al periférico desde código ensamblador a través de instrucciones de E/S mapeadas a memoria.

---

##  Descripción de Módulos y Archivos

### 1. `femtosoc.v`

Archivo principal que define la arquitectura del SoC.  
**Cambios realizados:**

- Se instanció el módulo `multiplier`.
- Se declararon señales internas como `mult_rdata`, `mult_rbusy`, `sel`.
- Se agregó la lógica de direccionamiento para activar la escritura o lectura desde el multiplicador mediante `io_wstrb` y `io_rstrb`.
- Se añadió el resultado del multiplicador (`mult_rdata`) al bus `io_rdata`.

**Muestra de fragmento integrado:**
```verilog
assign sel = io_word_address[IO_MULT_A_bit] | io_word_address[IO_MULT_B_bit] | io_word_address[IO_MULT_RESULT_bit]; // Register selection
assign multiplier_sel = (io_addr == IO_MULT_bit);
```

### 2. `HardwareConfig.v`

Define las constantes de configuración que indican qué periféricos están presentes en el sistema.  
**Cambios realizados:**

- Se activó el bit correspondiente al periférico `MULTIPLIER` para que el software pueda consultar su presencia mediante lectura mapeada.

 **Muestra de fragmento integrado:**
```verilog
`ifdef NRV_IO_MULTIPLIER
   // registros A, B, resultado bajo y alto
   | (1 << IO_MULT_A_bit)
   | (1 << IO_MULT_B_bit)
   | (1 << IO_MULT_RESULT_bit)
   | (1 << IO_MULT_RESULT_HI_bit)
`endif
;
```

### 3. `HardwareConfig_bits.v`

Archivo Verilog que define los valores de bits para los periféricos mapeados en el sistema.

 **Muestra de fragmento integrado:**
```verilog
localparam IO_MULT_A_bit         = 12;
localparam IO_MULT_B_bit         = 13;
localparam IO_MULT_RESULT_bit    = 14;
localparam IO_MULT_RESULT_HI_bit = 15; // mitad alta del resultado
```

---

### 4. `femtosoc_bench.v`

Testbench para simular el SoC completo, incluyendo periféricos personalizados como el multiplicador.

---

### 5. `get_config` y `make_config.sh`

Scripts que generan el archivo `config.mk` según los periféricos definidos en la línea de compilación.

- Activan la definición `NRV_IO_MULTIPLIER`, usada para compilar condicionalmente el periférico dentro del SoC.

---

### 6. `multiplier.v`

Módulo Verilog que implementa el periférico multiplicador.

 **Funcionalidad principal:**

- Recibe dos operandos A y B cargados secuencialmente.
- Realiza la multiplicación en hardware.
- Entrega el resultado de 64 bits en `rdata`.
- Indica si está ocupado mediante la señal `rbusy`.

🔧 **Controlado por:**

- `rstrb`: activa lectura.
- `wstrb`: activa escritura.
- `sel`: selecciona si se escribe en A, B o si se lee el resultado.

---

### 7. `multiplier_test.S`

Archivo de ensamblador ubicado en `FIRMWARE/ASM_EXAMPLES`.

 **Propósito:**

- Carga valores en los registros del periférico multiplicador.
- Espera hasta que el bit `busy` indique que la operación ha finalizado.
- Imprime el resultado.

---

## ¿Para qué sirve esta integración?

Este sistema permite extender `FemtoRV32` con un periférico personalizado que realiza multiplicaciones en hardware, lo que:

-  Aumenta el rendimiento de operaciones aritméticas intensivas.
-  Permite simular periféricos personalizados en una arquitectura RISC-V educativa.
-  Sirve como base para integrar aceleradores, coprocesadores o controladores de hardware.



## Resultado Final

El periférico `multiplier` puede ser accedido desde programas en ensamblador o C utilizando su dirección mapeada.

La arquitectura sigue el esquema mínimo y portable del `FemtoSoC`, siendo ideal para prácticas en sistemas embebidos y cursos de arquitectura computacional.


##  Autora

Este trabajo fue desarrollado por **Lina M. Chavarro** como parte de un proyecto educativo para simular periféricos personalizados con `RISC-V` y herramientas de código abierto como **Icarus Verilog**, **Verilator** y **GTKWave**.
