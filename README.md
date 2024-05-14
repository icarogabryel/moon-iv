# MOOn IV

Developed by Ícaro Gabryel\
[GitHub](https://github.com/icarogby)
[LinkedIn](https://www.linkedin.com/in/icarogby/)

FEDERAL UNIVERSITY OF PIAUI\
NATURE SCIENCE CENTER\
COMPUTING DEPARTMENT

## Introduction
Many as Only One Quad-Core is a 16 Bit, unicycle and multicore processor designed for general purpose. It have two bank registers, memory hierarchy, uses Harvard architecture and have a 1024 words of 16 bits main memory.

## Rights reserved
This code is registered in INPI (National Institute of Industrial Property) under the number BR512024001300-8. All rights reserved.

## How To Simulate
To simulate the processor, you need to have the following tools installed:
- ModelSim

After installing the tools, you need to open the ModelSim, create a new project and add the files in the `Source` folder to the project. Then, you need to compile the files (compile with 2008 syntax) and simulate the `cometa_testbench.vhdl` file.

You can use the `compiler.py` file to compile codes written in the MOOn IV Assembly Language. After compiling, you can put the compiled .txt file (is obligatory to name the compiled file as "main_mem.txt") in the `Source` folder and simulate.

## Compiler
The compiler is a Python script that compiles the MOOn IV Assembly Language to a .txt file that can be used to simulate the processor.

To use the compiler, you need to have Python installed. After installing Python, you can run the `compiler.py` file and put the file name of the code you want to compile and the file name of the output file.

## Assembly Language
The MOOn IV Assembly Language is a simple language that is used to program the processor. The language is based on the Instruction Set Architecture (ISA) of the processor.

The language is case insensitive and the instructions are separated by a new line. The instructions have the following format:
```assembly
<instruction> <operand1> <operand2> <operand3>
```

The operands are separated by a comma and the number of operands depends on the instruction. The operands can be a register or a number.

`&` is used to indicate a AC register and `$`to indicate a RF register.

Numbers can be decimal or binary. If the number starts with `b`, it is considered binary. Otherwise, it is considered decimal. Number also can be negative if it starts with `-`. If you want a negative binary number, you need to put the `-` before the `b`. The compiler will convert negative decimal numbers to two's complement.

The comments are indicated by `//`.

The following is an example of a code written in the MOOn IV Assembly Language:

```
lli &0, 3        // load 3 (0011) in ac0
lli &1, 5        // load 5 (0101) in ac1
mfac &0, $0      // move 3 to rf0
mfac &1, $1      // move 5 to rf1
add &2, $0, $1   // arith and logic ops
sub &2, $0, $1   // negative result
```

## Instruction Set Architecture - ISA

The MOOn IV ISA have 49 instruction and is divided in seven types of instructions: No Operation, Logical and Arithmetic Operations, Shift Operations, Move Operations, Immediate Operations, Memory Access Operations and Control Flow Operations.
You can find the ISA of the processor in the following link: [ISA](ISA.md)
