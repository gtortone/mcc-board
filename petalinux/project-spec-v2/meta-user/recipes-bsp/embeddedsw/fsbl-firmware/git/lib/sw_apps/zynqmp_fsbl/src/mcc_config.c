
#include "iicps.h"
#include "gpio.h"
#include "poe.h"
#include "xil_io.h"
#include "xfsbl_debug.h"
#include "xfsbl_error.h"

#define RESET_REASON_REG 0xFF5E0220

void mcc_config(void) {

   xil_printf("HK MCC\n\r");

   u32 r = Xil_In32(RESET_REASON_REG);

   if(r & 0x20) {
      xil_printf("Soft reset\r\n");
   } else if(r & 0x01) {
      xil_printf("Power-on reset\r\n");

      // GPIO
      Gpio_Initialize();
     
      // I2C
      Iicps_Initialize();

      // POE
      Poe_Initialize();
   }
}

