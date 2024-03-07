lsi &0, -2       // load -2 in ac0
lli &1, 7        // load 7 in ac1
mfac &0, $0      // move -2 to rf0
mfac &1, $1      // move 7 to rf1
sll &3, $0, 6    // shift ops
sll &3, $1, 6
srl &3, $0, 6
srl &3, $1, 6
sra &3, $0, 2    // shift right arithmetic
sra &3, $1, 2
mtl &0           // move ops
mth &1
mfl &1
mfh &0
mtac &0, $0
mfac &1, $1
lsi &0, -2       // load -2 in ac0
lli &1, 7        // load 7 in ac1
mfac &0, $0      // move -2 to rf0
mfac &1, $1      // move 7 to rf1
slt &2, $0, $1   // set on less than
slt &2, $1, $0
mtl &0
mth &1
tasm $0
tasm $0
tssm $0
tssm $0
