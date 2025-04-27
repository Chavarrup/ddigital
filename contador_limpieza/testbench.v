`timescale 1ns / 1ps

module tb_contador_controlado;

    // Señales de entrada
    reg clk;
    reg EN;
    reg CLR;

    // Señal de salida
    wire [3:0] Q;

    // Instancia del módulo a probar
    contador_controlado uut (
        .clk(clk),
        .EN(EN),
        .CLR(CLR),
        .Q(Q)
    );

    // Generación del reloj (10 ns por ciclo)
    always #5 clk = ~clk;

    initial begin
        // Inicialización
        clk = 0;
        EN  = 0;
        CLR = 0;

        // Dump para OpenWave
        $dumpfile("contador_controlado.vcd");
        $dumpvars(0, tb_contador_controlado);

        // Esperar un poco antes de iniciar
        #10;

        // Habilita conteo, CLR en 1 → debe reiniciar a 0
        EN = 1; CLR = 1;
        #10;

        // CLR en 0 → comienza a contar
        CLR = 0;
        #40;

        // Deshabilita EN → Q se mantiene
        EN = 0;
        #20;

        // Vuelve a habilitar EN, cuenta otros valores
        EN = 1;
        #20;

        // Limpia nuevamente
        CLR = 1;
        #10;

        // Fin de simulación
        $finish;
    end

    // Monitor en consola
    initial begin
        $monitor("Time=%0t | EN=%b | CLR=%b | Q=%b", $time, EN, CLR, Q);
    end

endmodule