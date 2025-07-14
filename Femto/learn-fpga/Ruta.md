# FemtoRV32 + Periférico Multiplicador

Este proyecto abarca el sistema FemtoSoC con un periférico multiplicador personalizado. Aquí encontrarás los pasos necesarios para compilar, ensamblar y simular el programa en Ubuntu, utilizando Icarus Verilog o Verilator.

---

## Requisitos

Asegúrate de tener instaladas las siguientes herramientas:

```bash
sudo apt update
sudo apt install build-essential make iverilog verilator git
sudo apt install gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf
```

---

## 1. Configuración del entorno

```bash
cd ~/learn-fpga/FemtoRV/FIRMWARE/

# Verifica que la ruta sea correcta
./TOOLS/TOOLS/make_config.sh -DBENCH_VERILATOR

# Revisa que se haya generado el archivo de configuración
cat config.mk
```

---

## 2. Ensamblar el firmware ASM

```bash
cd ~/learn-fpga/FemtoRV/FIRMWARE/ASM_EXAMPLES/
make clean
make multiplier.hex
```

---

## 3. Copiar firmware a la raíz del proyecto (si se requiere)

Solo si tu flujo de simulación lo necesita:

```bash
cp multiplier.hex ../firmware.hex
```

---

## 4. Simular el sistema

Desde la raíz del proyecto:

```bash
cd ~/learn-fpga/FemtoRV/
make BENCH.icarus      # Simulación con Icarus Verilog
make BENCH.verilator   # Simulación con Verilator (si está instalado)
```

---

## 5. Resultado esperado

En la salida de la simulación deberías ver algo como:

```
Resultado: 7 x 9 = 63
```

El valor depende de los operandos cargados en tu archivo `multiplier_test.S`.

---

## 6. Visualizar resultados en GTKWave

Una vez simulada la arquitectura con Icarus Verilog, se genera un archivo `wave.vcd` en la raíz del proyecto. Puedes visualizarlo así:

```bash
gtkwave wave.vcd
```

> Asegúrate de tener `gtkwave` instalado:
>
> ```bash
> sudo apt install gtkwave
> ```

Esto abrirá la interfaz de GTKWave, donde podrás observar señales como:
- `clk`
- `rst`
- `io_addr`, `io_rdata`, `io_wdata`
- `multiplier.sel`, `multiplier.rstrb`, `multiplier.rdata`, etc.

---

## Autor

Este proyecto fue adaptado por Lina M Chavarro para pruebas educativas con arquitectura RISC-V y periféricos personalizados.
