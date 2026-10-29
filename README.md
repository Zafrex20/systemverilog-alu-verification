# SystemVerilog ALU Design and Verification

## Overview

This repository contains a collection of RTL designs and testbenches developed using SystemVerilog and Xilinx Vivado. The main design is a parameterized Arithmetic Logic Unit (ALU), supported by a direct testbench and a separate verification environment.

The project uses GNU Make to organize the compilation, elaboration, and simulation flow. Vivado command-line tools and Tcl scripts are used to automate simulation tasks and generate waveform and coverage data.

## Repository Structure

```text
systemverilog-alu-verification/
├── hw/
│   ├── rtl/
│   │   ├── alu.sv
│   │   ├── and_gate.sv
│   │   ├── medio_sumador.sv
│   │   ├── xor_gate.sv
│   │   └── rtl.f
│   └── tb/
│       ├── tb_alu.sv
│       ├── tb_and.sv
│       ├── tb_mediosum.sv
│       └── tb_xor.sv
├── scripts/
│   ├── makefiles/
│   │   └── Makefile.xilinx
│   ├── setup/
│   │   └── setup_vivado_eda.sh
│   └── vivado/
│       ├── compile.tcl
│       ├── elaborate.tcl
│       ├── coverage.tcl
│       ├── probe.tcl
│       ├── relaunch.tcl
│       ├── run.tcl
│       └── simulate.tcl
├── verification/
│   ├── rtl/
│   ├── scripts/
│   ├── sv/
│   ├── tb/
│   └── test/
├── README.md
└── .gitignore
```

## Arithmetic Logic Unit

The ALU is implemented in `hw/rtl/alu.sv`. It is a combinational circuit with a configurable data width and two data inputs.

### Inputs

- `x_i`: First operand.
- `y_i`: Second operand.
- `zx_i`: Control signal to zero the first operand.
- `nx_i`: Control signal to invert the first operand.
- `zy_i`: Control signal to zero the second operand.
- `ny_i`: Control signal to invert the second operand.
- `f_i`: Selects the arithmetic or logical function.
- `no_i`: Control signal to invert the output.

### Outputs

- `out_o`: ALU result.
- `zr_o`: Asserted when the result is zero.
- `ng_o`: Indicates that the most significant bit of the result is set.
- `pos_o`: Asserted when the result is nonzero and its most significant bit is zero.

The default data width used by the direct testbench is 16 bits.

## Direct Testbench

The direct testbench is located in `hw/tb/tb_alu.sv`.

It initializes the inputs, applies a stimulus after 10 ns, monitors the inputs and outputs, and terminates the simulation after another 10 ns.

The testbench exercises an ALU operation using the following operands:

- `X = 15`
- `Y = 5`

The resulting output and status flags can be inspected in the simulator console and waveform viewer.

The repository also includes standalone testbenches for the AND gate, XOR gate, and half adder.

## Verification Environment

The `verification/` directory contains a separate verification-oriented implementation, including an ALU RTL module, a full adder, SystemVerilog interfaces, a testbench, a test class, and a dedicated set of Makefiles and Vivado scripts.

This structure keeps the verification environment separate from the direct RTL testbench flow.

## Requirements

The following tools are required to use the automated flow:

- Xilinx Vivado.
- `xvlog` for SystemVerilog compilation.
- `xelab` for elaboration.
- `xsim` for simulation.
- GNU Make.
- Bash and standard Unix command-line utilities.

The Vivado executable directory must be available in the environment's `PATH`.

## Simulation with GNU Make

The project uses `scripts/makefiles/Makefile.xilinx` to automate the direct testbench flow.

Run the following commands from the repository root.

### 1. Configure the project environment

```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
export DIRECT_WORK="$GIT_ROOT/work/direct"
mkdir -p "$DIRECT_WORK" && \
cd "$DIRECT_WORK" && \
ln -sf "$GIT_ROOT/scripts/makefiles/Makefile.xilinx" Makefile
```

This creates a dedicated working directory and links the project's Makefile into it. Generated simulation files are kept outside the source directories.

### 2. Display available Make targets

```bash
make
```

### 3. Compile the RTL and testbench

```bash
make compile
```

This invokes the Vivado SystemVerilog compiler through the Makefile.

### 4. Elaborate the design

```bash
make elaborate
```

This prepares the compiled design for simulation.

### 5. Run the simulation

```bash
make sim
```

The Makefile invokes `xsim` and uses the project's Tcl scripts to control the simulation flow.

### 6. Run with a graphical interface

```bash
make sim GUI_MODE=true
```

This enables the graphical simulation mode, allowing signal transitions to be inspected in the waveform viewer.

### 7. Clean generated files

```bash
make clean
```

This removes generated simulation, log, and waveform directories associated with the selected working directory.

## Verification Flow

The separate verification environment uses its own Makefile:

`verification/scripts/makefiles/Makefile.xilinx`

To initialize its working directory:

```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
export UVM_WORK="$GIT_ROOT/work/uvm"
mkdir -p "$UVM_WORK" && \
cd "$UVM_WORK" && \
ln -sf "$GIT_ROOT/verification/scripts/makefiles/Makefile.xilinx" Makefile
```

The same Make targets are available for this flow:

```bash
make compile
make elaborate
make sim
```

To run with a different configured test or verbosity, the Makefile provides variables such as `TEST`, `VERBOSITY`, and `SEED`. Their behavior depends on the selected verification environment and available test classes.

## Automation Scripts

The `scripts/vivado/` directory contains Tcl scripts for the compilation, elaboration, simulation, waveform probing, coverage, and relaunch stages.

The Makefile coordinates these scripts, keeping the simulation workflow repeatable and reducing the need to execute each Vivado command manually.

## Results and Evidence

Screenshots of successful compilation, simulator output, and waveform inspection can be added to the repository to document the results.

Simulation should be considered successful only after the actual tool output and expected signal behavior have been checked.

## Key Concepts

- Combinational RTL design using SystemVerilog.
- Parameterized ALU implementation.
- Arithmetic and logical operations.
- Status flag generation.
- Direct testbench stimulus.
- Automated compilation and elaboration with GNU Make.
- Vivado Tcl-based simulation workflows.
- Separation of RTL design and verification files.

## Future Improvements

Potential improvements include expanding the ALU testbench to cover all supported operations, adding self-checking assertions, measuring functional coverage, and extending the verification environment with additional directed and randomized tests.

## Disclaimer

This project is intended for educational purposes and as part of an RTL design and verification portfolio. The documented commands describe the intended Make-based workflow; successful execution depends on the local Vivado installation, environment configuration, and the current state of the verification files.
