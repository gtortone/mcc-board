
#include "iicps.h"
#include "gpio.h"
#include "poe.h"
#include "xil_io.h"
#include "xfsbl_debug.h"
#include "xfsbl_error.h"

#define RESET_REASON_REG 0xFF5E0220

void mcc_config(void) {

   xil_printf("HK MCC 2.0\n\r");

   u32 r = Xil_In32(RESET_REASON_REG);

   if(r & 0x20) {
      xil_printf("Soft reset\r\n");
   } else if(r & 0x01) {
      xil_printf("Power-on reset\r\n");

      // GPIO
      if (Gpio_Initialize() != XST_SUCCESS)
         xil_printf("E: GPIO initialization failure\r\n");
     
      // I2C
      if (Iicps_Initialize() != XST_SUCCESS)
         xil_printf("E: I2C initialization failure\r\n");

      // POE
      if (Poe_Initialize() != XST_SUCCESS)
         xil_printf("E: POE initialization failure\r\n");
   }
}

