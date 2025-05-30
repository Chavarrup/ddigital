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

  always #5 clk = ~clk; // Reloj 10 ns periodo

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, test_multiplier);

    rst = 1; #20;           // Reset activo 20 ns
    rst = 0; #20;           // Reset inactivo 20 ns

    wstrb = 1;
    sel = 2'b00; wdata = 7; #10;   // Escribir A = 7

    sel = 2'b01; wdata = 5; #10;   // Escribir B = 5

    sel = 2'b10; wdata = 1; #10;   // Activar START

    wstrb = 0;
    #30;                          // Esperar a que termine

    rstrb = 1;
    sel = 2'b11; #10;              // Leer resultado

    $display("[TB] Resultado leído: %d", rdata);
    $display("[TB] LEDs = %b", LED);

    rstrb = 0;
    #20;
    $finish;
  end

endmodule
