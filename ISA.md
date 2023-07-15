# COMETA MK II - Instruction Set Architecture

## Logical and Arithmetic Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| No Operation                           | nope | 000000 | None | No operation |
| Addition                               | add  | 000001 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 + rf2 |
| Subtraction                            | sub  | 000010 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 - rf2 |
| NOT                                    | not  | 000011 | ac(9-8), rf1(7-4)             | ac = NOT rf1 |
| AND                                    | and  | 000100 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 AND rf2 |
| OR                                     | or   | 000101 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 OR rf2 |
| XOR                                    | xor  | 001000 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 XOR rf2 |
| NAND                                   | nand | 000111 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 NAND rf2 |
| NOR                                    | nor  | 001010 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 NOR rf2 |
| XNOR                                   | xnor | 001011 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 XNOR rf2 |
| Shift Left Logical                     | sll  | 000011 | ac(9-8), rf1(7-4), shamt(3-0) | ac = rf1 << shamt |
| Shift Right Logical                    | srl  | 000100 | ac(9-8), rf1(7-4), shamt(3-0) | ac = rf1 >> shamt |
| Shift Right Arithmetic                 | sra  | 000101 | ac(9-8), rf1(7-4), shamt(3-0) | ac = signed(rf1) >> shamt |
| Test, Add and Shift for Multiplication | tasm | 001100 | rf1(7-4)                      | If lo(0) == ‘1’ then  hi = hi + rf1; hi, lo >> 1 else hi, lo >> 1 |
| Test, Sub and Shift for Multiplication | tasd | 001101 | rf1(7-4)                      | If lo(0) == ‘1’ then  hi = hi - rf1; hi, lo >> 1 else hi, lo >> 1 |
| Move To Low                            | mtl  | 001110 | ac(9-8)                       | lo = ac |
| Move From Low                          | mfl  | 001111 | ac(9-8)                       | ac = lo |
| Move To High                           | mth  | 010000 | ac(9-8)                       | hi = ac |
| Move From High                         | mfh  | 010001 | ac(9-8)                       | ac = hi |
| Move To AC                             | mtac | 010010 | ac(9-8), rf1(7-4)             | rf1 = ac |
| Move From AC                           | mfac | 010011 | ac(9-8), rf1(7-4)             | ac = rf1 |
| Set on Less Than                       | slt  | 010100 | ac(9-8), rf1(7-4), rf2(3-0)   | If rf1 < rf2 then ac = 1 else ac = 0 |

## Immediate Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| Addition Immediate    | addi  | 001111 | ac(9-8), imm(7-0) | ac = ac + ((imm(7), 8) & imm) |
| Subtraction Immediate | subi  | 010000 | ac(9-8), imm(7-0) | ac = ac - ((imm(7), 8) & imm) |
| AND Immediate         | andi  | 010100 | ac(9-8), imm(7-0) | ac = ac AND ("00000000" & imm) |
| OR Immediate          | ori   | 010101 | ac(9-8), imm(7-0) | ac = ac OR  ("00000000" & imm) |
| XOR Immediate         | xori  | 010110 | ac(9-8), imm(7-0) | ac = ac XOR ("00000000" & imm) |
| NAND Immediate        | nandi | 010111 | ac(9-8), imm(7-0) | ac = NOT (ac AND ("00000000" & imm)) |
| NOR Immediate         | nori  | 011000 | ac(9-8), imm(7-0) | ac = NOT (ac OR  ("00000000" & imm)) |
| XNOR Immediate        | xnori | 011001 | ac(9-8), imm(7-0) | ac = NOT (ac XOR ("00000000" & imm)) |
| Load Lower Immediate  | lli   | 010001 | ac(9-8), imm(7-0) | ac = "00000000" & imm |
| Load Upper Immediate  | lui   | 010010 | ac(9-8), imm(7-0) | ac = imm & "00000000" |
| Load Signed Immediate | lsi   | 010011 | ac(9-8), imm(7-0) | ac = (imm(7), 8) & imm |

## Memory Access Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| Load Word Register  | lwr  | 011010 | ac(9-8), rf1(7-4) | ac = memory\[rf1\] |
| Store Word Register | swr  | 011011 | ac(9-8), rf1(7-4) | memory\[rf1\] = ac |
| Push                | push | 011100 | ac(9-8)           | sp = sp - 1; memory\[sp\] = ac |
| Pop                 | pop  | 011101 | ac(9-8)           | ac = memory\[sp\]; sp = sp + 1 |

## Control Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| Jump                   | jump | 011101 | imm(9-0) | pc = pc(15-10) & imm |
| Jump and Link          | jal  | 100001 | imm(9-0) | lk = pc + 1; pc = pc(15-10) & imm |
| Jump Register          | jr   | 100010 | rf1(7-4) | pc = rf1 |
| Jump Greater Than Zero | jgtz | 100011 | rd(9-8), imm(7-0) | If ac > 0 then pc = (pc + 1) + imm |
| Jump Less Than Zero    | jltz | 100100 | rd(9-8), imm(7-0) | If ac < 0 then pc = (pc + 1) + imm |
| Jump Equal To Zero     | jeqz | 100101 | rd(9-8), imm(7-0) | If ac == 0 then pc = (pc + 1) + imm |
| Jump Not Equal To Zero | jnez | 100110 | rd(9-8), imm(7-0) | If ac != 0 then pc = (pc + 1) + imm |
