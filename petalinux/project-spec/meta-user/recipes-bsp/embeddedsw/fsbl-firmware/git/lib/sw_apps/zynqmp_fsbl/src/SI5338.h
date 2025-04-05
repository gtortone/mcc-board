/*****************************************************************************/
/**
* @file SI5338.h
* @brief Clocking system SI5338 header file.
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

#ifndef SI5338_H_
#define SI5338_H_

/***************************** Include Files *********************************/

#include "xbasic_types.h"

/************************** Constant Definitions *****************************/

/** number of configuration registers of the SI5338 chip */
#define NUM_REGS_MAX 350

/**************************** Type Definitions *******************************/

/** PLL register structure declaration */
typedef struct Reg_Data{
   u8 Reg_Addr;     /**< register address */
   u8 Reg_Val;      /**< register value */
   u8 Reg_Mask;     /**< register mask */
} Reg_Data;

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

#endif /* SI5338_H_ */
