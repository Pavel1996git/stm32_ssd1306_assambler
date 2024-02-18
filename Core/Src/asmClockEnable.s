// Global label for the HSI generator enable function
.global asmClockEnable
// Global label for the function to set a bit in the register
.global asmSetRegistr
// Global label for the function to reset a bit in the register
.global asmResetRegistr
// Global label for the function waiting for a bit to be set in the register
.global asmWhileBeq

// Address and bits of the clock control register (RCC_CR)
.equ RCC_CR, 0x40021000
.equ RCC_CR_HSION, 0x01        // Mask for enabling the HSI generator
.equ RCC_CR_HSIRDY, 0x02       // Mask for the HSI generator ready bit

// Address and bits of the clock configuration register (RCC_CFGR)
.equ RCC_CFGR, 0x40021004
.equ RCC_CFGR_SW, 0x00         // Mask for the system clock source selection bits
.equ RCC_CFGR_SWS, 0x00        // Mask for the current system clock source bits
.equ RCC_CFGR_SWS_MASK, 0x0C   // Mask for the status bits of the system clock selection

asmSetRegistr:

    LDR R3, [R1]            // Load the current value of the register into R3
    ORR R3, R3, R2          // Set the GPIOAEN_BIT
    STR R3, [R1]            // Write the new value back to the register
    // Restore the LR register from the stack and return
    BX LR

asmResetRegistr:

    LDR R3, [R1]            // Load the current value of the register into R3
    // Invert the mask R2
    // MVN R2, R2
    // Apply the BIC operation to reset the bits
    BIC R3, R3, R2
    // Save the updated value back to GPIOB->CRL
    STR R3, [R1]
    // Restore the LR register from the stack and return
    BX LR

// Entry point for the assembler code
asmWhileBeq:
    // LDR R3, [R1]  // Load the value of register R1 into register R3
    // CMP R3, R2           // Compare with R2
    // BEQ asmWhileBeq              // Jump to the asmWhileBeq label if the equality condition is met
    // BX LR // restore the LR register from the stack and return

    LDR R3, [R1]            // Load the value of register R1 into register R3
    AND R3, R3, R2          // Check bit 1
    BEQ asmWhileBeq         // Jump to the loop label if bit 1 is not set
    BX LR                   // Restore the LR register from the stack and return

asmClockEnable:
    // Load the address of the clock control register (RCC_CR)
    LDR R0, =RCC_CR
    // Load the mask value for enabling the HSI generator (RCC_CR_HSION)
    LDR R1, =RCC_CR_HSION
    // Save the value from R1 to the address in R0 (enable HSI)
    STR R1, [R0]

wait_HSI:
    // Load the value for the HSI ready bit mask (RCC_CR_HSIRDY)
    LDR R1, =RCC_CR_HSIRDY
    // Load the value at the address in R0 (RCC_CR)
    LDR R2, [R0]
    // Check the HSI ready bit in R2
    TST R1, R2
    // Jump to wait_HSI if HSI is not ready
    BEQ wait_HSI

    // Load the address of the clock configuration register (RCC_CFGR)
    LDR R0, =RCC_CFGR
    // Load the mask value for the system clock source selection bits (RCC_CFGR_SW)
    LDR R1, =RCC_CFGR_SW
    // Save the value from R1 to the address in R0 (select HSI as the system clock source)
    STR R1, [R0]

wait_SW:
    // Load the value at the address in R0 (RCC_CFGR)
    LDR R2, [R0]
    // Load the mask value for the system clock selection status bits (RCC_CFGR_SWS_MASK)
    LDR R1, =RCC_CFGR_SWS_MASK
    // Apply bitwise AND to mask other bits and keep only the SWS bits
    AND R2, R2, R1
    // Load the mask value for the current system clock source bits (RCC_CFGR_SWS)
    LDR R1, =RCC_CFGR_SWS
    // Compare the SWS bits with the required value
    CMP R2, R1
    // Jump to wait_SW if the system clock switch is not ready
    BNE wait_SW

    BX LR
    .end
