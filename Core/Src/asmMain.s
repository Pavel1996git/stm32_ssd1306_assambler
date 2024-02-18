.global asmMain   // Global declaration of the asmMain function

asmMain:   // Start of the asmMain function

   B loop   // Unconditional branch (jump) to the loop label

loop:   // Loop label

    NOP   // No Operation (idle, empty operation)
    NOP   // No Operation
    NOP   // No Operation
    WFI   // Wait for Interrupt (wait for an interrupt to occur)
    NOP   // No Operation
    NOP   // No Operation
    NOP   // No Operation

    // Infinite loop
    B loop   // Unconditional branch to the loop label

    BX LR   // Return from the function

   .end   // End of the function
