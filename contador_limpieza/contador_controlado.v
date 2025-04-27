module contador_controlado (
  input wire clk,	  // Señal de reloj
  input wire EN,  // Enable de conteo (habilita la operación)
  input wire CLR,   // Limpieza del contador (cuando EN=1)
  output reg [3:0] Q  // Salida del Contador de 4 bits
);

    always @(posedge clk) begin
        if (EN) begin
            if (CLR)
        //Si CLR está activo, se limpia el contador a 0
                Q <= 4'b0000;          // Limpia
            else
        // Si CLR no está activo, incrementa el contador en 1
                Q <= Q + 1;            // Cuenta
        end
        else begin
        // Si EN está desactivado, mantiene el valor actual
            Q <= Q;                    // Mantiene valor
        end
    end

endmodule