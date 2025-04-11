// Testbench para counter_4bit_with_load
module test;

  reg clk;
  reg rst;
  reg en;
  reg load;
  reg [3:0] d;
  wire [3:0] q;

  // Instanciar el diseño bajo prueba
  counter_4bit_with_load CNT(.clk(clk), .rst(rst), .en(en), .load(load), .d(d), .q(q));

  // Generar reloj
  always #5 clk = ~clk;

  initial begin
    // Inicialización
    clk = 0;
    rst = 1;
    en = 0;
    load = 0;
    d = 4'b0000;

    // Generar archivo VCD
    $dumpfile("dump.vcd");
    $dumpvars(1);

    $display("Reset contador.");
    display;

    #10 rst = 0; en = 1;
    $display("Habilitar contador.");
    display;

    #20 en = 0; load = 1; d = 4'b0101;
    $display("Cargar valor 5.");
    display;

    #10 load = 0; en = 1;
    $display("Seguir contando desde 5.");
    display;

    #40 en = 0;
    $display("Pausar contador.");
    display;

    #10 load = 1; d = 4'b1100;
    $display("Cargar valor 12.");
    display;

    #10 load = 0; en = 1;
    $display("Contar desde 12.");
    display;

    #50 $finish;
  end

  // Mostrar valores
  task display;
    #1 $display("en:%0h load:%0h d:%0d -> q:%0d", en, load, d, q);
  endtask

endmodule
