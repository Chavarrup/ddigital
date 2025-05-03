`timescale 1ns/1ps

module accreg8bit_tb;
  reg [7:0] D;
  reg ldacc, en, clk;
  wire [7:0] Q;

  // Initialization
  initial begin
    D = 0;
    ldacc = 0;
    en = 0;
    clk = 0;
  end

  // Simulation config
  initial begin
    $dumpfile("accreg8.vcd");
    $dumpvars;
    #200 $finish;
  end

  // Unit under test
  accreg8bit uut (.D(D), .clk(clk), .en(en), .ldacc(ldacc), .Q(Q));

  // Clock generation
  always #5 clk = ~clk;

  // Stimuli generation
  initial begin
    #10;
    en = 1;
    ldacc = 1;
    D = 8'd1;
    #20;
    ldacc = 0;
  end    
endmodule