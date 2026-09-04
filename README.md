# Proyecto Fin de Asignatura — Programación de Hardware Reconfigurable (PHR)

Este repositorio contiene el diseño, simulación, síntesis e implementación en hardware del proyecto final para la asignatura **Programación de Hardware Reconfigurable (PHR)**. El sistema está diseñado para ser desplegado en la tarjeta de desarrollo **Digilent Basys 3**, equipada con una FPGA Xilinx Artix-7.

---

## 📋 Índice
1. [Descripción General](#-descripción-general)
2. [Arquitectura del Sistema](#-arquitectura-del-sistema)
3. [Estructura del Repositorio](#-estructura-del-repositorio)
4. [Hardware Objetivo y Requisitos](#-hardware-objetivo-y-requisitos)
5. [Asignación de Periféricos y Pines (XDC)](#-asignación-de-periféricos-y-pines-xdc)
6. [Flujo de Trabajo en Vivado](#-flujo-de-trabajo-en-vivado)
   * [Apertura del Proyecto](#1-apertura-del-proyecto)
   * [Simulación Funcional](#2-simulación-funcional)
   * [Síntesis e Implementación](#3-síntesis-e-implementación)
   * [Programación de la FPGA](#4-programación-de-la-fpga)
7. [Análisis de Recursos e Timing](#-análisis-de-recursos-e-timing)

---

## 📸 Descripción General

El objetivo de este proyecto es implementar un sistema digital síncrono completo sobre lógica reconfigurable. El diseño integra el procesamiento de entradas digitales provenientes de los periféricos de la placa Basys 3, la gestión mediante máquinas de estados finitos (FSM) o unidades de control dedicadas, y la generación de salidas visuales/numéricas.

### Características Principales:
* **Frecuencia de Reloj Principal:** 100 MHz (proporcionada por el oscilador de la placa).
* **Gestión de Entradas:** Filtrado y debouncing (anti-rebote) en pulsadores e interruptores.
* **Procesamiento:** Lógica combinacional y secuencial optimizada para la arquitectura Artix-7.
* **Interfaz de Salida:** Multiplexación en tiempo para los visualizadores de 7 segmentos y control de LEDs indicadores.

---

## 🏗️ Arquitectura del Sistema

El módulo principal del diseño (`Top.vhd` / `Top.v`) actúa como entidad de nivel superior, interconectando los siguientes submódulos funcionales:

```text
                               +----------------------------------------+
                               |              MÓDULO TOP                |
                               |                                        |
  [CLK 100MHz] --------------->|  +----------------------------------+  |
  [RST] ---------------------->|  | Divisor de Reloj / Prescaler     |  |
                               |  +----------------------------------+  |
                               |                   |                    |
  [Pulsadores / BTN] --------->|  +----------------v-----------------+  |
  [Interruptores / SW] ------->|  | Sincronización / Anti-rebote     |  |
                               |  +----------------------------------+  |
                               |                   |                    |
                               |  +----------------v-----------------+  |
                               |  | Unidad de Control y Proceso      |  |
                               |  | (FSM / Datapath)                 |  |
                               |  +----------------------------------+  |
                               |                   |                    |
                               |  +----------------v-----------------+  |
                               |  | Controlador Display 7 Segments  |  |------------> [Displays 7-Seg]
                               |  +----------------------------------+  |------------> [Anodos / Catodos]
                               |                   |                    |
                               |                   +--------------------> [LEDs 0-15]
                               +----------------------------------------+
