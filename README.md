# ➗ Booth Multiplier – Verilog

## Overview
This project implements a **16-bit signed Booth Multiplier** using Verilog HDL. The design is **modular**, separating the **datapath** and **control path**, and follows Booth’s algorithm for efficient multiplication of two’s complement numbers.

Booth multiplication is useful for high-performance signed arithmetic in DSPs, ALUs, and hardware accelerators.

---

## Module Structure

### `booth_multiplier.v` – RTL Design (Datapath + Control)
- **Datapath Components**:
  - **ALU**: Performs addition/subtraction operations.
  - **Shift Registers**: Handle right shifts of accumulator and multiplier.
  - **PIPO Registers**: Load multiplicand and intermediate values.
  - **Counter**: Tracks number of operations (bit shifts).

- **Control Unit (FSM)**:
  - Sequences operations based on Booth encoding (`Q0` and `Q-1`).
  - Controls signal flow: load, shift, add/sub, and done flags.
  - Manages state transitions for the entire multiplication cycle.

---

### `booth_tb.v` – Testbench
- Initializes input operands and control signals.
- Simulates both positive and negative signed multiplication cases.
- Validates output correctness step-by-step through waveform inspection.
- Uses `$dumpfile` and `$dumpvars` for GTKWave analysis.

---

## Features
- Supports **16-bit signed multiplication** using **Booth’s algorithm**.
- Clean **datapath-control separation** mimicking processor-style architecture.
- FSM-based controller handles encoding and sequencing.
- Simulated and verified across edge cases (e.g., +ve × −ve, 0 × n, etc.).

---

## How to Run
1. Open `booth_multiplier.v` and `booth_tb.v` in your Verilog simulation tool (e.g., ModelSim, EDA Playground).
2. Set the testbench top module (`booth_tb`) for simulation.
3. Observe `Product`, control signals, and state transitions.
4. Analyze results in waveform viewer (GTKWave recommended).

---

## Tools Used
- **Verilog HDL**
- **Simulation**: EDA Playground, GTKWave, ModelSim
- **Design Pattern**: Datapath + FSM Control

---

##  Learning Outcomes
- Gained hands-on experience with **Booth encoding logic**.
- Practiced modular RTL design separating datapath/control.
- Understood sequential operations and control sequencing for signed arithmetic.

---

## Author
**Sarath Srinivasan**  
B.Tech in Electrical Engineering  
Aspiring VLSI Engineer

---

## Tags
`verilog` `booth-algorithm` `multiplier` `digital-design` `rtl` `fsm` `signed-math` `datapath`
