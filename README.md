# Trabajo Final Integrador: Contador de Ocupación de Estacionamiento

Este proyecto implementa un sistema completo en Verilog para detectar y contabilizar la entrada y salida de vehículos, diseñado para ser impactado en la placa EDU-CIAA-FPGA.

## Objetivo

Diseñar un contador de ocupación para 7(siete) vehículos máximo en el estacionamiento. El sistema utiliza una Máquina de Estados Finitos (FSM) con dos señales de entrada, a y b, para detectar el ingreso y egreso de autos. La simulación de los sensores fotoeléctricos se realiza mediante los pulsadores de la EDU-CIAA-FPGA utilizando circuitos antirebote, y se utilizan los 4 LEDS de la placa para visualizar el número actual del contador de vehículos.

## 📁 Estructura del Repositorio

El proyecto está dividido modularmente. Cada carpeta de hardware contiene su propio código fuente (`.v`), su banco de pruebas o *testbench* (`_tb.v`), y los archivos generados por las herramientas de simulación y síntesis:

* **`fsm-sensores/`**: Contiene la Máquina de Estados Finitos (`fsm-sensores.v`). Este módulo evalúa la secuencia de bloqueos y desbloqueos de los sensores a y b (por ejemplo: 00, 10, 11, 01, 00) para determinar la dirección del vehículo.
* **`contador-estacionamiento/`**: Implementa el contador ascendente/descendente (`contador-estacionamiento.v`) que permite contabilizar la cantidad de autos estacionados, respetando el límite máximo.
* **`top-module/`**: Es el módulo de mayor jerarquía (`top-module.v`). Aquí se combina el contador, la FSM, el circuito de visualización de LEDs y el circuito de los pulsadores para realizar el "Contador de Ocupación de Estacionamiento". Incluye el archivo de restricciones físicas (`edu-ciaa-fpga.pcf`) y los archivos binarios (`hardware.bin`) listos para sintetizar en la FPGA.
* **`z_logica/`**: Contiene toda la documentación de respaldo del diseño lógico en formato PDF (`Logica-Verilog.pdf`, `Maquina-Sensores.pdf`, `Tabla-Transicion-Estados.pdf`). Contiene la documentación de esta etapa.

## ⚙️ Tecnologías y Herramientas

* **Lenguaje de Descripción de Hardware:** Verilog.
* **Plataforma de Desarrollo:** EDU-CIAA-FPGA.
* **Toolchain:** Apio (Síntesis, ruteo y programación).
