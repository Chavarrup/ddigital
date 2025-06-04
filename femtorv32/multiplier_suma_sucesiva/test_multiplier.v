`timescale 1ns / 1ps

module test_multiplier;

  // Señales de entrada
  reg clk = 0;           // Reloj inicializado en 0
  reg rst = 0;           // Reset inicializado en 0
  reg wstrb = 0;         // Write strobe para habilitar escritura
  reg rstrb = 0;         // Read strobe para habilitar lectura
  reg [1:0] sel;         // Selector de registro
  reg [31:0] wdata;      // Dato para escritura

  // Señales de salida
  wire [31:0] rdata;     // Dato leído
  wire wbusy, rbusy;     // Indicadores de busy para escritura y lectura
  wire [7:0] LED;        // LEDs que muestran parte del resultado

  // Instancia del módulo multiplicador
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

  // Generador de reloj: alterna clk cada 5 ns (periodo 10 ns)
  always #5 clk = ~clk;

  initial begin
    // Archivo para volcado de la simulación (VCD)
    $dumpfile("wave.vcd");
    $dumpvars(0, test_multiplier);

    // Aplicar reset por 20 ns
    // Reset
    rst = 1; #20; rst = 0; #20;

    // Escribir valor 7 en registro A (sel=00)
    // A = 7
    wstrb = 1; sel = 2'b00; wdata = 7; #10;

    // Escribir valor 5 en registro B (sel=01)
    // B = 5
    sel = 2'b01; wdata = 5; #10;

    // Iniciar multiplicación escribiendo 1 en registro start (sel=10)
    // Start multiplicación con A = 7 y B = 5
    sel = 2'b10; wdata = 1; #10;
    wstrb = 0;   // Deshabilitar escritura

    // Esperar hasta que termine
    wait (wbusy == 0);  // Espera a que termine multiplicación

    // Leer resultado
    rstrb = 1;  // Habilitar lectura
    sel = 2'b11; #10;
    $display("[TB] Resultado leído: %d", rdata);  // Mostrar el resultado
    $display("[TB] LEDs = %b", LED);               // Mostrar los LEDs que contienen parte del resultado
    rstrb = 0;  // Deshabilitar lectura

    #20;
    $finish;  // Finalizar simulación
  end

endmodule
