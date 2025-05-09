# Acumulador de 8 Bits — Verilog

## Descripción General

Este proyecto implementa un **acumulador de 8 bits** utilizando Verilog. El acumulador puede operar en dos modos:

- **Carga directa**: carga un valor especificado en el acumulador.
- **Acumulación**: suma el valor de entrada al valor previamente almacenado.

El diseño está modularizado en tres partes:

1. `hadder8bit`: Sumador de 8 bits.
2. `mux8_2ch`: Multiplexor de 8 bits para seleccionar entre carga directa o suma.
3. `accreg8bit`: Módulo principal que integra los dos anteriores y actúa como acumulador.

---

## Entradas del módulo `accreg8bit`

| Nombre  | Tamaño | Descripción                                 |
|---------|--------|---------------------------------------------|
| `clk`   | 1 bit  | Señal de reloj (flanco positivo)            |
| `en`    | 1 bit  | Habilita la escritura en el acumulador      |
| `ldacc` | 1 bit  | Selector de operación:                      |
|         |        | - `1`: carga directa                        |
|         |        | - `0`: suma con el valor anterior (`Q + D`) |
| `D`     | 8 bits | Dato de entrada                             |

---

## Salidas del módulo `accreg8bit`

| Nombre | Tamaño | Descripción                   |
|--------|--------|-------------------------------|
| `Q`    | 8 bits | Resultado o valor acumulado   |

---

## Comportamiento

- En cada flanco positivo del reloj (`clk`):
  - Si `en = 1`:
    - Si `ldacc = 1`, el acumulador toma el valor de entrada `D` directamente.
    - Si `ldacc = 0`, el valor de `D` se **suma** al contenido actual (`Q`), y se almacena el resultado.

- Si `en = 0`, el contenido del acumulador no cambia.
---
## 🧾 Resumen de Estados

| Tiempo | `clk` | `en` | `ldacc` | `D`   | `Q`   | Acción                      |
|--------|-------|------|---------|-------|-------|-----------------------------|
| 10     | ↑     | 1    | 1       | 0A    | 0A    | Carga directa               |
| 20     | ↑     | 1    | 0       | 05    | 0F    | Acumula 0A + 05             |
| 30     | ↑     | 1    | 0       | 01    | 10    | Acumula 0F + 01             |
| 40     | ↑     | 1    | 1       | 0F    | 0F    | Carga directa               |
| 50     | ↑     | 0    | X       | FF    | 0F    | No hay cambio (`en = 0`)    |

---

## Submódulo 1: `hadder8bit`

### Descripción  
Suma dos vectores de 8 bits **sin acarreo de salida**.

### Código  
```verilog
module hadder8bit (
  input wire [7:0] A,
  input wire [7:0] B,
  output wire [7:0] O
);
  assign O = A + B;
endmodule
```
---

## Submódulo 2: `mux8_2ch`

### Descripción  
Multiplexor de 2 canales de 8 bits. Selecciona entre la entrada `A` o `B` según el valor de `sel`:
- **`sel = 0`**: Salida `O = A`  
- **`sel = 1`**: Salida `O = B`  

### Código  
```verilog
module mux8_2ch (
  input wire sel,          // Señal de selección
  input wire [7:0] A,      // Entrada A (8 bits)
  input wire [7:0] B,      // Entrada B (8 bits)
  output wire [7:0] O      // Salida (8 bits)
);
  assign O = (sel == 1'b0) ? A : B;  // Lógica del multiplexor
endmodule
```

## Módulo principal: `accreg8bit`
### Código  
```verilog
module accreg8bit (
  input wire clk,
  input wire en,
  input wire ldacc,
  input wire [7:0] D,
  output reg [7:0] Q
);

  wire [7:0] X;
  wire [7:0] Y;

  hadder8bit sum(.A(Q), .B(D), .O(X));
  mux8_2ch mux(.sel(ldacc), .A(X), .B(D), .O(Y));

  always @(posedge clk) begin
    if (en == 1) begin
      Q <= Y;
    end
  end

endmodule
```
