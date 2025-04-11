// Testbench, pruebas
module test;

  reg clk;
  reg rst;
  reg en;
  wire [3:0] q;

  // Instanciar el diseño bajo prueba
  counter_4bit CNT(.clk(clk), .rst(rst), .en(en), .q(q));
//nombre del modulo, abreviatura (nombre de la intancia), asociación de puertos

  // Generar reloj
  always #5 clk = ~clk;

  initial begin
    // Dump de la simulación
    $dumpfile("dump.vcd"); //genera un archivo vcd
    $dumpvars(1);

    $display("Reset contador."); //imprime en consola
    //valores iniciales
    clk = 0;
    rst = 1;
    en = 0;
    display;

    #1 rst = 0; en = 1;
    $display("Habilitar contador.");
    display;
    //Se espera 10 unidades de tiempo, Se desactiva el reset, el contador puede funcionar, pues se activa enable

    #100 en = 0;
    $display("Pausar contador.");
    display;
//Se espera 50 unidades de tiempo con en en 1, Se desactiva el enable, el contador se detiene, aunque la señal de reloj sigue
    
    #10 en = 1;
    $display("Continuar contador.");
    display;
//Se espera 20 unidades de tiempo con el contador pausado, con en=1 se reanuda el contador
    
    #30 rst = 1;
    $display("Reset nuevamente.");
    display;
//Se esperan 30 unidades de contador activo, se activa el reset, se reinicia el contador
    
    #10 rst = 0; en = 1;
    $display("Reanudar conteo.");
    display;
//Se espera 10 unidades de tiempo con el contador en reset, se desactiva el reset y se activa el enable, vuelve a contar desde cero

    #50 $finish;
//Se espera 50 unidades de tiempo mientras el contador sigue activo
  end

//muestra el valor actual de en y q
  task display;
    #10 $display("en:%0h, q:%d", en, q);
  endtask

endmodule
