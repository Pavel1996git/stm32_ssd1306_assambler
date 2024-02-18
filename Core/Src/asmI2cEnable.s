.global asmI2cEnable
.global asmSsdSendCommand

.equ RCC_APB1ENR, 0x4002101C          // Register for controlling peripheral clock on APB1 bus
.equ RCC_APB1ENR_I2C1EN, 0x200000     // Bit for enabling I2C1 clock in RCC_APB1ENR register
.equ RCC_APB2ENR, 0x40021018          // Register for controlling peripheral clock on APB2 bus
.equ RCC_APB2ENR_IOPBEN, 0x8          // Bit for enabling GPIOB clock in RCC_APB2ENR register
.equ RCC_APB2ENR_AFIOEN, 0x1          // Bit for enabling alternative functions clock in RCC_APB2ENR register

.equ GPIOB_CRL, 0x40010C00           // Register for low pins configuration of GPIOB port
.equ GPIOB_CRL_MODE, 0xCC000000      // Mask for setting mode of pins in GPIOB_CRL register
.equ GPIOB_CRL_CNF, 0x33000000       // Mask for setting configuration of pins in GPIOB_CRL register
.equ GPIOB_ODR, 0x40010C0C           // Register for controlling outputs of GPIOB port
.equ GPIOB_ODR_ODR, 0xC0             // Mask for setting values on GPIOB port outputs

.equ I2C1_CR1, 0x40005400            // Control Register 1 for I2C1
.equ I2C1_CR1_SWRST, 0x8000          // Bit for resetting I2C1 in I2C1_CR1 register
.equ I2C1_CR1_PE, 0x1                // Bit for enabling I2C1 in I2C1_CR1 register
.equ I2C1_CR1_ACK, 0x400             // Bit for acknowledging the reception (ACK) in I2C1_CR1 register
.equ I2C1_CR1_START, 0x100           // Bit for generating a start condition in I2C1_CR1 register
.equ I2C1_CR1_STOP, 0x200            // Bit for generating a stop condition in I2C1_CR1 register
.equ I2C1_CR2, 0x40005404            // Control Register 2 for I2C1
.equ I2C1_CR2_FREQ, 0x4              // Bit for setting the frequency of I2C1 in I2C1_CR2 register
.equ I2C1_CCR, 0x4000541C            // Control Register for configuring data transfer speed in I2C1
.equ I2C1_CCR_CCR, 0x28              // Bit for setting data transfer speed in I2C1_CCR register
.equ I2C1_TRISE, 0x40005420          // Register for configuring signal rise time in I2C1
.equ I2C1_TRISE_TRISE, 0x9           // Bit for setting signal rise time in I2C1_TRISE register
.equ I2C1_DR, 0x40005410             // Data Register for I2C1
.equ I2C1_SR1, 0x40005414            // Status Register 1 for I2C1
.equ I2C1_SR1_SB, 0x1                // Bit for generating start condition in I2C1_SR1 register
.equ I2C1_SR1_ADDR, 0x2              // Bit for awaiting device address in I2C1_SR1 register
.equ I2C1_SR1_TxE, 0x80              // Bit for data byte transmission readiness in I2C1_SR1 register
.equ I2C1_SR1_BTF, 0x4               // Bit for end of byte transmission in I2C1_SR1 register
.equ I2C1_SR2, 0x40005418            // Status Register 2 for I2C1
.equ I2C1_SR2_BUSY, 0x2              // Bit for I2C1 bus busy status in I2C1_SR2 register

.equ SSD_ADRES_SLAVE, 0x78           // SSD1306 device address (bit 7:0)
.equ SSD_MODE, 0x0                   // SSD1306 device mode
.equ SSD_CONTRL_BYTE_COMMAND, 0x0    // Control byte for command transmission to SSD1306
.equ SSD_CONTRL_BYTE_DATA, 0x40      // Control byte for data transmission to SSD1306

asmI2cEnable:
    MOV R5, LR                       // Save the value of LR in register R5
    ldr r1, =RCC_APB1ENR              // Load the address of RCC_APB1ENR into register r1
    ldr r2, =RCC_APB1ENR_I2C1EN       // Load the value RCC_APB1ENR_I2C1EN into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =RCC_APB2ENR              // Load the address of RCC_APB2ENR into register r1
    ldr r2, =RCC_APB2ENR_IOPBEN        // Load the value RCC_APB2ENR_IOPBEN into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function


    ldr r1, =GPIOB_CRL                // Load the address of GPIOB_CRL into register r1
    ldr r2, =GPIOB_CRL_MODE           // Load the value of GPIOB_CRL_MODE into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =GPIOB_CRL                // Load the address of GPIOB_CRL into register r1
    ldr r2, =GPIOB_CRL_CNF            // Load the value of GPIOB_CRL_CNF into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =GPIOB_ODR                // Load the address of GPIOB_ODR into register r1
    ldr r2, =GPIOB_ODR_ODR            // Load the value of GPIOB_ODR_ODR into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =I2C1_CR1                 // Load the address of I2C1_CR1 into register r1
    ldr r2, =I2C1_CR1_SWRST           // Load the value of I2C1_CR1_SWRST into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =I2C1_CR1                 // Load the address of I2C1_CR1 into register r1
    ldr r2, =I2C1_CR1_SWRST           // Load the value of I2C1_CR1_SWRST into register r2
    BL asmResetRegistr               // Call the asmResetRegistr function

    ldr r1, =I2C1_CR2                 // Load the address of I2C1_CR2 into register r1
    ldr r2, =I2C1_CR2_FREQ            // Load the value of I2C1_CR2_FREQ into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =I2C1_CCR                 // Load the address of I2C1_CCR into register r1
    ldr r2, =I2C1_CCR_CCR             // Load the value of I2C1_CCR_CCR into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =I2C1_TRISE               // Load the address of I2C1_TRISE into register r1
    ldr r2, =I2C1_TRISE_TRISE         // Load the value of I2C1_TRISE_TRISE into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =I2C1_CR1                 // Load the address of I2C1_CR1 into register r1
    ldr r2, =I2C1_CR1_PE              // Load the value of I2C1_CR1_PE into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =I2C1_CR1                 // Load the address of I2C1_CR1 into register r1
    ldr r2, =I2C1_CR1_ACK             // Load the value of I2C1_CR1_ACK into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

asmSsdEnable:
    ldr r1, =I2C1_CR1                 // Load the address of I2C1_CR1 into register r1
    ldr r2, =I2C1_CR1_START           // Load the value of I2C1_CR1_START into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    ldr r1, =I2C1_SR1                 // Load the address of I2C1_SR1 into register r1
    ldr r2, =I2C1_SR1_SB              // Load the value of I2C1_SR1_SB into register r2
    BL asmWhileBeq                   // Call the asmWhileBeq function

    ldr r1, =I2C1_DR                  // Load the address of I2C1_DR into register r1
    ldr r2, =SSD_ADRES_SLAVE          // Load the value of SSD_ADRES_SLAVE into register r2
    STR r2, [r1]                      // Write the value of r2 into the data register r1

    ldr r1, =I2C1_SR1                 // Load the address of I2C1_SR1 into register r1
    ldr r2, =I2C1_SR1_ADDR            // Load the value of I2C1_SR1_ADDR into register r2
    BL asmWhileBeq                   // Call the asmWhileBeq function

    ldr r1, =I2C1_SR1                 // Load the address of I2C1_SR1 into register r1
    ldr r2, [r1]                      // Load the value stored at address r1 into register r2
    ldr r1, =I2C1_SR2                 // Load the address of I2C1_SR2 into register r1
    ldr r2, [r1]                      // Load the value stored at address r1 into register r2

    ldr r1, =I2C1_DR                  // Load the address of I2C1_DR into register r1
    ldr r2, =SSD_CONTRL_BYTE_COMMAND  // Load the value of SSD_CONTRL_BYTE_COMMAND into register r2
    STR r2, [r1]                      // Write the value of r2 into the data register r1

    ldr r1, =I2C1_SR1                 // Load the address of I2C1_SR1 into register r1
    ldr r2, =I2C1_SR1_TxE             // Load the value of I2C1_SR1_TxE into register r2
    BL asmWhileBeq                   // Call the asmWhileBeq function

    ldr r7, =0xA8                     // Load the value 0xA8 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x3F                     // Load the value 0x3F into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function
    ldr r7, =0xD3                     // Load the value 0xD3 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x00                     // Load the value 0x00 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x40                     // Load the value 0x40 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0xC0                     // Load the value 0xC0 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0xDA                     // Load the value 0xDA into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x02                     // Load the value 0x02 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x81                     // Load the value 0x81 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x7F                     // Load the value 0x7F into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0xA4                     // Load the value 0xA4 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0xA6                     // Load the value 0xA6 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0xD5                     // Load the value 0xD5 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x80                     // Load the value 0x80 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x8d                     // Load the value 0x8D into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x14                     // Load the value 0x14 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x20                     // Load the value 0x20 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x2                      // Load the value 0x02 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0xB1                     // Load the value 0xB1 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0x12                     // Load the value 0x12 into register r7
    BL asmSsdSendCommand              // Call the asmSsdSendCommand function

    ldr r7, =0xAF                     // Load the value 0xAF into register r3
    ldr r1, =I2C1_SR1                 // Load the address of I2C1_SR1 into register r1
    ldr r2, =I2C1_SR1_BTF             // Load the value of I2C1_SR1_BTF into register r2
    BL asmWhileBeq                   // Call the asmWhileBeq function

    ldr r1, =I2C1_DR                  // Load the address of I2C1_DR into register r1
    STR r7, [r1]                      // Write the value of r3 into the data register r1

    ldr r1, =I2C1_CR1                 // Load the address of I2C1_CR1 into register r1
    ldr r2, =I2C1_CR1_STOP            // Load the value of I2C1_CR1_STOP into register r2
    BL asmSetRegistr                 // Call the asmSetRegistr function

    // Code block to wait until the I2C bus becomes idle
WaitForI2CNotBusy:

    ldr r1, =I2C1_SR2                 // Load the value of the SR2 register into r2
    LDR R2, [r1]

    ldr r1, =I2C1_SR2_BUSY            // Load the BUSY bit in the SR2 register into r1

    tst R2, r1                         // Check if the BUSY bit is set

    BNE WaitForI2CNotBusy              // Branch to WaitForI2CNotBusy label if the BUSY bit is set

    // Restore the value of LR and exit the procedure
    MOV LR, R5
    BX LR

// Procedure to send a command to the SSD display
asmSsdSendCommand:

    MOV R6, LR                         // Save the current value of LR
    // Wait until the I2C transmission buffer becomes available
    ldr r1, =I2C1_SR1
    ldr r2, =I2C1_SR1_TxE
    BL asmWhileBeq

    // Write the command to the I2C data register
    ldr r1, =I2C1_DR
    STR r7, [r1]

    // Wait for the completion of the command transmission
    ldr r1, =I2C1_SR1
    ldr r2, =I2C1_SR1_BTF
    BL asmWhileBeq

    // Restore the value of LR and exit the procedure
    MOV LR, R6
    BX LR
    .end
