#include "xparameters.h"
#include "gpio.h"
#include <xil_io.h>
#include <xil_printf.h>
#include <xgpio.h>

XStatus Gpio_Initialize(void) {

   XStatus Status;
   XGpio gpio_i2c, gpio_poe;

   //

   Status = XGpio_Initialize(&gpio_i2c, XPAR_SC_AXI_GPIO_I2C_DEVICE_ID);
   if(Status != XST_SUCCESS) return XST_FAILURE;

   XGpio_SetDataDirection(&gpio_i2c, 1, 0x00);

   // deassert reset on I2C mux
   XGpio_DiscreteSet(&gpio_i2c, 1, 0x01);

   //

   Status = XGpio_Initialize(&gpio_poe, XPAR_SC_AXI_GPIO_POE_DEVICE_ID);
   if(Status != XST_SUCCESS) return XST_FAILURE;

   XGpio_SetDataDirection(&gpio_poe, 1, 0x00);

   // deassert reset on POE controller
   XGpio_DiscreteSet(&gpio_poe, 1, 0x03);

	return XST_SUCCESS;
}
