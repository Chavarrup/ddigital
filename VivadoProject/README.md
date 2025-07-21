## Visualización del diseño en Vivado (Femto + Multiplier)

Este proyecto incluye la integración de un periférico multiplicador (`multiplier.v`) al SoC basado en el procesador FemtoRV32-Quark (`femtosoc.v`). Para validar la correcta conexión y síntesis del diseño, se utilizó Vivado para generar el esquemático estructural del sistema.

### Objetivo

El objetivo principal de generar el esquemático en Vivado es **verificar gráficamente cómo se integran y conectan los diferentes módulos del SoC**, especialmente el nuevo periférico `multiplier`. Esto permite detectar errores de conexión, rutas no enlazadas y asegurarse de que el diseño RTL refleje la arquitectura lógica esperada.

### ¿Para qué sirve el esquemático generado?

- **Visualizar la jerarquía completa** del sistema (`femtosoc` → `multiplier`, UART, RAM, etc.)
- **Comprobar las conexiones de señales** de control (`rstrb`, `wstrb`, `sel`, `busy`, etc.)
- **Entender el flujo de datos** desde la CPU hasta el periférico y de regreso
- **Depurar errores de diseño** antes de correr simulaciones o implementar en FPGA
- **Validar consistencia** con la documentación y los diagramas lógicos planeados

### Cómo generar el esquemático en Vivado

1. Crear un proyecto tipo *RTL Project* y añadir los archivos del FemtoSoC (`femtosoc.v`, `multiplier.v`, `FemtoRV.v`, etc.)
2. Ir a **RTL Analysis > Open Elaborated Design**
3. En el panel izquierdo, abrir el **Schematic**
4. Navegar jerárquicamente hasta encontrar el módulo `multiplier` y revisar sus puertos

> Esta vista es especialmente útil cuando se integran nuevos periféricos personalizados al FemtoRV32, ya que permite confirmar que el direccionamiento, las señales de control y el flujo de datos están funcionando como se espera.

