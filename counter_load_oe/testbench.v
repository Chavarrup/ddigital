`timescale 1ns / 1ps

module tb_contador_registro_4bits;

    // Entradas
    reg clk;
    reg EN;
    reg LD;
    reg OE;
    reg [3:0] D;

    // Salida
    wire [3:0] Y;

    // Instancia del DUT (Device Under Test)
    contador_registro_4bits uut (
        .clk(clk),
        .EN(EN),
        .LD(LD),
        .OE(OE),
        .D(D),
        .Y(Y)
    );

    // Generador de reloj: 10ns de periodo
    always #5 clk = ~clk;

    initial begin
        // Inicialización
        clk = 0;
        EN  = 0;
        LD  = 0;
        OE  = 0;
        D   = 4'b0000;

        // Configuración para el dump de GTKWave
        $dumpfile("contador_registro_4bits.vcd");
        $dumpvars(0, tb_contador_registro_4bits);

        // RESET: todo en cero
        #10;

        // 1. Activar Enable y Output Enable
        EN = 1; OE = 1;

        // 2. Cargar un valor (ej: 1010)
        LD = 1; D = 4'b1010;
        #10;
        LD = 0; // Terminar carga

        // 3. Dejar contar libremente
        #40;

        // 4. Deshabilitar salida (Y = 0)
        OE = 0;
        #10;

        // 5. Habilitar salida de nuevo
        OE = 1;
        #10;

        // 6. Detener el contador
        EN = 0;
        #20;

        // 7. Cargar un nuevo valor (ej: 1100)
        EN = 1; LD = 1; D = 4'b1100;
        #10;
        LD = 0;

        // 8. Contar un poco más
        #30;

        // Finalizar simulación
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | EN=%b | LD=%b | OE=%b | D=%b | Y=%b", 
                  $time, EN, LD, OE, D, Y);
    end

endmodule
