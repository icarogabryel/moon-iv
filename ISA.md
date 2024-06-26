# MOON IV - Instruction Set Architecture

## Instruction Formats

The instruction formats are shown in the following table. The opcode field is used to determine the instruction to be executed. The remaining fields depend on the instruction type.

| Format | Meaning | Fields ||||
|-|-|-|-|-|-|
| N-Type | No Operation | opcode(15-10) ||||
| R-Type | Register | opcode(15-10) | &ac(9-8) | $rf1(7-4) | &rf2(3-0) |
| I-Type | Immediate | opcode(15-10) | &ac(9-8) | imm(7-0) ||
| S-Type | Shift | opcode(15-10) | &ac(9-8) | $rf1(7-4) | shamt(3-0) |
| J-Type | Jump | opcode(15-10) | imm(9-0) |||

## Instructions Subsets

The instruction set is divided into the following subsets:

### No Operation

The `nope` instruction is used to perform no operation.

| Instruction | Mnemonic | Type | Opcode | Fields | Meaning |
|-|-|-|-|-|-|
| No Operation | nope | N |000000 | opcode(15-10) | No operation |

### Logical and Arithmetic Operations

The logical and arithmetic operations are used to perform arithmetic and logical operations on the registers. Their format is a three address instruction, where the result is stored in the accumulator register.

| Instruction | Mnemonic | Type | Opcode | Fields | Meaning |
|-|-|-|-|-|-|
| Addition                | add  | R | 000001 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 + rf2 |
| Subtraction             | sub  | R | 000010 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 - rf2 |
| NOT                     | not  | R | 000011 | ac(9-8), rf1(7-4)             | ac = NOT rf1 |
| AND                     | and  | R | 000100 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 AND rf2 |
| OR                      | or   | R | 000101 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 OR rf2 |
| XOR                     | xor  | R | 000110 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 XOR rf2 |
| NAND                    | nand | R | 000111 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 NAND rf2 |
| NOR                     | nor  | R | 001000 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 NOR rf2 |
| XNOR                    | xnor | R | 001001 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 XNOR rf2 |
| Set on Less Than        | slt  | R | 010101 | ac(9-8), rf1(7-4), rf2(3-0)   | If rf1 < rf2 then ac = 1 else ac = 0 |
| Test for Multiplication | tmul | R | 001101 | rf2(3-0)                      | If lo(0) == ‘1’ then  hi = hi + rf2; hilo >> 1 else hi, lo >> 1 |
| Test for Division       | tdiv | R | 001110 | rf2(3-0)                      | If hi >= rf2 then hi = hi - rf2; hilo << 1 with '0' else hi, lo << 1 with '1' |

### Shift Operations

Shift operations are used to shift the bits of the register to the left or right. The shift amount (shamt) is a 4-bit immediate value.

| Instruction | Mnemonic | Type | Opcode | Fields | Meaning |
|-|-|-|-|-|-|
| Shift Left Logical                     | sll  | I | 001010 | ac(9-8), rf1(7-4), shamt(3-0) | ac = rf1 << shamt |
| Shift Right Logical                    | srl  | I | 001011 | ac(9-8), rf1(7-4), shamt(3-0) | ac = rf1 >> shamt |
| Shift Right Arithmetic                 | sra  | I | 001100 | ac(9-8), rf1(7-4), shamt(3-0) | ac = signed(rf1) >> shamt |

### Move Operations

Move operations are used to move the content between bank registers.

| Instruction | Mnemonic | Type | Opcode | Fields | Meaning |
|-|-|-|-|-|-|
| Move To Low                            | mtl  | R | 001111 | ac(9-8)                       | lo = ac |
| Move From Low                          | mfl  | R | 010000 | ac(9-8)                       | ac = lo |
| Move To High                           | mth  | R | 010001 | ac(9-8)                       | hi = ac |
| Move From High                         | mfh  | R | 010010 | ac(9-8)                       | ac = hi |
| Move To AC                             | mtac | R | 010011 | ac(9-8), rf1(7-4)             | ac = rf1 |
| Move From AC                           | mfac | R | 010100 | ac(9-8), rf1(7-4)             | rf1 = ac |

### Immediate Operations

Immediate operations are used to perform arithmetic and logical operations with immediate values. This instruction format is a two address instruction, where the result is stored in the accumulator register.

| Instruction | Mnemonic | Type | Opcode | Fields | Meaning |
|-|-|-|-|-|-|
| Addition Immediate    | addi  | I | 010110 | ac(9-8), imm(7-0) | ac = ac + ((imm(7), 8) & imm) |
| Subtraction Immediate | subi  | I | 010111 | ac(9-8), imm(7-0) | ac = ac - ((imm(7), 8) & imm) |
| AND Immediate         | andi  | I | 011000 | ac(9-8), imm(7-0) | ac = ac AND ("00000000" & imm) |
| OR Immediate          | ori   | I | 011001 | ac(9-8), imm(7-0) | ac = ac OR  ("00000000" & imm) |
| XOR Immediate         | xori  | I | 011010 | ac(9-8), imm(7-0) | ac = ac XOR ("00000000" & imm) |
| NAND Immediate        | nandi | I | 011011 | ac(9-8), imm(7-0) | ac = NOT (ac AND ("00000000" & imm)) |
| NOR Immediate         | nori  | I | 011100 | ac(9-8), imm(7-0) | ac = NOT (ac OR  ("00000000" & imm)) |
| XNOR Immediate        | xnori | I | 011101 | ac(9-8), imm(7-0) | ac = NOT (ac XOR ("00000000" & imm)) |
| Load Lower Immediate  | lli   | I | 011110 | ac(9-8), imm(7-0) | ac = "00000000" & imm |
| Load Upper Immediate  | lui   | I | 011111 | ac(9-8), imm(7-0) | ac = imm & "00000000" |
| Load Signed Immediate | lsi   | I | 100000 | ac(9-8), imm(7-0) | ac = (imm(7), 8) & imm |

### Memory Access Operations

Memory access operations are used to load and store data from and to the memory.

| Instruction | Mnemonic | Type | Opcode | Fields | Meaning |
|-|-|-|-|-|-|
| Load Word Register  | lwr  | R | 100001 | ac(9-8), rf1(7-4) | ac = memory\[rf1\] |
| Store Word Register | swr  | R | 100010 | ac(9-8), rf1(7-4) | memory\[rf1\] = ac |
| Push                | push | R | 100011 | ac(9-8)           | sp = sp - 1; memory\[sp\] = ac |
| Pop                 | pop  | R | 100100 | ac(9-8)           | ac = memory\[sp\]; sp = sp + 1 |

### Control Operations

Control operations are used to control the flow of the program.

| Instruction | Mnemonic | Type | Opcode | Fields | Meaning |
|-|-|-|-|-|-|
| Jump                              | jump  | J | 100101 | imm(9-0) | pc = pc(15-10) & imm |
| Jump and Link                     | jal   | J | 100110 | imm(9-0) | lk = pc + 1; pc = pc(15-10) & imm |
| Jump Register                     | jr    | R | 100111 | rf1(7-4) | pc = rf1 |
| Jump Register and Link            | jral  | R | 101000 | rf1(7-4) | lk = pc + 1; pc = rf1 |
| Branch Greater Than Zero          | bgtz  | I | 101001 | rd(9-8), imm(7-0) | If ac > 0 then pc = (pc + 1) + imm |
| Branch Less Than Zero             | bltz  | I | 101010 | rd(9-8), imm(7-0) | If ac < 0 then pc = (pc + 1) + imm |
| Branch Equal To Zero              | beqz  | I | 101011 | rd(9-8), imm(7-0) | If ac == 0 then pc = (pc + 1) + imm |
| Branch Not Equal To Zero          | bnez  | I | 101100 | rd(9-8), imm(7-0) | If ac != 0 then pc = (pc + 1) + imm |
| Branch Greater Than Zero Register | bgtzr | R | 101101 | rd(9-8), rf1 | If ac > 0 then pc = rf |
| Branch Less Than Zero Register    | bltzr | R | 101110 | rd(9-8), rf1 | If ac < 0 then pc = rf |
| Branch Equal To Zero Register     | beqzr | R | 101111 | rd(9-8), rf1 | If ac == 0 then pc = rf |
| Branch Not Equal To Zero Register | bnezr | R | 110000 | rd(9-8), rf1 | If ac != 0 then pc = rf |
