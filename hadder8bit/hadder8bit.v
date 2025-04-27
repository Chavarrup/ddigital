module hadder8bit (
  input wire [7:0] A,
  input wire [7:0] B,    // Entrada de datos B
  output wire [7:0] O
  output wire cout);
  
  assign {cout, 0} = A + B;
);

  // Lógica de salida
  assign O = sel ? B : A;

endmodule
