module counter_load_oe (
    input wire clk,
    input wire EN,          // Enable general
    input wire LD,          // Load paralelo
    input wire OE,          // Output enable
    input wire [3:0] D,     // Entrada de datos
    output wire [3:0] Y     // Salida habilitada
);

    reg [3:0] Q;

    // Lógica del registro/contador
    always @(posedge clk) begin
        if (EN) begin
            if (LD)
                Q <= D;         // Carga paralela
            else
                Q <= Q + 1;     // Cuenta
        end
        else begin
            Q <= Q;             // Se mantiene
        end
    end

    // Salida controlada por OE
  assign Y = (OE) ? Q : 4'bz;

endmodule