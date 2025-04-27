module registro_D_4bits_OE (
    input wire clk,     // Señal de reloj
    input wire EN,      // Enable de escritura
    input wire OE,      // Output enable
    input wire [3:0] D, // Datos de entrada (4 bits)
    output wire [3:0] Q // Salida habilitada solo si OE = 1
    //Si OE=0 es alta impedancia
);

    // Registro interno para almacenar los datos
    reg [3:0] Q_internal;

    // Registro con habilitador de carga (EN)
    // En cada flanco positivo de clk, si EN está activo, se carga el valor de D en Q_internal
    always @(posedge clk) begin
        if (EN)
            Q_internal <= D;
    end

    // Habilitador de salida (OE)
    // Si OE está activo, Q refleja el valor almacenado en Q_internal.
    // Si OE está inactivo, Q se pone en alta impedancia (4'bz).
    assign Q = (OE) ? Q_internal : 4'bz;

endmodule

