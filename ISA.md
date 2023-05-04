# COMETA 16 G2 - Instruction Set Architecture

## Logical and Arithmetic Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| No Operation                           | nope | 000000 | None | No operation |
| Addition                               | add  | 000001 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 + rf2 |
| Subtraction                            | sub  | 000010 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 - rf2 |
| Shift Left Logical                     | sll  | 000011 | ac(9-8), rf1(7-4), shamt(3-0) | ac = rf1 << shamt |
| Shift Right Logical                    | srl  | 000100 | ac(9-8), rf1(7-4), shamt(3-0) | ac = rf1 >> shamt |
| Shift Right Arithmetic                 | sra  | 000101 | ac(9-8), rf1(7-4), shamt(3-0) | ac = signed(rf1) >> shamt |
| AND                                    | and  | 000110 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 AND rf2 |
| OR                                     | or   | 000111 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 OR rf2 |
| XOR                                    | xor  | 001000 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 XOR rf2 |
| NAND                                   | nand | 001001 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 NAND rf2 |
| NOR                                    | nor  | 001010 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 NOR rf2 |
| XNOR                                   | xnor | 001011 | ac(9-8), rf1(7-4), rf2(3-0)   | ac = rf1 XNOR rf2 |
| Test, Add and Shift for Multiplication | tasm | 001100 | rf1(7-4)                      | If lo(0) == ‘1’ then  hi = hi + rf1; hi, lo >> 1 else hi, lo >> 1 |
| Test, Add and Shift for Division       | tasd | 001101 | rf1(7-4)                      | If lo(0) == ‘1’ then  hi = hi + rf1; hi, lo << 1 else hi, lo << 1 | TODO MUDAR descrição
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
| addi  | 001111 | rd(9-8), imm(7-0) | rd = rd + ((imm(7), 8) & imm) |
| subi  | 010000 | rd(9-8), imm(7-0) | rd = rd - ((imm(7), 8) & imm) |
| loi   | 010001 | rd(9-8), imm(7-0) | rd = "00000000" & imm |
| lui   | 010010 | rd(9-8), imm(7-0) | rd = imm & "00000000" |
| lis   | 010011 | rd(9-8), imm(7-0) | rd = (imm(7), 8) & imm |
| andi  | 010100 | rd(9-8), imm(7-0) | rd = rd & ("00000000" & imm) |
| ori   | 010101 | rd(9-8), imm(7-0) | rd = rd \| ("00000000" & imm) |
| xori  | 010110 | rd(9-8), imm(7-0) | rd = rd ^ ("00000000" & imm) |
| nandi | 010111 | rd(9-8), imm(7-0) | rd = ~(rd & ("00000000" & imm)) |
| nori  | 011000 | rd(9-8), imm(7-0) | rd = ~(rd \| ("00000000" & imm)) |
| xnor  | 011001 | rd(9-8), imm(7-0) | rd = ~(rd ^ ("00000000" & imm)) |

## Memory Access Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| lwr | 011010 | rd(9-8), rf1(7-4) | rd = memory[rf] |
| swr | 011011 | rd(9-8), rf1(7-4) | memory[rf] = rd |
| push | 011100 | rd(9-8) | sp = sp - 1; memory[sp] = rd |
| pop | 011101 | rd(9-8) | rd = memory[sp]; sp = sp + 1 |

## Control Operations
| Instruction | Mnemonic | Opcode | Fields | Meaning |
|-|-|-|-|-|
| j  | 011101 | imm(9-0) | pc = pc(15-10) & imm |
| jal| 100001 | imm(9-0) | lk = pc + 1; pc = pc(15-10) & imm |
| jr | 100010 | rf1(7-4) | pc = rf1 |
