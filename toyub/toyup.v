// Toy Microprocessor design.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 27, 2025.
module toyup (
    input wire rst, // Señal de reset
    input wire clk, // Señal de reloj
    input wire [7:0] IPORT, // Puerto de entrada (entrada de datos al microprocesador)
    output wire [7:0] OPORT // Puerto de salida (salida del microprocesador)
    );

    wire [7:0] bus;  // Bus de datos compartido por tods los módulos
    wire [7:0] add;  // Dirección de memoria: salida del PC, entrada a RAM
    // Connects PC with mem.
    // A(IE, OE, ACC); B(IE, OE); I(OE); O(IE); 
    // PC(EN, LD); MEM(OE); IR(IE); IC(EN, CLR)

    // Palabra de control de 13 bits
    // Cada bit habilita acciones específicas en módulos del procesador
    wire [12:0] CW;  // Control word.
    // Instrucción actual cargada desde memoria a través del bus
    wire [7:0] INSTRUCTION; // Current instruction.
    // Paso actual del ciclo de instrucción (0 a 7)
    wire [2:0] STEP; // Current step of the instruction.

    // Component instantiation.
    // Instanciación del Contador del Programa (PC)
    countup8bitld PC (
        .clk(clk),
        .en(CW[5]), // Incrementar
        .rst(rst), 
        .ld(CW[4]), // Cargar desde bus
        .D(bus), 
        .Q(add)
    );

    // Contador de pasos de instrucción (Instruction Cycle)
    countup3bitclr IC (
        .clk(clk), 
        .en(CW[1]), // Avanza al siguiente paso
        .rst(rst),
        .clr(CW[0]), // Reinicio del ciclo de instrucción
        .Q(STEP)
    );

    // Registro acumulador (A)
    accreg8bit A(
        .clk(clk), 
        .en(CW[12]), 
        .ldacc(CW[10]), 
        .oe(CW[11]), 
        .D(bus), 
        .O(bus)
    );

    // Registro B (registro general)
    buffdreg8bit B(.clk(clk), .en(CW[9]), .oe(CW[8]), 
        .D(bus), .O(bus));

    // Entrada de datos desde el mundo exterior
    buffdreg8bit I(.clk(clk), .en(1'b1), .oe(CW[7]), 
        .D(IPORT), .O(bus));

    // Salida de datos hacia el mundo exterior
    buffdreg8bit O(.clk(clk), .en(CW[6]), .oe(1'b1), 
        .D(bus), .O(OPORT));

    // Registro de Instrucción (IR)
    dreg8bit IR (.clk(clk), .en(CW[2]), .rst(rst), 
        .D(bus), .Q(INSTRUCTION));   

    // Memoria de instrucciones y datos
    RAM8x64 MEM (.add(add), .oe(CW[3]), .O(bus));

    // Unidad de Control: genera señales de control basadas en instrucción y paso actual
    ControlUnit cu (.clk(clk), .instr(INSTRUCTION), 
        .step(STEP), .CW(CW));
        

endmodule
