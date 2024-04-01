lli &0, 7        // load 7 in ac0 (Divisor)
mfac &0, $0      // move 7 to rf0
lli &1, 25       // load 25 in ac1 (Dividend)
mtl &1           // move 25 to low register
tdiv $0          // divide 25 by 7 (Op repeated 17 times)
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
tdiv $0
mfh &2           // move high register to ac2
mfac &2, $1      // move ac2 to rf1
srl &2, $1, 1    // shift right rf1 (Real rest)
