# 3-Stage Pipelined RISC-V Soft Core (Verilog)

A foundational 3-stage pipelined RISC-V soft core implemented in Verilog HDL and verified via behavioral simulation in AMD Vivado targeting the Xilinx Artix-7 (`xc7a35tcpg236-1`).

---

## 1. Architecture Overview

The processor divides instruction execution into three sequential pipeline stages:
1. **Fetch (`IF`):** Increments the Program Counter (`PC`) and fetches 32-bit instructions from instruction memory.
2. **Decode / Execute (`ID/EX`):** Decodes instruction fields, reads source operands (`rs1`, `rs2`) from the register file, and performs arithmetic/logic operations in the ALU.
3. **Memory / Write-Back (`MEM/WB`):** Handles data memory access and writes computed results back to the destination register (`rd`).

---

## 2. Repository Structure

| File | Description |
| :--- | :--- |
| `riscv_3stage_top.v` | Top-level module connecting the pipeline stages, register file, and memories[cite: 1] |
| `fetch_stage.v` | Program Counter (`PC`) logic and instruction fetch stage |
| `decode_execute_stage.v` | Instruction decoding, control logic, and ALU execution stage |
| `memory_writeback_stage.v` | Memory interface and register write-back stage |
| `register_file.v` | 32 × 32-bit general-purpose register file with `x0` hardwired to `0`[cite: 1] |
| `instruction_memory.v` | Read-only instruction memory preloaded with test instructions |
| `data_memory.v` | Data memory module for load/store operations |
| `riscv_3stage_tb.v` | Behavioral testbench driving clock, reset, and debug outputs (`pc_debug`, `alu_result_debug`)[cite: 1, 3] |

*(Note: Adjust the file names in the table above if any of your uploaded `.v` modules use slightly different names.)*

---

## 3. Simulation & Tools

* **HDL:** Verilog
* **Simulator:** AMD Vivado Behavioral Simulator (`xsim`)[cite: 1]
* **Target Device:** Xilinx Artix-7 (`xc7a35tcpg236-1`)

### How to Run
1. Open AMD Vivado and create a new RTL project targeting `xc7a35tcpg236-1`.
2. Add all `.v` design files as **Design Sources** and `riscv_3stage_tb.v` as a **Simulation Source**[cite: 1].
3. Run **Behavioral Simulation** (`sim_1`)[cite: 1] and inspect `pc_debug`, `alu_result_debug`, and internal `register_file` values[cite: 1, 3].

---

## 4. Baseline Verification Results

The core was tested with a basic sequence of `addi`, `add`, and `nop` instructions on a `10 ns` clock period[cite: 4, 8]:

| Instruction | Machine Code (Hex) | Target Register | Expected Value | Observed Value | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `addi x1, x0, 5` | `0x00500093` | `x1` | `5` (`0x00000005`) | `5` (`0x00000005`)[cite: 7, 8] | Verified |
| `addi x2, x0, 10` | `0x00A00113` | `x2` | `10` (`0x0000000A`) | `10` (`0x0000000A`)[cite: 7, 8] | Verified |
| `add x3, x1, x2` | `0x002081B3` | `x3` | `15` (`0x0000000F`) | `5` (`0x00000005`)[cite: 8] | Mismatch (Known Issue) |
| `nop` | `0x00000013` | `x0` | `0` (`0x00000000`) | `0` (`0x00000000`)[cite: 6, 7, 8] | Verified |

---

## 5. Known Limitations & Takeaways

* **Data Hazard / Operand Mismatch on `add`:** Executing `add x3, x1, x2` currently writes `0x00000005` (`5`) to `x3` instead of `0x0000000F` (`15`) due to unaddressed pipeline data hazard / operand routing behavior[cite: 8].
* **End-of-Program `X` Propagation:** Once `PC` increments past the initialized instructions in instruction memory (after `~74.5 ns`), uninitialized memory values propagate as `X` through the pipeline[cite: 7, 8].
* **Project Scope:** Built as an initial hands-on RTL design exercise to understand pipelined datapaths, control signals, and Vivado waveform debugging before moving on to more advanced processor architectures.
