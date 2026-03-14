/*****************************************************************************/
/**
* @file poe.h
* @brief POE initialization and configuration header file.
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

#ifndef POE_H_
#define POE_H_

/***************************** Include Files *********************************/

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

XStatus Poe_Initialize(void);
void POE_SetChannelOn(u8 channel);
void POE_SetChannelOff(u8 channel);
void POE_ProcessOnOff(u8 * ptr, u8 len);
void POE_GetVoltageCurrent(u8 ** ptr, u8 * len);
u32 POE_GetPowerVoltage(u8 index);
u32 POE_GetChannelVoltage(u8 channel);
u32 POE_GetChannelCurrent(u8 channel);
void POE_PrintVoltageCurrentAll(void);

#endif /* POE_H_ */
