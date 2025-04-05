/*****************************************************************************/
/**
* @file poe.c
* @brief POE initialization and configuration.
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
#include <sleep.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "xiicps.h"
#include "iicps.h"
#include "xil_assert.h"
#include "poe.h"
#include "xgpio.h"

/************************** Constant Definitions *****************************/

#define IIC_POE0_ADDR	0x20
#define IIC_POE1_ADDR	0x22

#define POE_CHIPS 2
#define POE_CHANNELS 4
#define CHANNELS (POE_CHIPS * POE_CHANNELS)


#define REG_INTERRUPT_MASK 		0x01
#define REG_PORT_MODE 			0x12
#define REG_DETECT_CLASS_ENABLE 0x14
#define REG_PORT_REMAP 			0x26
#define REG_POWER_ALLOCATION 	0x29

#define REG_VPWR_LSB 0x2E
#define REG_VPWR_MSB 0x2F

#define REG_PORT1_VOLTAGE_LSB 0x32
#define REG_PORT1_VOLTAGE_MSB 0x33
#define REG_PORT2_VOLTAGE_LSB 0x36
#define REG_PORT2_VOLTAGE_MSB 0x37
#define REG_PORT3_VOLTAGE_LSB 0x3A
#define REG_PORT3_VOLTAGE_MSB 0x3B
#define REG_PORT4_VOLTAGE_LSB 0x3E
#define REG_PORT4_VOLTAGE_MSB 0x3F

#define REG_PORT1_CURRENT_LSB 0x30
#define REG_PORT1_CURRENT_MSB 0x31
#define REG_PORT2_CURRENT_LSB 0x34
#define REG_PORT2_CURRENT_MSB 0x35
#define REG_PORT3_CURRENT_LSB 0x38
#define REG_PORT3_CURRENT_MSB 0x39
#define REG_PORT4_CURRENT_LSB 0x3C
#define REG_PORT4_CURRENT_MSB 0x3D

/**************************** Type Definitions *******************************/

struct sPoe {
	u8 address;
};

struct sPoeVC {
	u32 voltage[CHANNELS];
	u32 current[CHANNELS];
	u32 pwr_voltage[POE_CHIPS];
};

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Variable Definitions *****************************/

static struct sPoe Poe[POE_CHIPS] = {{IIC_POE0_ADDR},{IIC_POE1_ADDR}};

static struct sPoeVC PoeVC;

/************************** Function Prototypes ******************************/

static void I2C_ByteWrite(u8 addr, u8 reg, u8 val);
static u8 I2C_ByteRead(u8 addr, u8 reg);
static u16 I2C_WordRead(u8 addr, u8 reg);
void PrintRegisters(u8 index);
void CheckInterrupts(void);
void POE_ManualMode(void);
void POE_AutoMode(u8 index);

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
XStatus Poe_Initialize(void)
{
XStatus Status;

	xil_printf("POE configuration:\r\n");

	Status = Iicps_SelectChannel(4);

	if(Status != XST_SUCCESS)
	{
		xil_printf("POE configuration error\r\n");

		return XST_FAILURE;
	}

    usleep(30000);

	/* The PORT_REMAP register is one of two registers that must be written once immediately after reset.
	   Even if the intention is to use the default PORT_REMAP, PORT_REMAP must be written with 0xE4.
	   Without this, the Si3473/72 will not function. Once PORT_REMAP is written,
	   ONLY a hardware reset can be used to allow PORT_REMAP to be written again. */

    I2C_ByteWrite(IIC_POE0_ADDR,0x26,0xE4); //PORT_REMAP
    I2C_ByteWrite(IIC_POE1_ADDR,0x26,0xE4); //PORT_REMAP

	/* Checking if POE chips are available on the IIC bus */

    u8 byte;

	byte = I2C_ByteRead(IIC_POE0_ADDR,0x1B);

	if(byte != 0x45) {
		xil_printf("POE configuration error (received %02X)\r\n",byte);
		return XST_FAILURE;
	}

	byte = I2C_ByteRead(IIC_POE1_ADDR,0x1B);

	if(byte != 0x45) {
		xil_printf("POE configuration error (received %02X)\r\n",byte);
		return XST_FAILURE;
	}

	/* Configuring both POE chips to auto-mode */

	POE_AutoMode(0);
	POE_AutoMode(1);

	xil_printf("POE : configured\r\n");

	return XST_SUCCESS;
}

void POE_AutoMode(u8 index)
{
u8 poe_addr;

	if(index == 0) poe_addr = IIC_POE0_ADDR;
	else if(index == 1) poe_addr = IIC_POE1_ADDR;
	else return;

	xil_printf("selecting auto mode on POE%d\r\n",index);

	I2C_ByteWrite(poe_addr,REG_PORT_REMAP,0xE4);
	I2C_ByteWrite(poe_addr,REG_POWER_ALLOCATION,0x33); //30 W Class 4
	//I2C_ByteWrite(poe_addr,REG_PORT_MODE,0xFF);
	I2C_ByteWrite(poe_addr,REG_DETECT_CLASS_ENABLE,0xFF);
}

static void ChannelOn(u8 index,u8 channel,u8 on)
{
u8 byte,mask;

	if(index > POE_CHIPS-1) return;
	if(channel > POE_CHANNELS-1) return;

	mask = 0x03 << channel*2;

	//xil_printf("index = %d, channel = %d, mask = %02X\r\n",index,channel,mask);

	byte = I2C_ByteRead(Poe[index].address,REG_PORT_MODE);

	if(on) byte |=  mask;
	else   byte &= ~mask;

	I2C_ByteWrite(Poe[index].address,REG_PORT_MODE,byte);

	/* If PORTn_MODE in SHUTDOWN Set up PORTn_PORT_MODE first */

	I2C_ByteWrite(Poe[index].address,REG_DETECT_CLASS_ENABLE,0xFF);
}

static u32 GetChannelVoltage(u8 index, u8 channel)
{
u8 addr;
u32 voltage;

	if(index > POE_CHIPS-1) return 0;
	if(channel > POE_CHANNELS-1) return 0;

	addr = REG_PORT1_VOLTAGE_LSB + channel*4;

	voltage = I2C_WordRead(Poe[index].address,addr);

	return 600*voltage/16384;
}

static u32 GetChannelCurrent(u8 index, u8 channel)
{
u8 addr;
u32 current;

	if(index > POE_CHIPS-1) return 0;
	if(channel > POE_CHANNELS-1) return 0;

	addr = REG_PORT1_CURRENT_LSB + channel*4;

	current = I2C_WordRead(Poe[index].address,addr);

	return 1000*current/16384;
}

void POE_SetChannelOn(u8 channel)
{
	if(channel > CHANNELS-1) return;

	ChannelOn(channel/POE_CHANNELS,channel%POE_CHANNELS,1);
}

void POE_SetChannelOff(u8 channel)
{
	if(channel > CHANNELS-1) return;

	ChannelOn(channel/POE_CHANNELS,channel%POE_CHANNELS,0);
}

void POE_ProcessOnOff(u8 * ptr, u8 len)
{
	if(len == CHANNELS) {
		int i;
		for(i = 0; i < CHANNELS; i++){
			if(ptr[i]) {
				POE_SetChannelOn(i);
			}
			else {
				POE_SetChannelOff(i);
			}
		}
	}
}

u32 POE_GetPowerVoltage(u8 index)
{
u32 voltage;

	voltage = I2C_WordRead(Poe[index].address,REG_VPWR_LSB);

	return 600*voltage/16384;
}

u32 POE_GetChannelVoltage(u8 channel)
{
	if(channel > CHANNELS-1) return 0;

	return GetChannelVoltage(channel/POE_CHANNELS,channel%POE_CHANNELS);
}

u32 POE_GetChannelCurrent(u8 channel)
{
	if(channel > CHANNELS-1) return 0;

	return GetChannelCurrent(channel/POE_CHANNELS,channel%POE_CHANNELS);
}

static void GetVoltageCurrent(void)
{
int i;

	for(i = 0; i < POE_CHIPS; i++) {
		PoeVC.pwr_voltage[i] = POE_GetPowerVoltage(i);
	}

	for(i = 0; i < CHANNELS; i++) {
		PoeVC.voltage[i] = POE_GetChannelVoltage(i);
		PoeVC.current[i] = POE_GetChannelCurrent(i);
	}
}

void POE_GetVoltageCurrent(u8 ** ptr, u8 * len)
{
	GetVoltageCurrent();

	*len = sizeof(struct sPoeVC);
	*ptr = (unsigned char *)&PoeVC;
}

void POE_PrintVoltageCurrentAll(void)
{
int i;

	GetVoltageCurrent();

	for(i = 0; i < POE_CHIPS; i++) {
		xil_printf("POE POWER%d %dV\r\n",i,PoeVC.pwr_voltage[i]);
	}

	for(i = 0; i < CHANNELS; i++) {
		xil_printf("POE CH%d %dV %dmA\r\n",i,PoeVC.voltage[i],PoeVC.current[i]);
	}
}

void PrintRegisters(u8 index)
{
u8 byte;
u8 reg_addr;
u8 poe_addr;

int i;

	if(index == 0) {
		poe_addr = IIC_POE0_ADDR;
	}
	else if(index == 1) {
		poe_addr = IIC_POE1_ADDR;
	}
	else return;

	xil_printf("printing registers of POE%u of address %02X\r\n",index,poe_addr);

	reg_addr = 0x00;

	for(i = 0; i < 16; i++) {
		byte = I2C_ByteRead(poe_addr,reg_addr);
		xil_printf("%02X = %02X\r\n",reg_addr,byte);
		reg_addr++;
	}

	reg_addr = 0x10;

	for(i = 0; i < 8; i++) {
		byte = I2C_ByteRead(poe_addr,reg_addr);
		xil_printf("%02X = %02X\r\n",reg_addr,byte);
		reg_addr++;
	}

	reg_addr = 0x1E;

	for(i = 0; i < 4; i++) {
		byte = I2C_ByteRead(poe_addr,reg_addr);
		xil_printf("%02X = %02X\r\n",reg_addr,byte);
		reg_addr++;
	}

	reg_addr = 0x29;

	for(i = 0; i < 1; i++) {
		byte = I2C_ByteRead(poe_addr,reg_addr);
		xil_printf("%02X = %02X\r\n",reg_addr,byte);
		reg_addr++;
	}
}

/*****************************************************************************/
/**
* Writes one byte to register over I2C interface.
*
* @param    addr is an I2C address to be used.
* @param    reg is a register address to be used.
* @param    val is a value to be written.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
static void I2C_ByteWrite(u8 addr, u8 reg, u8 val)
{
u8 data[2];

    data[0] = reg;
    data[1] = val;

    Iicps_Send(data,2,addr);
}

/*****************************************************************************/
/**
* Reads one byte from register over I2C interface.
*
* @param    addr is an I2C address to be used.
* @param    reg is a register address to be used.
*
* @return   byte readout from the selected register.
*
* @note     None.
*
******************************************************************************/
static u8 I2C_ByteRead(u8 addr, u8 reg)
{
u8 data;

    data = reg;

    Iicps_Send(&data,1,addr);
    Iicps_Recv(&data,1,addr);

    return data;
}

static u16 I2C_WordRead(u8 addr, u8 reg)
{
u8 data[2];

    data[0] = reg;

    Iicps_Send(&data[0],1,addr);
    Iicps_Recv(data,2,addr);

    return ((u16)data[1]<<8) + data[0];
}


