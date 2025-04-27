`timescale 1ns / 1ps  
// Define la unidad de tiempo y la precisión de la simulación

module tb_registro_D_4bits;

    // Entradas
    reg clk;              // Señal de reloj
    reg EN;               // Señal de habilitación
    reg [3:0] D;          // Entrada de datos
    // Salida
    wire [3:0] Q;         // Salida de datos

    // Instancia del módulo
    // (Unit Under Test - UUT)
    registro_D_4bits uut (
        .clk(clk),
        .EN(EN),
        .D(D),
        .Q(Q)
    );

    // Generador de reloj: periodo de 10 ns (cambia cada 5 ns)
    always #5 clk = ~clk;

    initial begin
        // Generación de archivo para OpenWave
        $dumpfile("registro_d_4bits.vcd"); 
 // Nombre del archivo de salida para la traza de la simulación
        $dumpvars(0, tb_registro_D_4bits); 
 // Registra todas las señales del testbench

        // Inicialización de señales
        clk = 0;
        EN  = 0;
        D   = 4'b0000;

        // Esperar un poco antes de comenzar
        #10;

        // Prueba 1: EN = 1, cargar D = 1010
        EN = 1; D = 4'b1010;
        #10; // Esperar un ciclo de reloj

        // Prueba 2: EN = 0, D cambia pero Q debe mantenerse
        EN = 0; D = 4'b0101;
        #10; // Como EN = 0, Q no debe cambiar

        // Prueba 3: EN = 1, cargar D = 1111
        EN = 1; D = 4'b1111;
        #10; // Q debe actualizarse a 1111

        // Prueba 4: EN = 0, D cambia, Q debe mantenerse
        EN = 0; D = 4'b0000;
        #10; // Q debe seguir en 1111

        // Finalizar simulación
        $finish;
    end

    // Monitoreo por consola
    initial begin
        $monitor("Time=%0t | EN=%b | D=%b | Q=%b", $time, EN, D, Q);
    end

endmodule