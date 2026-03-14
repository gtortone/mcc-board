#ifndef IICPS_H_
#define IICPS_H_

#include "xil_types.h"
#include <xstatus.h>

XStatus Iicps_Initialize(void);
XStatus Iicps_SelectChannel(u8 channel);
XStatus Iicps_Send(u8 *MsgPtr,s32 ByteCount, u16 SlaveAddr);
XStatus Iicps_Recv(u8 *MsgPtr,s32 ByteCount, u16 SlaveAddr);

#endif /* IICPS_H_ */
