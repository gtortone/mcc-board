#include "xparameters.h"
#include "gpio.h"
#include <xil_io.h>
#include <xil_printf.h>
#include <xgpio.h>

XStatus Gpio_Initialize(void) {

   XStatus Status;
   XGpio gpio_i2c;

   Status = XGpio_Initialize(&gpio_i2c, XPAR_SC_AXI_GPIO_I2C_DEVICE_ID);
   if(Status != XST_SUCCESS) return XST_FAILURE;

   // deassert reset on I2C mux
   XGpio_DiscreteWrite(&gpio_i2c, 1, 0x01);

	return XST_SUCCESS;
}
