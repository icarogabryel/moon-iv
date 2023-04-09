## Logical and Arithmetic Operations
| Instruction | CODOP | Fields | Description |
|-|-|-|-|
| nop  | 000000 | None                          | No operation |
| add  | 000001 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = rf1 + rf2 |
| sub  | 000010 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = rf1 - rf2 |
| sll  | 000011 | rd(9-8), rf1(7-4), shamt(3-0) | rd = rf1 << shamt |
| srl  | 000100 | rd(9-8), rf1(7-4), shamt(3-0) | rd = rf1 >> shamt |
| sra  | 000101 | rd(9-8), rf1(7-4), shamt(3-0) | rd = signed(rf1) >> shamt |
| and  | 000110 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = rf1 & rf2 |
| or   | 000111 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = rf1 \| rf2 |
| xor  | 001000 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = rf1 ^ rf2 |
| nand | 001001 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = ~(rf1 & rf2) |
| nor  | 001010 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = ~(rf1 \| rf2) |
| xnor | 001011 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = ~(rf1 ^ rf2) |
| mfac | 001100 | rd(9-8), rf1(7-4)             | rf1 = rd |
| mtac | 001101 | rd(9-8), rf1(7-4)             | rd = rf1 |
| slt  | 001110 | rd(9-8), rf1(7-4), rf2(3-0)   | rd = 1 if (rf1 < rf2); else rd = 0 |

## Immediate Operations
| Instruction | CODOP | Fields | Description |
|-|-|-|-|
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
| Instruction | CODOP | Fields | Description |
|-|-|-|-|
| lwr | 011010 | rd(9-8), rf1(7-4) | rd = memory[rf] |
| swr | 011011 | rd(9-8), rf1(7-4) | memory[rf] = rd |
| push | 011100 | rd(9-8) | sp = sp - 1; memory[sp] = rd |
| pop | 011101 | rd(9-8) | rd = memory[sp]; sp = sp + 1 |

## Control Operations
| Instruction | CODOP | Fields | Description |
|-|-|-|-|
| jmp  | 011101 | imm(9-0) | pc = pc(15-10) & imm |
| jmpal| 100001 | imm(9-0) | lk = pc + 1; pc = pc(15-10) & imm |
| jmpr | 100010 | rf1(7-4) | pc = rf1 |
