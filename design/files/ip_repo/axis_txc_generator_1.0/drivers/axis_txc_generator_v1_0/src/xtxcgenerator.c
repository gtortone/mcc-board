/// @file				xtxcgenerator.c
/*****************************************************************************************
 * Project Name: 		axis_txc_generator
 * File:				xtxcgenerator.c
 * Version:				1.0.0
 *****************************************************************************************
 * Author: 				Krzysztof Zietara
 * Project:				DigiCam
 * Company:				Jagiellonian University
 *****************************************************************************************
 * Description:			axis_txc_generator driver
 *
 *****************************************************************************************
 * Created on:			01-01-2014 00:00:00
 *
 * Revision history:
 *----------------------------------------------------------------------------------------
 * 1.0.0 - 01-01-2014 - Initial version
 *----------------------------------------------------------------------------------------
 *
 ****************************************************************************************/

/***************************** Include Files *********************************/

#include "xparameters.h"
#include "xtxcgenerator.h"

//#include <xio.h>
#include <xil_io.h>

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

XTxcGenerator_Config *XTxcGenerator_LookupConfig(u16 DeviceId);

/************************** Variable Definitions *****************************/

extern XTxcGenerator_Config XTxcGenerator_ConfigTable[];

/************************** Function Definitions *****************************/


/*****************************************************************************/
/**
*
* Initializes a specific timer/counter instance/driver. Initialize fields of
* the XTmrCtr structure, then reset the timer/counter.If a timer is already
* running then it is not initialized.
*
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	DeviceId is the unique id of the device controlled by this
*		XTmrCtr component.  Passing in a device id associates the
*		generic XTmrCtr component to a specific device, as chosen by
*		the caller or application developer.
*
* @return
*		- XST_SUCCESS if initialization was successful
*		- XST_DEVICE_IS_STARTED if the device has already been started
*		- XST_DEVICE_NOT_FOUND if the device doesn't exist
*
* @note		None.
*
******************************************************************************/
int XTxcGenerator_Initialize(XTxcGenerator * InstancePtr, u16 DeviceId)
{
	XTxcGenerator_Config *TxcGenConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	/*
	 * Lookup the device configuration in the temporary CROM table. Use this
	 * configuration info down below when initializing this component.
	 */
	TxcGenConfigPtr = XTxcGenerator_LookupConfig(DeviceId);

	if (TxcGenConfigPtr == (XTxcGenerator_Config *) NULL) {
		return XST_DEVICE_NOT_FOUND;
	}

	InstancePtr->BaseAddress = TxcGenConfigPtr->BaseAddress;
	
	return XST_SUCCESS;
}


/*****************************************************************************
*
* Looks up the device configuration based on the unique device ID. The table
* TmrCtrConfigTable contains the configuration info for each device in the
* system.
*
* @param	DeviceId is the unique device ID to search for in the config
*		table.
*
* @return	A pointer to the configuration that matches the given device ID,
* 		or NULL if no match is found.
*
* @note		None.
*
******************************************************************************/
XTxcGenerator_Config *XTxcGenerator_LookupConfig(u16 DeviceId)
{
	XTxcGenerator_Config *CfgPtr = NULL;
	int Index;

	for (Index = 0; Index < XPAR_XTXCGENERATOR_NUM_INSTANCES; Index++) {
		if (XTxcGenerator_ConfigTable[Index].DeviceId == DeviceId) {
			CfgPtr = &XTxcGenerator_ConfigTable[Index];
			break;
		}
	}

	return CfgPtr;
}

/*****************************************************************************/
/**
*
* Configures txc generator to send packets indicating to the MAC, that no
* checksum offload is required.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
*
* @return
*		- XST_SUCCESS if initialization was successful
*
* @note		None.
*
******************************************************************************/
int XTxcGenerator_Configure(XTxcGenerator * InstancePtr)
{
	/* normal transmit frame (flag = 0xA) */
    AXIS_TXC_GENERATOR_mWriteReg(InstancePtr->BaseAddress,AXIS_TXC_GENERATOR_S_AXI_SLV_REG0_OFFSET,0xA0000000);
    /* no transmit checksum offloading should be performed on this frame (TXCsumCntrl = 00) */
    AXIS_TXC_GENERATOR_mWriteReg(InstancePtr->BaseAddress,AXIS_TXC_GENERATOR_S_AXI_SLV_REG1_OFFSET,0);
    /* following words are irrelevant */
    AXIS_TXC_GENERATOR_mWriteReg(InstancePtr->BaseAddress,AXIS_TXC_GENERATOR_S_AXI_SLV_REG2_OFFSET,0);
    AXIS_TXC_GENERATOR_mWriteReg(InstancePtr->BaseAddress,AXIS_TXC_GENERATOR_S_AXI_SLV_REG3_OFFSET,0);
    AXIS_TXC_GENERATOR_mWriteReg(InstancePtr->BaseAddress,AXIS_TXC_GENERATOR_S_AXI_SLV_REG4_OFFSET,0);
    AXIS_TXC_GENERATOR_mWriteReg(InstancePtr->BaseAddress,AXIS_TXC_GENERATOR_S_AXI_SLV_REG5_OFFSET,0);

	return XST_SUCCESS;
}

