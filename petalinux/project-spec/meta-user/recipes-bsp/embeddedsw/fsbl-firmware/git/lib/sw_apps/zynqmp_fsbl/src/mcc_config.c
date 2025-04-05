
#include "iicps.h"
#include "gpio.h"
#include "clock.h"
#include "poe.h"
#include "xfsbl_debug.h"
#include "xfsbl_error.h"

void mcc_config(void) {

    // start MCC code

    // MCC code

    xil_printf("HK MCC\n\r");

    S_ID BoardId;
    u32 Status = XFSBL_SUCCESS;

    // gpio

    xil_printf("GPIO initialization\n\r");
    Status = Gpio_Initialize(&BoardId);

    if(Status == XST_FAILURE) {
    	xil_printf("\r\nGpio initialization failed!!!\n\r");
    	while(1);
    }

    // iicps

    Status = Iicps_Initialize();

    if(Status == XST_FAILURE) {
    	xil_printf("\r\nIicps initialization failed!!!\r\n");
    	while(1);
    }

    for(int i = 0; i < 8; i++) {
    	Status = Iicps_SelectChannel(i);
    	if(Status == XST_FAILURE) {
    		xil_printf("channel failed %u\r\n",i);
    	}
    }

    for(int i = 0; i < 8; i++) {
    	Status = Iicps_SelectChannel(i);
    	if(Status == XST_FAILURE) {
    		xil_printf("channel failed %u\r\n",i);
    	}
    }

    // clock

    Status = Clock_Initialize();

    if(Status == XST_FAILURE) {
    	xil_printf("\r\nClock Initialization failed!!!\r\n");
    	while(1);
    }

	s16 phase_delay;

    if(Gpio_GetAddress() != 6) {
    	/* standard clock cable between MCC cards */
    	phase_delay = PHASE_DELAY_INTRA_CRATE;
    }
    else {
    	/* last MCC in the crate, longer clock cable */
    	phase_delay = PHASE_DELAY_INTER_CRATE;
    }

    if(!Gpio_GetClkSource()) {
    	Status = Clock_Configure(XTAL,EXT,phase_delay,1);
    }
    else {
    	Status = Clock_Configure(SMA,EXT,phase_delay,1);
    }

    if(Status == XST_FAILURE) {
    	xil_printf("\r\nClock configuration failed!!!\r\n");
    	/* indicating clock configuration failure */
    	Gpio_Led_0_On();
    	while(1);
    }

    // POE

    Status = Poe_Initialize();

    if(Status == XST_FAILURE) {
    	xil_printf("\r\nPoe Initialization failed!!!\r\n");
    	while(1);
    }

#if 0
    // ST

    Status = ST_Initialize();

    if(Status == XST_FAILURE) {
    	xil_printf("\r\nSync & trigger Initialization failed!!!\r\n");
    	while(1);
    }
#endif

    // end MCC code
}

