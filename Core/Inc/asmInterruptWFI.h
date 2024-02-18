#ifndef APPLICATION_USER_CORE_ASM_INTERRUPT_WFI_H_
#define APPLICATION_USER_CORE_ASM_INTERRUPT_WFI_H_

extern void asmInterruptWFI(void);
extern void asmInterruptWFI2(void);
extern __attribute__((interrupt)) void EXTI0_IRQHandler(void);

#endif /* APPLICATION_USER_CORE_ASM_INTERRUPT_WFI_H_ */
