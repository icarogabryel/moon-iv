lli &0, 20       // load 20 in ac0
mfac $0, &0      // move 20 to rf0, rf0 will point to memory address 20
lli &1, 5        // load 5 in ac1
swr $0, &1       // store 5 (ac1) in memory address 20 (rf0)
lwr &2, $0       // load 5 from memory address 20 (rf0) in ac2
push &2          // push ac2 on the stack
pop &3           // pop from the stack in ac3
