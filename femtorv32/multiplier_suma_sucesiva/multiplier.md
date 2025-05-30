# Multiplier.v — Multiplicador por suma sucesiva (FemtoRV32)

Este módulo implementa un multiplicador de 32 bits mediante suma repetitiva

## Características

- Multiplicación A × B usando sumas sucesivas.
- Interfaz compatible con el sistema FemtoRV32 como periférico mapeado a memoria.
- Indicador visual del resultado en los primeros 8 bits vía LEDs.
- Interfaz simple: 4 registros accesibles desde el procesador.

## Registros

| Offset (bytes) | Nombre    | Descripción               |
|----------------|-----------|---------------------------|
| 0              | A         | Operando A                |
| 4              | B         | Operando B                |
| 8              | START     | Inicia la operación       |
| 12             | RESULT    | Resultado final           |

## Señales

### Entradas
- `clk`, `rst`: reloj y reset.
- `wstrb`: escritura activa.
- `rstrb`: lectura activa.
- `sel [1:0]`: selección de registro.
- `wdata [31:0]`: datos de entrada.

### Salidas
- `rdata [31:0]`: datos de salida.
- `wbusy`: indica si está procesando.
- `LED [7:0]`: valor del resultado reflejado en LEDs.

## Interfaz

| Señal   | Tipo    | Descripción                                   |
|---------|---------|-----------------------------------------------|
| clk     | input   | Reloj del sistema                              |
| rst     | input   | Reset asincrónico, activo en alto              |
| wstrb   | input   | Strobe de escritura                            |
| rstrb   | input   | Strobe de lectura                              |
| sel     | input   | Selector del registro (2 bits, 4 registros)   |
| wdata   | input   | Datos de escritura (32 bits)                   |
| rdata   | output  | Datos de lectura (32 bits)                      |
| wbusy   | output  | Indica si está ocupado realizando multiplicación |
| rbusy   | output  | No usado (siempre 0) dejado para mantener compatibilidad.                           |
| LED     | output  | 8 LEDs con los 8 bits menos significativos del resultado |

---

## Modo de operación

1. Se escriben los operandos A y B.
2. Se activa el bit `START`.
3. El módulo comienza a sumar A, B veces.
4. El resultado es accesible en `RESULT` y reflejado en los LEDs.
5. El bit `START` se pone automáticamente en 0 al finalizar.

## Funcionamiento básico

1. **Escritura de operandos:**  
   - Se escriben los valores A y B en sus registros respectivos (offset 0 y 4).
   
2. **Inicio de multiplicación:**  
   - Al escribir en el registro `START` (offset 8) con `wstrb = 1` y `sel = 2'b10`, el multiplicador comienza la operación si no está ocupado.
   - El resultado y el contador se reinician, se activa la señal `start` y el módulo se pone en estado `busy`.

3. **Proceso de multiplicación por suma sucesiva:**  
   - En cada ciclo de reloj, si `busy` está activo y el contador es menor que B, se suma A al acumulador `result` y se incrementa el contador.
   - Cuando el contador alcanza B, la multiplicación termina (`busy` se pone a 0 y `start` a 0).

4. **Lectura de resultados:**  
   - Con `rstrb = 1` y el selector `sel` indicando el registro, el módulo devuelve el valor solicitado: A, B, busy o result.
   
5. **Indicador LED:**  
   - Los primeros 8 bits del resultado se muestran en un registro `LED` para visualizar el valor en hardware.

---

# Código Fuente

### Módulo: `multiplier.v`
```verilog
`timescale 1ns / 1ps

module multiplier (
  input wire clk,
  input wire rst,
  input wire wstrb,
  input wire rstrb,
  input wire [1:0] sel,
  input wire [31:0] wdata,
  output reg [31:0] rdata,
  output wire wbusy,
  output wire rbusy,
  output reg [7:0] LED
);

  reg [31:0] A;
  reg [31:0] B;
  reg [31:0] result;
  reg [31:0] counter;
  reg busy;
  reg start;

  assign wbusy = busy;
  assign rbusy = 0;

  // Escritura de registros
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      A <= 0; B <= 0; result <= 0; counter <= 0; start <= 0; busy <= 0;
    end else begin
      if (wstrb) begin
        case (sel)
          2'b00: A <= wdata;
          2'b01: B <= wdata;
          2'b10: if (!busy) begin
                   result <= 0;
                   counter <= 0;
                   start <= 1;
                   busy <= 1;
                 end
        endcase
      end

      if (busy) begin
        if (counter < B) begin
          result <= result + A;
          counter <= counter + 1;
        end else begin
          busy <= 0;
          start <= 0;
        end
      end
    end
  end

  // Lectura
  always @(*) begin
    if (rstrb) begin
      case (sel)
        2'b00: rdata = A;
        2'b01: rdata = B;
        2'b10: rdata = busy;
        2'b11: rdata = result;
        default: rdata = 32'hDEADBEEF;
      endcase
    end else begin
      rdata = 32'b0;
    end
  end

  always @(posedge clk)
    LED <= result[7:0];  // Mostrar solo 8 bits del resultado en los LEDs

endmodule