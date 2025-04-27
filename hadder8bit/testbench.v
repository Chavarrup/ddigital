`timescale 1ns / 1ps

module hadder8bit_tb ();
  reg [7:0] A;
  reg [7:0] B;
  wire [7:0] O;
  
  //Initialization.
  initial begin
    A = 0;
    B = 0;
  end
  
  //Simulation config.
  initial begin
    $dumpfile("hadder8.vcd");
    $dumpvars;
    #80 $finish;
  end
  
  // Unit under testing.
  hadder8bit uut (.A(A), .B(B), .O(O));
  
  // Stimuli generation.
  always #10 A = A + 50;
  always #20 B = B + 37;
endmodule
