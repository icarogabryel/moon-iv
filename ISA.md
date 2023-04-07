## Logical and arithmetic operations

| Instruction | CODOP | fields | Description |
|-|-|-|-|
| nop | 000000 | None| No operation |
| add | 000001 | rd(9-8), rf1(7-4), rf2(3-0) | rd = rf1 + rf2 |
| sub | 000010 | rd(9-8), rf1(7-4), rf2(3-0) | rd = rf1 - rf2 |
| and | 000011 | rd(9-8), rf1(7-4), rf2(3-0) | rd = rf1 & rf2 |
| or | 000100 | rd(9-8), rf1(7-4), rf2(3-0) | rd = rf1 \| rf2 |
| xor | 000101 | rd(9-8), rf1(7-4), rf2(3-0) | rd = rf1 ^ rf2 |
| sll | 000110 | rd(9-8), rf1(7-4), shift(3-0) | rd = rf1 << shift |
| srl | 000111 | rd(9-8), rf1(7-4), shift(3-0) | rd = rf1 >> shift |
| sra | 001000 | rd(9-8), rf1(7-4), shift(3-0) | rd = rf1 >> shift |

## Immediate operations

## Memory operations