module accreg8bit (
  input wire clk,
  input wire en,
  input wire ldacc,
  input wire [7:0] D,
  output reg [7:0] Q
);

  wire [7:0] X;
  wire [7:0] Y;

  hadder8bit sum(.A(Q), .B(D), .O(X));
  mux8_2ch mux(.sel(ldacc), .A(X), .B(D), .O(Y));

  always @(posedge clk) begin
    if (en == 1) begin
      Q <= Y;
    end
  end

endmodule