/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include <asmClockEnable.h>
#include <asmI2cEnable.h>
#include <asmInterruptWFI.h>
#include <asmMain.h>
uint32_t start_time, end_time, elapsed_time;
// Data array containing the bitmap representing the word "HELLO" for ssd1306
extern uint8_t dataHello[] = {
    0x00, 0xFF, 0xFF, 0x18, 0x18, 0x18, 0xFF, 0xFF, 0x00, 0x00,
    0x00, 0xFF, 0xFF, 0xDB, 0xDB, 0xDB, 0xDB, 0xDB, 0x00, 0x00,
    0x00, 0xFF, 0xFF, 0x03, 0x03, 0x03, 0x03, 0x03, 0x00, 0x00,
    0x00, 0xFF, 0xFF, 0x03, 0x03, 0x03, 0x03, 0x03, 0x00, 0x00,
    0x00, 0x18, 0x66, 0xC3, 0x81, 0x81, 0xC3, 0x66, 0x18, 0x00
};
// Data array containing an empty bitmap for ssd1306
extern uint8_t dataVOID[] = {
    0x00, 0x00, 0x00, 0x00, 0x0, 0x0, 0x0, 0x0, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x0, 0x0, 0x0, 0x0, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x0, 0x0, 0x0, 0x0, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x0, 0x0, 0x0, 0x0, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x0, 0x0, 0x0, 0x0, 0x00, 0x00,
};

int main(void)
{
    asmClockEnable();      // Enable clock
    // Включение макроса DWT_CYCCNT
       CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
       DWT->CYCCNT = 0;
       DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
           // Запуск макроса DWT_CYCCNT
           start_time = DWT->CYCCNT;
    asmI2cEnable();        // Enable I2C
    asmInterruptWFI();     // Enable Wait for Interrupt mode

           // Остановка макроса DWT_CYCCNT
              end_time = DWT->CYCCNT;
              elapsed_time = end_time - start_time;
    asmMain();             // Call the main assembly function
}


#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
