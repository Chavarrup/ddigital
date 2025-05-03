module mux8_2ch (
  input wire sel,        // Señal de selección
  input wire [7:0] A,    // Entrada de datos A
  input wire [7:0] B,    // Entrada de datos B
  output wire [7:0] O    // Salida de datos A o B
);

  // Lógica de salida
  assign O = sel ? B : A;

endmodule
