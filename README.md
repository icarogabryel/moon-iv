# COMETA MARK II
Computer for Every Task Architecture Mark II

Developed by Ícaro Gabryel\
[GitHub](https://github.com/icarogby)
[LinkedIn](https://www.linkedin.com/in/icarogby/)

FEDERAL UNIVERSITY OF PIAUI\
NATURE SCIENCE CENTER\
COMPUTING DEPARTMENT

## Introduction
COMETA Mark II is a 16 Bit, unicycle and multicore processor designed for general purpose. It have two bank registers, memory hierarchy, uses Harvard architecture and have a 1024 words of 16 bits main memory.

## Rights reserved

## How To Simulate
To simulate the processor, you need to have the following tools installed:
- ModelSim

After installing the tools, you need to open the ModelSim, create a new project and add the files in the `Source` folder to the project. Then, you need to compile the files (compile with 2008 syntax) and simulate the `cometa_testbench.vhdl` file.

You can use the `compiler.py` file to compile codes written in the COMETA Mark II Assembly Language. After compiling, you can put the compiled .txt file (is obligatory to name the compiled file as "main_mem.txt") in the `Source` folder and simulate.

## Compiler
The compiler is a Python script that compiles the COMETA Mark II Assembly Language to a .txt file that can be used to simulate the processor.

To use the compiler, you need to have Python installed. After installing Python, you can run the `compiler.py` file and put the file name of the code you want to compile and the file name of the output file.

## Assembly Language
The COMETA Mark II Assembly Language is a simple language that is used to program the processor. The language is based on the Instruction Set Architecture (ISA) of the processor.

The language is case insensitive and the instructions are separated by a new line. The instructions have the following format:
```assembly
<instruction> <operand1> <operand2> <operand3>
```

The operands are separated by a comma and the number of operands depends on the instruction. The operands can be a register or a number.

`&` is used to indicate a AC register and `$`to indicate a RF register.

Numbers can be decimal or binary. If the number starts with `b`, it is considered binary. Otherwise, it is considered decimal. Number also can be negative if it starts with `-`. If you want a negative binary number, you need to put the `-` before the `b`. The compiler will convert negative decimal numbers to two's complement.

The comments are indicated by `//`.

The following is an example of a code written in the COMETA Mark II Assembly Language:

```assembly
lli &0, 3        // load 3 (0011) in ac0
lli &1, 5        // load 5 (0101) in ac1
mfac &0, $0      // move 3 to rf0
mfac &1, $1      // move 5 to rf1
add &2, $0, $1   // arith and logic ops
sub &2, $0, $1   // negative result
```


## Instruction Set Architecture - ISA

### Logical and Arithmetic Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| No Operation                           | nope | 000000 | None | No operation |
| Addition                               | add  | 000001 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 + rf2 |
| Subtraction                            | sub  | 000010 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 - rf2 |
| NOT                                    | not  | 000011 | ac(9-8), rf1(7-4)             | ac = NOT rf1 |
| AND                                    | and  | 000100 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 AND rf2 |
| OR                                     | or   | 000101 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 OR rf2 |
| XOR                                    | xor  | 000110 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 XOR rf2 |
| NAND                                   | nand | 000111 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 NAND rf2 |
| NOR                                    | nor  | 001000 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 NOR rf2 |
| XNOR                                   | xnor | 001001 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 XNOR rf2 |
| Set on Less Than                       | slt  | 010101 | ac(9-8), rf1(7-4), rf2(3-0)   | If rf1 < rf2 then ac = 1 else ac = 0 |
| Test, Add and Shift for Multiplication | tasm | 001101 | rf1(7-4)                      | If lo(0) == ‘1’ then  hi = hi + rf1; hi, lo >> 1 else hi, lo >> 1 |
| Test, Sub and Shift for Multiplication | tssm | 001110 | rf1(7-4)                      | If lo(0) == ‘1’ then  hi = hi - rf1; hi, lo >> 1 else hi, lo >> 1 |

### Shift Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| Shift Left Logical                     | sll  | 001010 | ac(9-8), rf1(7-4), shamt(3-0) | ac = rf1 << shamt |
| Shift Right Logical                    | srl  | 001011 | ac(9-8), rf1(7-4), shamt(3-0) | ac = rf1 >> shamt |
| Shift Right Arithmetic                 | sra  | 001100 | ac(9-8), rf1(7-4), shamt(3-0) | ac = signed(rf1) >> shamt |

### Move Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| Move To Low                            | mtl  | 001111 | ac(9-8)                       | lo = ac |
| Move From Low                          | mfl  | 010000 | ac(9-8)                       | ac = lo |
| Move To High                           | mth  | 010001 | ac(9-8)                       | hi = ac |
| Move From High                         | mfh  | 010010 | ac(9-8)                       | ac = hi |
| Move To AC                             | mtac | 010011 | ac(9-8), rf1(7-4)             | ac = rf1 |
| Move From AC                           | mfac | 010100 | ac(9-8), rf1(7-4)             | rf1 = ac |

### Immediate Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| Addition Immediate    | addi  | 010110 | ac(9-8), imm(7-0) | ac = ac + ((imm(7), 8) & imm) |
| Subtraction Immediate | subi  | 010111 | ac(9-8), imm(7-0) | ac = ac - ((imm(7), 8) & imm) |
| AND Immediate         | andi  | 011000 | ac(9-8), imm(7-0) | ac = ac AND ("00000000" & imm) |
| OR Immediate          | ori   | 011001 | ac(9-8), imm(7-0) | ac = ac OR  ("00000000" & imm) |
| XOR Immediate         | xori  | 011010 | ac(9-8), imm(7-0) | ac = ac XOR ("00000000" & imm) |
| NAND Immediate        | nandi | 011011 | ac(9-8), imm(7-0) | ac = NOT (ac AND ("00000000" & imm)) |
| NOR Immediate         | nori  | 011100 | ac(9-8), imm(7-0) | ac = NOT (ac OR  ("00000000" & imm)) |
| XNOR Immediate        | xnori | 011101 | ac(9-8), imm(7-0) | ac = NOT (ac XOR ("00000000" & imm)) |
| Load Lower Immediate  | lli   | 011110 | ac(9-8), imm(7-0) | ac = "00000000" & imm |
| Load Upper Immediate  | lui   | 011111 | ac(9-8), imm(7-0) | ac = imm & "00000000" |
| Load Signed Immediate | lsi   | 100000 | ac(9-8), imm(7-0) | ac = (imm(7), 8) & imm |

### Memory Access Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| Load Word Register  | lwr  | 100001 | ac(9-8), rf1(7-4) | ac = memory\[rf1\] |
| Store Word Register | swr  | 100010 | ac(9-8), rf1(7-4) | memory\[rf1\] = ac |
| Push                | push | 100011 | ac(9-8)           | sp = sp - 1; memory\[sp\] = ac |
| Pop                 | pop  | 100100 | ac(9-8)           | ac = memory\[sp\]; sp = sp + 1 |

### Control Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| Jump                   | jump | 100101 | imm(9-0) | pc = pc(15-10) & imm |
| Jump and Link          | jal  | 100110 | imm(9-0) | lk = pc + 1; pc = pc(15-10) & imm |
| Jump Register          | jr   | 100111 | rf1(7-4) | pc = rf1 |
| Jump Register and Link | jral | 101000 | rf1(7-4) | lk = pc + 1; pc = rf1 | 
| Jump Greater Than Zero | jgtz | 101001 | rd(9-8), imm(7-0) | If ac > 0 then pc = (pc + 1) + imm |
| Jump Less Than Zero    | jltz | 101010 | rd(9-8), imm(7-0) | If ac < 0 then pc = (pc + 1) + imm |
| Jump Equal To Zero     | jeqz | 101011 | rd(9-8), imm(7-0) | If ac == 0 then pc = (pc + 1) + imm |
| Jump Not Equal To Zero | jnez | 101100 | rd(9-8), imm(7-0) | If ac != 0 then pc = (pc + 1) + imm |
