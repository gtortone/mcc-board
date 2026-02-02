/*****************************************************************************/
/**
* @file gpio.c
* @brief GPIO initialization and configuration.
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
#include "globals.h"
#include "xparameters.h"
#include "gpio.h"
#include <xil_io.h>
#include <xil_printf.h>
#include <xgpio.h>

/************************** Constant Definitions *****************************/

/** LEDs states */
enum eState {
    OFF = 0,    /**< LED turned off */
    ON  = 1     /**< LED turned on */
};

/** Source states */
enum eSource {
    INT = 0,    /**< Source internal */
    EXT = 1     /**< Source external */
};

/** LEDs structure */
typedef struct sLeds {
    enum eState LED0_PCB : 1;  /**< LED0 PCB red */
    enum eState LED1_PCB : 1;  /**< LED1 PCB red */
} sLeds;

/** LEDs union */
typedef union uLeds {
    u8 All; /**< common byte */
    struct sLeds Bit; /**< individual bits */
} uLeds;

typedef struct sBoardCfg {
	u8 Address : 6;
	enum eSource PpsSource : 1;
	enum eSource ClkSource : 1;
} sBoardCfg;

typedef union uBoardCfg {
	u8 All;
	struct sBoardCfg Bit;
} uBoardCfg;

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Variable Definitions *****************************/

/** @name Definitions of GPIO devices 
 *
 * This is where all auxiliary GPIO devices are defined.
 *
 * @{
 */

static union uLeds Leds;
static XGpio gpio_led, gpio_poe, gpio_ds;

uBoardCfg BoardCfg;

/************************** Function Prototypes ******************************/

static void UpdateLeds(void);
static void GetBoardId(void);

/*****************************************************************************/
/**
* Initializes and configures auxiliary GPIO devices used in the system. 
*
* @param	ID is a pointer to global structure holding board identification
* 			parameters.
*
* @return
*			- XST_SUCCESS on successful completion. 
*           - XST_FAILURE on error.
*
* @note		None.
*
******************************************************************************/
XStatus Gpio_Initialize(S_ID *ID)
{
   // test
   XStatus Status;

#ifdef SDT
   xil_printf("SDT is defined\n\r");
#else
   xil_printf("SDT is NOT defined\n\r");
#endif

   Status = XGpio_Initialize(&gpio_led, XPAR_SC_AXI_GPIO_LED_DEVICE_ID);
   if(Status != XST_SUCCESS) return XST_FAILURE;

   // turn off leds
   XGpio_DiscreteWrite(&gpio_led, 1, 0x00);

   Status = XGpio_Initialize(&gpio_poe, XPAR_SC_AXI_GPIO_POE_DEVICE_ID);
   if(Status != XST_SUCCESS) return XST_FAILURE;

   // deassert reset on POE IC
   XGpio_DiscreteWrite(&gpio_poe, 1, 0x03);

   Status = XGpio_Initialize(&gpio_ds, XPAR_SC_AXI_GPIO_DS_DEVICE_ID);
   if(Status != XST_SUCCESS) return XST_FAILURE;

   GetBoardId();

   ID->BP_SADR = BoardCfg.Bit.Address;

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
* Prints board identification parameters.
*
* @param	ID is a pointer to global structure holding identification
* 			variables.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void GetBoardId(void)
{
u32 reg;

	/* read address from dip switch */
   reg = XGpio_DiscreteRead(&gpio_ds, 1);

	BoardCfg.All = (u8) reg;

	xil_printf("MCC ADDRESS = %02X\r\n",BoardCfg.Bit.Address);

	xil_printf("MCC PPS ");
	if(BoardCfg.Bit.PpsSource == INT) {
		xil_printf("INTERNAL\r\n");
	}
	else {
		xil_printf("EXTERNAL\r\n");
	}

	xil_printf("MCC CLK ");
	if(BoardCfg.Bit.ClkSource == INT) {
		xil_printf("INTERNAL\r\n");
	}
	else {
		xil_printf("EXTERNAL\r\n");
	}
}

u8 Gpio_GetAddress(void)
{
	return BoardCfg.Bit.Address;
}

u8 Gpio_GetPpsSource(void)
{
	return BoardCfg.Bit.PpsSource;
}

u8 Gpio_GetClkSource(void)
{
	return BoardCfg.Bit.ClkSource;
}

void Gpio_Led_0_On(void)
{
	Leds.Bit.LED0_PCB = ON;
	UpdateLeds();
}

void Gpio_Led_0_Off(void)
{
	Leds.Bit.LED0_PCB = OFF;
	UpdateLeds();
}

void Gpio_Led_1_On(void)
{
	Leds.Bit.LED1_PCB = ON;
	UpdateLeds();
}

void Gpio_Led_1_Off(void)
{
	Leds.Bit.LED1_PCB = OFF;
	UpdateLeds();
}

static void UpdateLeds(void)
{
   XGpio_DiscreteWrite(&gpio_led, 1, Leds.All);
}

