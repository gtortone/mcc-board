#include <stdio.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "xiicps.h"
#include "iicps.h"
#include "xil_assert.h"

/************************** Constant Definitions *****************************/

//#define IIC_DEVICE_ID 	(u32) XPAR_PSU_I2C_0_BASEADDR
#define IIC_SCLK_RATE	400000

#define IIC_SWITCH_ADDR	   0x70

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Variable Definitions *****************************/

static XIicPs Iic;

/************************** Function Prototypes ******************************/

static XStatus SelectChannelSwitch(u8 channel, u16 SwitchAddr);

XStatus Iicps_Initialize(void) {

   XStatus Status;
   XIicPs_Config *Config;

	Config = XIicPs_LookupConfig(XPAR_PSU_I2C_0_BASEADDR);
	
	if (NULL == Config) {
		return XST_FAILURE;
	}
	
	Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = XIicPs_SelfTest(&Iic);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);	

	return XST_SUCCESS;
}

XStatus Iicps_SelectChannel(u8 channel) {

   SelectChannelSwitch(channel,IIC_SWITCH_ADDR);

	return XST_SUCCESS;
}

XStatus Iicps_Send(u8 *MsgPtr,s32 ByteCount, u16 SlaveAddr) {

   XStatus Status;

	do {
		/*
		 * Wait until bus is idle to start another transfer.
		 */
		while (XIicPs_BusIsBusy(&Iic)) {
			/* NOP */
		}

		/*
		 * Send the buffer using the IIC and ignore the number of bytes sent
		 * as the return value since we are using it in interrupt mode.
		 */
		Status = XIicPs_MasterSendPolled(&Iic, MsgPtr,
						 ByteCount, SlaveAddr);
	} while (Status == XIICPS_EVENT_ARB_LOST);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

XStatus Iicps_Recv(u8 *MsgPtr,s32 ByteCount, u16 SlaveAddr) {

   XStatus Status;

	do {
		/*
		 * Wait until bus is idle to start another transfer.
		 */
		while (XIicPs_BusIsBusy(&Iic)) {
			/* NOP */
		}

		Status = XIicPs_MasterRecvPolled(&Iic, MsgPtr,
						 ByteCount, SlaveAddr);
	} while (Status == XIICPS_EVENT_ARB_LOST);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

static XStatus SelectChannelSwitch(u8 channel, u16 SwitchAddr) {

   XStatus Status;
   u8 data_send[1];
   u8 data_recv[1];

	Xil_AssertNonvoid(channel < 8);

	data_send[0] = 1 << channel;

	Status = Iicps_Send(data_send,1,SwitchAddr);

	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = Iicps_Recv(data_recv,1,SwitchAddr);

	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	if(data_send[0] != data_recv[0]) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}
