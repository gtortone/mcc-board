/// @file				xtxcgenerator.h
/*****************************************************************************************
 * Project Name: 		axis_txc_generator
 * File:				xtxcgenerator.h
 * Version:				1.0.0
 *****************************************************************************************
 * Author: 				Krzysztof Zietara
 * Project:				DigiCam
 * Company:				Jagiellonian University
 *****************************************************************************************
 * Description:			header file of the axis_txc_generator driver
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
#ifndef XTXCGENERATOR_H
#define XTXCGENERATOR_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"

#define AXIS_TXC_GENERATOR_S_AXI_SLV_REG0_OFFSET 0
#define AXIS_TXC_GENERATOR_S_AXI_SLV_REG1_OFFSET 4
#define AXIS_TXC_GENERATOR_S_AXI_SLV_REG2_OFFSET 8
#define AXIS_TXC_GENERATOR_S_AXI_SLV_REG3_OFFSET 12
#define AXIS_TXC_GENERATOR_S_AXI_SLV_REG4_OFFSET 16
#define AXIS_TXC_GENERATOR_S_AXI_SLV_REG5_OFFSET 20

/**************************** Type Definitions *******************************/

typedef struct {
	u16  DeviceId;	/**< Unique ID  of device */
	u32  BaseAddress;/**< Register base address */
} XTxcGenerator_Config;

typedef struct {
	u32  BaseAddress;	 /**< Base address of registers */
} XTxcGenerator;

/***************** Macros (Inline Functions) Definitions *********************/

/**
 *
 * Write a value to a AXIS_TXC_GENERATOR register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the AXIS_TXC_GENERATORdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void AXIS_TXC_GENERATOR_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define AXIS_TXC_GENERATOR_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a AXIS_TXC_GENERATOR register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the AXIS_TXC_GENERATOR device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 AXIS_TXC_GENERATOR_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define AXIS_TXC_GENERATOR_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the AXIS_TXC_GENERATOR instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus AXIS_TXC_GENERATOR_Reg_SelfTest(void * baseaddr_p);

int XTxcGenerator_Initialize(XTxcGenerator * InstancePtr, u16 DeviceId);
int XTxcGenerator_Configure(XTxcGenerator * InstancePtr);

#endif // XTXCGENERATOR_H
