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
```

## Testbench

El archivo `toyup_tb.v` es el banco de pruebas diseñado para validar el comportamiento funcional del microprocesador `toyup`. Su propósito es simular una serie de ciclos de reloj y reset, permitiendo observar cómo responde el sistema ante ciertas condiciones predefinidas.

## Módulo `toyup.v`

A continuación se representa la **topología principal** del microprocesador de juguete. Aquí se integran todos los módulos funcionales para conformar el datapath y control del sistema. El objetivo es ilustrar el funcionamiento interno de un microprocesador simple, usando una arquitectura modular y jerárquica.

### Entradas y salidas del módulo

| Señal     | Tamaño | Dirección | Descripción |
|-----------|--------|-----------|-------------|
| `clk`     | 1 bit  | Entrada   | Señal de reloj del sistema. Todos los módulos se sincronizan con su flanco positivo. |
| `rst`     | 1 bit  | Entrada   | Reset general activo en alto, reinicia registros y contadores. |
| `IPORT`   | 8 bits | Entrada   | Puerto de entrada de datos externo. |
| `OPORT`   | 8 bits | Salida    | Puerto de salida hacia el exterior. Representa la salida final del procesador. |

---

### Propósito del diseño

Este módulo combina los elementos fundamentales de un microprocesador:

- **Datapath**: A, B, PC, IR, I/O, RAM, BUS.
- **Control**: Unidad de Control basada en FSM que genera la palabra de control (`CW`).
- **Ciclo de instrucción dividido en pasos**: cada instrucción se ejecuta en varias fases controladas por el contador de pasos (`IC`).

---

### Componentes instanciados

| Componente      | Descripción                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `countup8bitld`  | Contador del programa (PC). Incrementa o carga una dirección desde el bus. |
| `countup3bitclr` | Contador de pasos del ciclo de instrucción (IC). Reiniciable y habilitable. |
| `accreg8bit`     | Registro acumulador A. Tiene entrada y salida bidireccional por el bus.     |
| `buffdreg8bit`   | Registros B, I y O. B es auxiliar, I es entrada y O es salida.              |
| `dreg8bit`       | Registro de Instrucción (IR). Almacena la instrucción actual.              |
| `RAM8x64`        | Memoria combinada para instrucciones y datos. Direccionada por `PC`.       |
| `ControlUnit`    | Unidad de control FSM. Genera la palabra de control de 13 bits.            |

---

### Señales internas clave

| Señal       | Tamaño | Descripción |
|-------------|--------|-------------|
| `bus`       | 8 bits | Bus de datos compartido por todos los módulos. |
| `add`       | 8 bits | Dirección generada por `PC` para acceder a la memoria. |
| `CW`        | 13 bits| Palabra de control que determina qué módulos están activos en cada paso. |
| `INSTRUCTION` | 8 bits | Instrucción leída de la RAM y almacenada en el IR. |
| `STEP`      | 3 bits | Paso actual del ciclo de instrucción. |

---

### Descripción del flujo

1. El `PC` genera una dirección.
2. `RAM8x64` entrega una instrucción que es capturada por `IR`.
3. La `ControlUnit` interpreta la instrucción y activa ciertos bits de la palabra de control (`CW`).
4. Dependiendo del paso (`STEP`) y la instrucción, se habilitan registros, se transfieren datos por el bus, y se modifica el estado del sistema.
5. El `IC` avanza el paso en cada flanco de reloj, generando así un ciclo de ejecución paso a paso.

---
