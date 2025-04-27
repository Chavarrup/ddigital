module registro_D_4bits (
    input wire clk,        // Entrada de reloj
    input wire EN,         // Señal de habilitación (Enable)
    input wire [3:0] D,    // Entrada de datos de 4 bits
    output reg [3:0] Q     // Salida de datos de 4 bits
);

// Lógica secuencial: 
// actualiza Q en flanco de subida del reloj clk
always @(posedge clk) begin
    if (EN)                // Si habilitado (EN = 1)
        Q <= D;            // Cargar el valor de D en Q
    // Si EN = 0, Q mantiene su valor anterior
end

endmodule