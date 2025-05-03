module hadder8bit (
  input wire [7:0] A,
  input wire [7:0] B,
  output wire [7:0] O,
  output wire cout
);

  // Suma de 8 bits
  assign {cout, O} = A + B;

endmodule
