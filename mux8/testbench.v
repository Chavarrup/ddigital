`timescale 1ns / 1ps

module tb_mux8_2ch;
  reg sel;
  reg [7:0] A;
  reg [7:0] B;
  wire [7:0] O;
  
  // Instanciar el módulo
  mux8_2ch uut (
    .sel(sel),
    .A(A),
    .B(B),
    .O(O)
  );

  // Inicialización
  initial begin
    A = 0;
    B = 0;
    sel = 0;
  end
  
  // Configuración para el dump de GTKWave
  initial begin
    $dumpfile ("mux8.vcd");
    $dumpvars(0, tb_mux8_2ch);
    #80 $finish;
  end

  // Generación de estímulos
  always #5 sel = ~sel;
  always #10 A = A + 8'd50;
  always #20 B = B + 8'd37;

endmodule
