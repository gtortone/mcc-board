/*****************************************************************************/
/**
* @file clock.h
* @brief Clocking system initialization and configuration header file.
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

#ifndef CLOCK_H_
#define CLOCK_H_

/***************************** Include Files *********************************/

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/** Main PLL reference clock source */
enum eCLK_SOURCE {
    XTAL,       /**< internal - local oscillator */
    EXT,    	/**< external - PL  */
    SMA        	/**< external - SMA */
};

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

XStatus Clock_Initialize(void);
XStatus Clock_Configure(enum eCLK_SOURCE clk_source_0,enum eCLK_SOURCE clk_source_1,s16 phase_delay,u8 pll_setup);

void ClockMainPllInterruptHandler(void);
void ClockWrPllInterruptHandler(void);

#endif /* CLOCK_H_ */
