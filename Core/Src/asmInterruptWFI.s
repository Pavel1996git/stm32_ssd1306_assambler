.section .data
prevB0State: .word 0

.section .text

.global asmInterruptWFI
.global asmInterruptWFI2

.equ GPIOB_CRL, 0x40010C00 // Port B configuration register
.equ GPIOB_CRL_MODE, 0x3 // Configuration mode bits for pin 0
.equ GPIOB_CRL_CNF_CLEAR, 0xC // Clear configuration bits for pin 0
.equ GPIOB_CRL_CNF, 0x8 // Configuration bits for pin 0
.equ GPIOB_ODR, 0x40010C0C // Port B data register
.equ GPIOB_ODR_ODR0, 0x1 // Data bit for pin 0
.equ GPIOB_IDR, 0x40010C08 // Port B input register
.equ GPIOB_IDR_IDR0, 0x1 // Input bit for pin 0
.equ RCC_APB1ENR, 0x4002101C // APB1 peripheral clock enable register

.equ EXTI_IMR, 0x40010400 // EXTI interrupt mask register
.equ EXTI_IMR_MR0, 0x1 // Interrupt enable bit for EXTI0 line
.equ EXTI_RTSR, 0x40010408 // Rising trigger selection register for EXTI0
.equ EXTI_RTSR_TR0, 0x1 // Rising trigger: enabled
.equ EXTI_FTSR, 0x4001040C // Falling trigger selection register for EXTI0
.equ EXTI_FTSR_TR0, 0x1 // Falling trigger: enabled
.equ EXTI_PR, 0x40010414 // EXTI pending register
.equ EXTI_PR_PR0, 0x1 // Interrupt request for EXTI0 line

.equ AFIO_EXTICR1, 0x40010008
.equ AFIO_EXTICR1_EXT0, 0x0001

.equ DBGMCU_CR, 0xE0042004 // Debug control register
.equ DBG_SLEEP, 0x1 // Debug Sleep mode enable

.equ NVIC_ISER0, 0xE000E100 // NVIC interrupt enable register
.equ NVIC_ISER0_EXTI0, 0x40 // Enable EXTI0 interrupt in NVIC

.equ RCC_APB1ENR_I2C1EN, 0x200000 // I2C1 clock enable bit in APB1
.equ RCC_APB2ENR, 0x40021018 // APB2 peripheral clock enable register
.equ RCC_APB2ENR_IOPBEN, 0x8 // Port B clock enable bit in APB2
.equ RCC_APB2ENR_AFIOEN, 0x1 // AFIO clock enable bit in APB2

.equ I2C1_CR1, 0x40005400 // I2C1 control register
.equ I2C1_CR1_SWRST, 0x8000 // Software reset bit for I2C1
.equ I2C1_CR1_PE, 0x1 // I2C1 enable bit
.equ I2C1_CR1_ACK, 0x400 // Acknowledge enable bit
.equ I2C1_CR1_START, 0x100 // Start generation bit
.equ I2C1_CR1_STOP, 0x200 // Stop generation bit

.equ I2C1_CR2, 0x40005404 // I2C1 Configuration Register
.equ I2C1_CR2_FREQ, 0x4 // Frequency setting bits
.equ I2C1_CCR, 0x4000541C // I2C1 Clock Control Register
.equ I2C1_CCR_CCR, 0x28 // Coefficient of division setting bits for frequency
.equ I2C1_TRISE, 0x40005420 // I2C1 Timing setup control register
.equ I2C1_TRISE_TRISE, 0x9 // Timing setup time setting bits
.equ I2C1_DR, 0x40005410 // I2C1 Data Register
.equ I2C1_SR1, 0x40005414 // I2C1 Status Register (byte 1)
.equ I2C1_SR1_SB, 0x1 // Start bit
.equ I2C1_SR1_ADDR, 0x2 // Address bit
.equ I2C1_SR1_TxE, 0x80 // Data byte transmission bit
.equ I2C1_SR1_BTF, 0x4 // Byte transfer finished bit
.equ I2C1_SR2, 0x40005418 // I2C1 Status Register (byte 2)
.equ I2C1_SR2_BUSY, 0x2 // Bus busy bit

.equ SSD_ADRES_SLAVE, 0x78 // SSD device address
.equ SSD_MODE, 0x0 // SSD control mode (MODE bits)
.equ SSD_CONTRL_BYTE_COMMAND, 0x0 // Control byte for sending command to SSD
.equ SSD_CONTRL_BYTE_DATA, 0x40 // Control byte for sending data to SSD (MODE bits)

.thumb_func
.global EXTI0_IRQHandler
.type EXTI0_IRQHandler, %function
EXTI0_IRQHandler:
    //CPSID i                  // Disable interrupts
    MOV R5, LR              // Save LR value in register R5
    PUSH {R0, R1, R2, R3}   // Save registers R0-R3
// Load the previous state of B0
LDR R3, =prevB0State
LDR R3, [R3]

ldr r1, =GPIOB_IDR    // Load the address of the IDR register of port B into register r1
ldr r2, [r1]          // Load the value of IDR into register r2
LDR r4, =GPIOB_IDR_IDR0
and r4, r4, r2
CMP r4, r3            // Perform the test instruction AND, result is not saved
bne EndInterruptHandler       // Branch if flag 0 is not set
LDR R4, =0x1
eor R3, R3, r4   // Invert the bit
LDR R1, =prevB0State
STR r3, [r1]

    // Wait for I2C bus to be not busy
    WaitForI2CNotBusy:
ldr r1, =I2C1_SR2    // Load the address of the SR2 register into register r1
LDR R2, [r1]          // Load the value of the SR2 register into R2
ldr r1, =I2C1_SR2_BUSY  // Load the address of the BUSY bit into register r1

tst R2, r1            // Check the BUSY bit
BNE WaitForI2CNotBusy // Branch if BUSY bit is set

ldr r1, =I2C1_CR1     // Load the address of the CR1 register into register r1
ldr r2, =I2C1_CR1_START // Load the value of START into register r2
BL asmSetRegistr      // Set the START bit in the CR1 register

ldr r1, =I2C1_SR1     // Load the address of the SR1 register into register r1
ldr r2, =I2C1_SR1_SB  // Load the value of SB into register r2
BL asmWhileBeq        // Wait for the start condition to be generated

ldr r1, =I2C1_DR      // Load the address of the DR register into register r1
ldr r2, =SSD_ADRES_SLAVE  // Load the value of the device address into register r2
STR r2, [r1]          // Write the device address to the DR register

ldr r1, =I2C1_SR1     // Load the address of the SR1 register into register r1
ldr r2, =I2C1_SR1_ADDR  // Load the value of ADDR into register r2
BL asmWhileBeq        // Wait for the address transmission to complete

ldr r1, =I2C1_SR1     // Load the address of the SR1 register into register r1
ldr r2, [r1]          // Load the value of the SR1 register into r2
ldr r1, =I2C1_SR2     // Load the address of the SR2 register into register r1
ldr r2, [r1]          // Load the value of the SR2 register into r2

ldr r1, =I2C1_DR      // Load the address of the DR register into register r1
ldr r2, =SSD_CONTRL_BYTE_COMMAND  // Load the value of the control command into register r2
STR r2, [r1]          // Write the control command to the DR register

ldr r1, =I2C1_SR1     // Load the address of the SR1 register into register r1
ldr r2, =I2C1_SR1_TxE // Load the value of TxE into register r2
BL asmWhileBeq        // Wait for the completion of command transmission

ldr r7, =0x20         // Load the value 0x20 into register r7
BL asmSsdSendCommand  // Send command
ldr r7, =0x2          // Load the value 0x2 into register r7
BL asmSsdSendCommand  // Send command
ldr r7, =0xB1         // Load the value 0xB1 into register r7
BL asmSsdSendCommand  // Send command
ldr r7, =0x12         // Load the value 0x12 into register r7
BL asmSsdSendCommand  // Send command

ldr r1, =I2C1_CR1     // Load the address of the CR1 register into register r1
ldr r2, =I2C1_CR1_STOP // Load the value of STOP into register r2
BL asmSetRegistr      // Set the STOP bit in the CR1 register

ldr r1, =I2C1_CR1     // Load the address of the CR1 register into register r1
ldr r2, =I2C1_CR1_START  // Load the value of START into register r2
BL asmSetRegistr      // Set the START bit in the CR1 register

ldr r1, =I2C1_SR1     // Load the address of the SR1 register into register r1
ldr r2, =I2C1_SR1_SB  // Load the value of SB into register r2
BL asmWhileBeq        // Wait for the start condition to be generated

ldr r1, =I2C1_DR      // Load the address of the DR register into register r1
ldr r2, =SSD_ADRES_SLAVE  // Load the value of the device address into register r2
STR r2, [r1]          // Write the device address to the DR register

ldr r1, =I2C1_SR1     // Load the address of the SR1 register into register r1
ldr r2, =I2C1_SR1_ADDR  // Load the value of ADDR into register r2
BL asmWhileBeq        // Wait for the address transmission to complete

ldr r1, =I2C1_SR1     // Load the address of the SR1 register into register r1
ldr r2, [r1]          // Load the value of the SR1 register into r2
ldr r1, =I2C1_SR2     // Load the address of the SR2 register into register r1
ldr r2, [r1]          // Load the value of the SR2 register into r2

ldr r1, =I2C1_DR      // Load the address of the DR register into register r1
ldr r2, =SSD_CONTRL_BYTE_DATA  // Load the value of the control command into register r2
STR r2, [r1]          // Write the control command to the DR register

ldr r1, =I2C1_SR1     // Load the address of the SR1 register into register r1
ldr r2, =I2C1_SR1_TxE // Load the value of TxE into register r2
BL asmWhileBeq        // Wait for the completion of command transmission

ldr r1, =GPIOB_IDR    // Load the address of the IDR register of port B into register r1
ldr r2, [r1]          // Load the value of IDR into register r2
ldr r3, =GPIOB_IDR_IDR0  // Load the value 0x1 into register r3
tst r2, r3            // Execute the test instruction AND, result is not saved
beq LabelIfZero       // Branch if the result is equal to 0 (bit is not set)
ldr r0, =dataHello    // Load the address of the array into register r0
mov r4, #0            // Initialize the index

loop_for:             // Loop to iterate through the array
ldrb r7, [r0, r4]    // Load a byte from the array at the address (r0 + r1) into register r2
BL asmSsdSendCommand  // Send the byte
add r4, r4, #1        // Increment the index
cmp r4, #50           // Check for the end of the array (if index >= array size)
ble loop_for

b EndIf               // Jump to the EndIf label

LabelIfZero:          // Code for the case when the bit is not set (executes if the bit is not set)

ldr r0, =dataVOID     // Load the address of the array into register r0
mov r4, #0            // Initialize the index
b loop_for            // Jump to the loop for iterating through the array

EndIf:                // End of the condition

ldr r1, =I2C1_CR1     // Load the address of the CR1 register into register r1
ldr r2, =I2C1_CR1_STOP // Load the value of STOP into register r2
BL asmSetRegistr      // Set the STOP bit in the CR1 register

EndInterruptHandler:
ldr r1, =EXTI_PR      // Load the address of the PR register into register r1
ldr r2, =EXTI_PR_PR0  // Load the value of PR0 into register r2
BL asmSetRegistr      // Set the PR0 bit in the PR register

// End of the handler

// CPSIE i  // Enable interrupts
POP {R0, R1, R2, R3}     // Restore registers from the stack
MOV LR, R5               // Restore the value of LR
BX LR                    // Exit the handler

// Entry point
asmInterruptWFI:
MOV R6, LR  // Save the value of LR in register R5

// Enable clock for the external interrupt controller
ldr r1, =RCC_APB2ENR   // Load the address of the RCC_APB1ENR register into register r1
ldr r2, =RCC_APB2ENR_AFIOEN   // Load the value of RCC_APB2ENR_AFIOEN into register r2
BL asmSetRegistr   // Call the function to set the bit in the register

// Configure port B
ldr r1, =GPIOB_CRL   // Load the address of the GPIOB_CRL register into register r1
ldr r2, =GPIOB_CRL_MODE   // Load the value of GPIOB_CRL_MODE into register r2
BL asmResetRegistr   // Call the function to reset bits in the register

ldr r1, =GPIOB_CRL   // Load the address of the GPIOB_CRL register into register r1
ldr r2, =GPIOB_CRL_CNF_CLEAR   // Load the value of GPIOB_CRL_CNF_CLEAR into register r2
BL asmResetRegistr   // Call the function to reset bits in the register

ldr r1, =GPIOB_CRL   // Load the address of the GPIOB_CRL register into register r1
ldr r2, =GPIOB_CRL_CNF   // Load the value of GPIOB_CRL_CNF into register r2
BL asmSetRegistr   // Call the function to set bits in the register

ldr r1, =GPIOB_ODR   // Load the address of the GPIOB_ODR register into register r1
ldr r2, =GPIOB_ODR_ODR0   // Load the value of GPIOB_ODR_ODR0 into register r2
BL asmSetRegistr   // Call the function to set a bit in the register

// Configure external interrupt EXTI0
ldr r1, =EXTI_IMR   // Load the address of the EXTI_IMR register into register r1
ldr r2, =EXTI_IMR_MR0   // Load the value of EXTI_IMR_MR0 into register r2
BL asmSetRegistr   // Call the function to set a bit in the register

ldr r1, =EXTI_RTSR   // Load the address of the EXTI_RTSR register into register r1
ldr r2, =EXTI_RTSR_TR0   // Load the value of EXTI_RTSR_TR0 into register r2
BL asmSetRegistr   // Call the function to set a bit in the register

ldr r1, =EXTI_FTSR   // Load the address of the EXTI_FTSR register into register r1
ldr r2, =EXTI_FTSR_TR0   // Load the value of EXTI_FTSR_TR0 into register r2
BL asmSetRegistr   // Call the function to set a bit in the register

// Enable interrupt
ldr r1, =NVIC_ISER0   // Load the address of the NVIC_ISER0 register into register r1
ldr r2, =NVIC_ISER0_EXTI0   // Load the value of NVIC_ISER0_EXTI0 into register r2
BL asmSetRegistr   // Call the function to set a bit in the register

LDR R0, =AFIO_EXTICR1      // Load the address of the AFIO_EXTICR1 register
LDR R1, [R0]               // Load the current value of the register
LDR R2, =1
ORR R1, R1, R2
// Set EXTI0 bits
STR R1, [R0]               // Save the new value to the AFIO_EXTICR1 register

// Enable debugging mode
ldr r1, =DBGMCU_CR   // Load the address of the DBGMCU_CR register into register r1
ldr r2, =DBG_SLEEP   // Load the value of DBG_SLEEP into register r2
BL asmSetRegistr   // Call the function to set a bit in the register
MOV LR, R6   // Restore the value of LR from register R5
BX LR   // Return from the interrupt


