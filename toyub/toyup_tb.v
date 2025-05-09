// Toy Microprocessor design test bench.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 27, 2025.
`timescale 1ns/1ps
module toyup_tb ();

    reg clk, rst; // Señales de reloj y reset
    reg [7:0] IPORT;  // Puerto de entrada simulado
    wire [7:0] OPORT;  // Puerto de salida observado

    // Inicialización del reloj
    initial clk = 0;

    // Inicialización del reset
    initial begin 
        rst = 0;
        #10 rst = 1; // Se aplica reset luego de 10ns
    end

    // Generador de reloj: ciclo de 10ns (frecuencia de 100 MHz)
    always #5 clk = ~clk;


    // Instanciación del microprocesador
    toyup Microprocessor(.clk(clk), .rst(rst), 
        .IPORT(IPORT), .OPORT(OPORT));

    // Simulación controlada
    initial begin
        $dumpfile("toyup.vcd"); // Archivo para la traza de la simulación
        $dumpvars;
        #500;    // Duración de la simulación: 500ns
        $finish;  // Fin de la simulación
    end

endmodule
