# Periférico Multiplicador en FemtoSoC

## 1. Instanciación del periférico y conexión a la memoria IO

En FemtoSoC, para integrar el periférico multiplicador se comienza instanciando el módulo con sus entradas y salidas correspondientes dentro del sistema, condicionado a que esté habilitado con la directiva `NRV_IO_MULT`.

Primero, se define un wire para recoger los datos leídos desde el periférico. Luego, se instancia el periférico multiplicador, conectando señales de reloj, reinicio (activo bajo), señales de escritura y lectura, selección del registro interno (2 bits que permiten 4 registros: A, B, START, RESULT), datos de entrada que llegan desde el procesador, y datos de salida que devuelve el periférico. Se incluyen señales de busy de lectura y escritura, aunque no se usan en este caso.

Se utiliza la señal `io_word_address[IO_MULTIPLIER_bit]` para seleccionar el periférico desde el bus IO utilizando direccionamiento 1-hot. 
Además, `sel(io_word_address[1:0])` selecciona el registro interno dentro del periférico.

```verilog
ifdef NRV_IO_MULT

// 1. Wire para recoger datos leídos desde el periférico
wire [31:0] mult_rdata;

// 2. Instancia del periférico multiplicador
multiplier multiplier_inst (
    .clk(clk),
    .rst(!reset),                         
    .wstrb(io_wstrb),                       
    .rstrb(io_rstrb),                    
    .sel(io_word_address[1:0]),            
    .wdata(io_wdata),                     
    .rdata(mult_rdata),                     
    .wbusy(),                                
    .rbusy()                                
);

endif
```

En la asignación del bus de lectura global `io_rdata`, se agrega la salida del periférico multiplicador para que el procesador pueda leer el resultado de la multiplicación.

```verilog
`ifdef NRV_IO_MULT
       | mult_rdata
`endif
```

## 2. Configuración en HARDWARECONFIGBITS

En el archivo `HARDWARECONFIGBITS` se asigna la dirección al nuevo periférico usando direccionamiento 1-hot, lo que facilita la decodificación sin necesidad de lógica compleja. 
Se define un parámetro local que indica el bit correspondiente al periférico multiplicador personalizado (por ejemplo, el bit 12).

```verilog
localparam IO_MULT_bit = 12;  // RW - Periférico multiplicador personalizado
```

Esto asegura que los archivos `femtosoc.v` y `HardwareConfig.v` puedan referenciar al mismo periférico de manera consistente.

## 3. Declaración en HARDWARECONFIG

En `HARDWARECONFIG` se declara el periférico como presente en el sistema dentro del conjunto `nrv_Devices`. De esta manera, el software que corre en el procesador podrá detectar si el periférico está habilitado.

```verilog
`ifdef NRV_IO_MULT
   | (1 << IO_MULT_bit)
`endif
```

## 4. Habilitación en femtoSOC_CONFIG
Finalmente, en la configuración principal de FemtoSoC (`femtoSOC_CONFIG`) se habilita el periférico multiplicador definiendo la directiva correspondiente (`NRV_IO_MULT`).

```verilog
`define NRV_IO_MULT
```


##  Resumen
Esta configuración y conexión permite compilar en conjunto el periférico multiplicador con FemtoSoC, integrando el módulo, conectándolo al bus IO con direccionamiento 1-hot, asignando su dirección en hardware y habilitando su detección desde el software. Así, el procesador puede leer y escribir los registros internos del periférico y obtener el resultado de las multiplicaciones a través del bus IO.

---
