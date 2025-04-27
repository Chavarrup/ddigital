`timescale 1ns / 1ps

module tb_registro_D_4bits;

    // Entradas
    reg clk;
    reg EN;
    reg OE;
    reg [3:0] D;

    // Salida
    wire [3:0] Q;

    // Instancia del DUT (Device Under Test)
    registro_D_4bits_OE uut (
        .clk(clk),
        .EN(EN),
        .OE(OE),
        .D(D),
        .Q(Q)
    );

    // Reloj de 10ns
    always #5 clk = ~clk;

    initial begin
        // Archivo de ondas para OpenWave
        $dumpfile("registro_d_4bits_con_oe.vcd");
        $dumpvars(0, tb_registro_D_4bits);

        // Inicialización
        clk = 0;
        EN  = 0;
        OE  = 0;
        D   = 4'b0000;

        #10;

        // Prueba 1: Cargar D = 1010 con EN = 1 y OE = 1
        EN = 1; OE = 1; D = 4'b1010;
        #10;

        // Prueba 2: EN = 0 (no carga), D cambia, OE sigue activo
        EN = 0; D = 4'b0101;
        #10;

        // Prueba 3: EN = 1, D = 1111, OE = 0 (salida deshabilitada)
        EN = 1; OE = 0; D = 4'b1111;
        #10;

        // Prueba 4: OE = 1 (activar salida), sin cargar nada nuevo
        EN = 0; OE = 1;
        #10;

        // Prueba 5: OE = 0 (salida oculta)
        OE = 0;
        #10;

        // Finaliza simulación
        $finish;
    end

    // Monitoreo en consola
    initial begin
        $monitor("Time=%0t | EN=%b | OE=%b | D=%b | Q=%b", $time, EN, OE, D, Q);
    end

endmodule

