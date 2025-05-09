# Toy Microprocessor Design

**Autor:** Juan Bernardo Gómez-Mendoza  
**Última actualización:** Abril 27, 2025

---

## Descripción general

Este proyecto implementa un microprocesador de juguete de 8 bits para propósitos educativos. El sistema completo incluye:
- Un banco de pruebas (`toyup_tb`)
- Un diseño modular de microprocesador (`toyup`)
- Módulos funcionales como acumuladores, registros, contador de programa, memoria y unidad de control.

---

## Entradas

| Señal     | Tamaño | Descripción                           |
|----------|--------|---------------------------------------|
| `clk`    | 1 bit  | Señal de reloj del sistema            |
| `rst`    | 1 bit  | Señal de reset (activo en alto)       |
| `IPORT`  | 8 bits | Puerto de entrada de datos externo    |

---

## Salidas

| Señal     | Tamaño | Descripción                           |
|----------|--------|---------------------------------------|
| `OPORT`  | 8 bits | Puerto de salida del microprocesador  |

---

## Comportamiento

El microprocesador ejecuta instrucciones a través de un ciclo dividido en pasos (`STEP`). La `ControlUnit` genera una palabra de control (`CW`) en función de la instrucción actual y del paso de ejecución.

### Componentes principales:
- **PC (Program Counter):** Señala la dirección en memoria.
- **IC (Instruction Cycle):** Controla el paso dentro del ciclo de instrucción.
- **IR (Instruction Register):** Guarda la instrucción actual.
- **A, B:** Registros de propósito general, siendo A el acumulador.
- **I, O:** Puertos para entrada y salida.
- **MEM:** Memoria de instrucciones/datos.
- **ControlUnit:** FSM que determina el flujo del programa.

---

## Ciclo de instrucción

1. PC proporciona dirección a RAM.
2. RAM proporciona instrucción al bus.
3. IR carga la instrucción desde el bus.
4. ControlUnit activa señales de control en cada paso para manipular registros y bus.
5. IC avanza al siguiente paso en cada ciclo.

---

## Código fuente

### Testbench (`toyup_tb.v`)
```verilog
// Toy Microprocessor design.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 27, 2025.
module toyup (input wire rst, input wire clk, 
    input wire [7:0] IPORT, output wire [7:0] OPORT);

    wire [7:0] bus;
    wire [7:0] add;  // Connects PC with mem.
    // A(IE, OE, ACC); B(IE, OE); I(OE); O(IE); 
    // PC(EN, LD); MEM(OE); IR(IE); IC(EN, CLR)
    wire [12:0] CW;  // Control word.
    wire [7:0] INSTRUCTION; // Current instruction.
    wire [2:0] STEP; // Current step of the instruction.

    // Component instantiation.
    countup8bitld PC (.clk(clk), .en(CW[5]), .rst(rst), 
        .ld(CW[4]), .D(bus), .Q(add));
    countup3bitclr IC (.clk(clk), .en(CW[1]), .rst(rst),
        .clr(CW[0]), .Q(STEP));
    accreg8bit A(.clk(clk), .en(CW[12]), .ldacc(CW[10]), 
        .oe(CW[11]), .D(bus), .O(bus));
    buffdreg8bit B(.clk(clk), .en(CW[9]), .oe(CW[8]), 
        .D(bus), .O(bus));
    buffdreg8bit I(.clk(clk), .en(1'b1), .oe(CW[7]), 
        .D(IPORT), .O(bus));
    buffdreg8bit O(.clk(clk), .en(CW[6]), .oe(1'b1), 
        .D(bus), .O(OPORT));
    dreg8bit IR (.clk(clk), .en(CW[2]), .rst(rst), 
        .D(bus), .Q(INSTRUCTION));    
    RAM8x64 MEM (.add(add), .oe(CW[3]), .O(bus));
    ControlUnit cu (.clk(clk), .instr(INSTRUCTION), 
        .step(STEP), .CW(CW));    

endmodule

