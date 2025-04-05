/*****************************************************************************/
/**
* @file gpio.h
* @brief GPIO initialization and configuration header file.
* @author Krzysztof Zietara, Jagiellonian University
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -------------------------------------------------------
* 1.00  KZ   1/1/14   First release
*
* </pre>
*
******************************************************************************/

#ifndef GPIO_H_
#define GPIO_H_

/***************************** Include Files *********************************/
#include "globals.h"

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

XStatus Gpio_Initialize(S_ID * ID);
void Gpio_Led_0_On(void);
void Gpio_Led_0_Off(void);
void Gpio_Led_1_On(void);
void Gpio_Led_1_Off(void);
u8 Gpio_GetAddress(void);
u8 Gpio_GetPpsSource(void);
u8 Gpio_GetClkSource(void);

#endif /* GPIO_H_ */
