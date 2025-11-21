# CPU_VHDL
A simple VHDL-based CPU system implemented for the Intel/Altera MAX 10 FPGA (10M50DAF484C7G).  
The project includes a custom CPU, ROM program memory, address bus decoder, input filter for manual clocking, LED output device, and multiple 7-segment display modules for visual debugging.

This design is intended for educational and embedded-systems practice within digital logic, CPU architecture and FPGA development.

---

## 📌 Features
- **Custom VHDL CPU** with a small instruction set
- **ROM program memory** (Harvard-style fetch)
- **Shared data bus** with tri-state behavior
- **Address bus decoder** to route read/write operations
- **OUT_LED module** for storing data to LEDs
- **Input filtering** allowing manual or automatic clock modes
- **Status display system** for:
  - Program Counter (PC)
  - Instruction Register (IR)
  - CPU internal state (FETCH, DECODE, EXECUTE, STORE)
  - Current address bus value
- **Fully synthesizable** and runs on:
  - DE10-Lite
  - MAX10 10M50 FPGA
- **Fully verified** in ModelSim

---

## 📁 Folder Structure
CPU_VHDL/
│
├── src/
│ ├── CPU_VHDL_project_DE10.vhd # Top-level design
│ ├── simple_vhdl_cpu.vhd # CPU core
│ ├── rom_vhdl.vhd # ROM memory
│ ├── addr_bus_decoder.vhd # Address decoder
│ ├── input_filter.vhd # Manual/auto clock filter
│ ├── out_led.vhd # LED register
│ ├── SJU_SEG_DISPLAYER.vhd # 7-seg: hex digits
│ ├── SJU_SEG_DISPLAYER_CPU_STATE.vhd # 7-seg: CPU states
│ ├── status_display_system.vhd # 7-seg multiplexer
│ └── ...
│
├── testbench/ # Simulation files
│ ├── CPU_VHDL_project_DE10_tb.vhd
│ ├── wave.do
│ └── ...
├──Docs/ # 
│ ├── Technical Report.pdf

│ └── ...
│
└── README.md

---

## 🧠 System Overview

### ✔ CPU Core  
Implements a simple 2-bit state machine:

| State | Meaning     |
|-------|-------------|
| 00    | FETCH       |
| 01    | DECODE      |
| 10    | EXECUTE     |
| 11    | STORE       |

Outputs:
- Program Counter  
- Instruction Register  
- Data Bus  
- Write Enable (WE_n)  
- Bus Enable (bus_en_n)

---

### ✔ Address Bus Decoder  
Decodes CPU address bus:

| Address Range | Device         |
|---------------|----------------|
| 0x00–0xFF     | ROM            |
| 0xF0 etc.     | OUT_LED        |

Outputs chip-select signals:
- `CS_ROM_n`
- `CS_OUT_LED_n`

---

### ✔ Input Filter  
Provides:
- Automatic 50 MHz clock  
- OR manual clock using KEY0  
- Debounce logic  
- Output `Clk_out` for CPU

---

### ✔ Status Display System  
Displays CPU internals on HEX displays:

| HEX | Value Shown             |
|-----|--------------------------|
| HEX0 | Address bus             |
| HEX1 | Program Counter (PC)    |
| HEX2 | Instruction Register    |
| HEX3 | CPU State               |

---

### ✔ LED Output Register  
Stores CPU output to LEDs (write on WE_n = 0).

---

## 🧪 Simulation

### Requirements
- ModelSim (Intel Edition)
- Provided `.do` script

### Run simulation
1. Open ModelSim
2. Change directory to `/testbench`
3. Run:

CPU_VHDL_project_DE10

---

## 📜 License
This project is intended for educational use within FPGA and embedded system development.  
Feel free to use and modify for learning or academic purposes.

---

## 👤 Author
**Menyar Hees**  
Embedded Systems & FPGA Engineering Student  
TEIS / Embedded Computer Systems Architecture


