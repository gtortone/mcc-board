/*****************************************************************************/
/**
* @file globals.h
* @brief Global declarations and definitions.
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

#ifndef GLOBALS_H_
#define GLOBALS_H_

/***************************** Include Files *********************************/

#include "xparameters.h"
#include <xstatus.h>
//#include <xio.h>
#include "xil_printf.h"

/************************** Constant Definitions *****************************/

#define PHASE_DELAY_INTRA_CRATE -4320 /*[ps]*/
#define PHASE_DELAY_INTER_CRATE -5920 /*[ps]*/

/** Declaration of structure holding key board parameters */
typedef struct {
    u32 GATEWARE;   /**< Gateware version */
    u32 FIRMWARE;   /**< Firmware version */
    u8 BP_SADR;     /**< Backplane slot address */
    u8 BP_CADR;     /**< Backplane crate address */
    u8 DS;          /**< Dip switch state */
    u8 RS;          /**< Rotary switch state */
    u8 CARD_TYPE;   /**< Card type */
    u32 SERIAL_NUM; /**< Serial number */
    u8 HV;      /**< Hardware version */
    u32 DNA[2]; /**< FPGA DNA number */
    u32 EFUSE;  /**< FPGA eFuse number */
} S_ID;

#endif /* GLOBALS_H_ */
