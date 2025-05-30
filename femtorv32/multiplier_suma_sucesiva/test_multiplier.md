# Módulo test_multiplier

## Descripción General
El módulo `test_multiplier` es un banco de pruebas (testbench) diseñado para validar el correcto funcionamiento del módulo `multiplier`. Simula la operación del multiplicador de dos operandos, genera el reloj, aplica señales de control y verifica el resultado de la multiplicación mediante la lectura de registros y visualización por LEDs.

## Características
- Genera señal de reloj con periodo de 10 ns.
- Realiza un reset inicial para poner el módulo en estado conocido.
- Escribe valores en los registros de entrada A y B.
- Inicia la multiplicación mediante un registro de control.
- Espera hasta que la operación termine.
- Lee el resultado y muestra el valor en consola junto con los LEDs.
- Utiliza señales de escritura y lectura para controlar el acceso a registros.

## Registros
| Registro | Selección (sel) | Función                           |
|----------|-----------------|---------------------------------|
| A        | 2'b00           | Primer operando de la multiplicación |
| B        | 2'b01           | Segundo operando de la multiplicación |
| Start    | 2'b10           | Registro para iniciar la multiplicación |
| Result   | 2'b11           | Registro donde se lee el resultado |

## Señales

### Entrada
| Señal  | Descripción                          |
|--------|------------------------------------|
| clk    | Reloj de sistema                   |
| rst    | Señal de reset para reiniciar módulo |
| wstrb  | Habilita escritura en registros    |
| rstrb  | Habilita lectura en registros      |
| sel    | Selector del registro (2 bits)     |
| wdata  | Datos para escribir en registros   |

### Salida
| Señal  | Descripción                        |
|--------|----------------------------------|
| rdata  | Datos leídos de los registros    |
| wbusy  | Indica que la multiplicación está en proceso (ocupado escribiendo) |
| rbusy  | Indica que está en proceso de lectura |
| LED    | Salida visual (8 bits) que muestra parte del resultado |

## Interfaz
El módulo `test_multiplier` instancia el módulo `multiplier` y conecta las señales de control y datos para realizar las pruebas. Utiliza:

- Señales de reloj y reset.
- Control de escritura y lectura mediante `wstrb`, `rstrb` y `sel`.
- Transferencia de datos con `wdata` y recepción con `rdata`.
- Señales de estado `wbusy` y `rbusy`.
- LEDs para visualización directa del resultado.

## Modo de Operación
El testbench opera de la siguiente manera:

1. Genera un reloj con ciclo de 10 ns.
2. Aplica un reset inicial para poner en cero los registros internos.
3. Escribe valores de prueba en los registros A y B.
4. Activa la señal de start para comenzar la multiplicación.
5. Espera que `wbusy` se desactive indicando que la operación terminó.
6. Activa la señal de lectura para obtener el resultado.
7. Muestra el resultado por consola y el estado de los LEDs.
8. Finaliza la simulación.

## Funcionamiento
El banco de pruebas simula la carga de los operandos en registros internos del módulo multiplicador, desencadena la operación mediante un registro de control y monitorea la señal `wbusy` para esperar la conclusión del cálculo. Luego, lee el resultado y verifica el valor impreso y los LEDs que reflejan el resultado.

Este proceso permite verificar que el módulo `multiplier` funciona correctamente en un entorno simulado.

---

## Código Fuente 

```verilog
`timescale 1ns / 1ps 

module test_multiplier;

  reg clk = 0;
  reg rst = 0;
  reg wstrb = 0;
  reg rstrb = 0;
  reg [1:0] sel;
  reg [31:0] wdata;
  wire [31:0] rdata;
  wire wbusy, rbusy;
  wire [7:0] LED;

  multiplier uut (
    .clk(clk),
    .rst(rst),
    .wstrb(wstrb),
    .rstrb(rstrb),
    .sel(sel),
    .wdata(wdata),
    .rdata(rdata),
    .wbusy(wbusy),
    .rbusy(rbusy),
    .LED(LED)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, test_multiplier);

    rst = 1; #20; rst = 0; #20;

    wstrb = 1; sel = 2'b00; wdata = 7; #10;

    sel = 2'b01; wdata = 5; #10;

    sel = 2'b10; wdata = 1; #10;
    wstrb = 0;

    wait (wbusy == 0);

    rstrb = 1;
    sel = 2'b11; #10;
    $display("[TB] Resultado leído: %d", rdata);
    $display("[TB] LEDs = %b", LED);
    rstrb = 0;

    #20;
    $finish;
  end

endmodule

