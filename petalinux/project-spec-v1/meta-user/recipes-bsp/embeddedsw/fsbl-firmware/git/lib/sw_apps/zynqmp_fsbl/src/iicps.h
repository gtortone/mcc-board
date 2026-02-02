/*****************************************************************************/
/**
* @file iicps.h
* @brief IICPS initialization and configuration header file.
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

#ifndef IICPS_H_
#define IICPS_H_

#include "xil_types.h"
#include <xstatus.h>


/***************************** Include Files *********************************/

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

XStatus Iicps_Initialize(void);
XStatus Iicps_SelectChannel(u8 channel);
XStatus Iicps_Send(u8 *MsgPtr,s32 ByteCount, u16 SlaveAddr);
XStatus Iicps_Recv(u8 *MsgPtr,s32 ByteCount, u16 SlaveAddr);

#endif /* IICPS_H_ */
