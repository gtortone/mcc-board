/*****************************************************************************/
/**
* @file iicps.c
* @brief IICPS initialization and configuration.
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

/***************************** Include Files *********************************/

#include <stdio.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "xiicps.h"
#include "iicps.h"
#include "xil_assert.h"

/************************** Constant Definitions *****************************/

#define IIC_DEVICE_ID 	XPAR_PSU_I2C_0_BASEADDR
#define IIC_SCLK_RATE	100000

#define IIC_SWITCH0_ADDR	0x72
#define IIC_SWITCH1_ADDR	0x71

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Variable Definitions *****************************/

static XIicPs Iic;

/************************** Function Prototypes ******************************/

static XStatus SelectChannelSwitch(u8 channel, u16 SwitchAddr);

/*****************************************************************************/
/**
* . 
*
* @param	.
*
* @return
*			- XST_SUCCESS on successful completion. 
*           - XST_FAILURE on error.
*
* @note		None.
*
******************************************************************************/
XStatus Iicps_Initialize(void)
{
XStatus Status;
XIicPs_Config *Config;

	/*
	 * Initialize the IIC driver so that it's ready to use
	 * Look up the configuration in the config table,
	 * then initialize it.
	 */
	Config = XIicPs_LookupConfig(IIC_DEVICE_ID);
	
	if (NULL == Config) {
		return XST_FAILURE;
	}
	
	Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Perform a self-test to ensure that the hardware was built correctly.
	 */
	Status = XIicPs_SelfTest(&Iic);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Set the IIC serial clock rate.
	 */
	XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);	

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
* .
*
* @param	.
*
* @return
*			- XST_SUCCESS on successful completion.
*           - XST_FAILURE on error.
*
* @note		None.
*
******************************************************************************/
XStatus Iicps_SelectChannel(u8 channel)
{
XStatus Status;

	switch(channel)
	{
		case 0: //CLK
		case 1: //not used
		case 2: //not used
			Status = SelectChannelSwitch(channel,IIC_SWITCH0_ADDR);
			if(Status != XST_SUCCESS) return XST_FAILURE;
			break;
		case 3:
			Status = SelectChannelSwitch(3,IIC_SWITCH0_ADDR);
			if(Status != XST_SUCCESS) return XST_FAILURE;
			break;
		case 4: //POE
		case 5: //SFP1
		case 6: //SFP0
		case 7: //not used
			Status = SelectChannelSwitch(3,IIC_SWITCH0_ADDR);
			if(Status != XST_SUCCESS) return XST_FAILURE;
			Status = SelectChannelSwitch(channel-4,IIC_SWITCH1_ADDR);
			if(Status != XST_SUCCESS) return XST_FAILURE;
			break;
		default:
			xil_printf("channel not supported\r\n");
			break;
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
* .
*
* @param	.
*
* @return
*			- XST_SUCCESS on successful completion.
*           - XST_FAILURE on error.
*
* @note		None.
*
******************************************************************************/
XStatus Iicps_Send(u8 *MsgPtr,s32 ByteCount, u16 SlaveAddr)
{
XStatus Status;

    /*
    xil_printf("Iicps_Send: ");
    for(int i=0; i<ByteCount;i++)
        xil_printf("0x%X ", MsgPtr[i]);
    xil_printf(" addr:%X\r\n", SlaveAddr);
    */

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

/*****************************************************************************/
/**
* .
*
* @param	.
*
* @return
*			- XST_SUCCESS on successful completion.
*           - XST_FAILURE on error.
*
* @note		None.
*
******************************************************************************/
XStatus Iicps_Recv(u8 *MsgPtr,s32 ByteCount, u16 SlaveAddr)
{
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

/*****************************************************************************/
/**
* .
*
* @param	.
*
* @return
*			- XST_SUCCESS on successful completion.
*           - XST_FAILURE on error.
*
* @note		None.
*
******************************************************************************/
static XStatus SelectChannelSwitch(u8 channel, u16 SwitchAddr)
{
XStatus Status;
u8 data_send[1];
u8 data_recv[1];

	Xil_AssertNonvoid(channel < 4);

	data_send[0] = 1 << channel;

   //xil_printf("SelectChannelSwitch: i2c mw 0x%X 0x00 0x%X\r\n", SwitchAddr, data_send[0]);

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
