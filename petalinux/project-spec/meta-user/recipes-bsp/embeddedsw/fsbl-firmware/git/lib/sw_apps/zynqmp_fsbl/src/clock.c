/*****************************************************************************/
/**
* @file clock.c
* @brief Clocking system initialization and configuration.
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
#include "xparameters.h"
#include <sleep.h>
#include <stdio.h>
#include "xil_printf.h"
#include "xstatus.h"
#include "iicps.h"
#include "clock.h"
#include "SI5338.h"

/************************** Constant Definitions *****************************/

/** Main PLL I2C addresses */
#define SI5338_0_I2C_ADDR 0b1110000
/** White Rabbit PLL I2C addresses */
#define SI5338_1_I2C_ADDR 0b1110001

/** SI5338 initialization delay [ms] */
#define SI5338_DELAY 25000
/** SI5338 initialization time out [ms] */
#define SI5338_TIMEOUT 1000000
/** SI5338 initialization retry number */
#define SI5338_RETRY 20
/** SI5338 channels number */
#define SI5338_CH_NUM 4

/** @name Main PLL bit masks
 *
 * Main PLL bit masks
 *
 * @{
 */

/** Main PLL lock mask - IN 1 to 3 */
#define LOCK_MASK_0 0x15
/** Main PLL loss mask - IN 1 to 3 */
#define LOS_MASK_0 0x04
/** Main PLL lock mask - IN 4 to 6 */
#define LOCK_MASK_1 0x19
/** Main PLL loss mask - IN 4 to 6 */
#define LOS_MASK_1 0x08

/**@}*/

/** @name Crate clock phase delays
 *
 * Clock phase delays to be set on slave trigger cards working upon reference
 * clock taken from IB0 or IB1 connectors. Required delays were measured
 * between leftmost FADC cards of the crates using their SMA clock outputs.
 * For prototype card produced by ITR measured difference was different
 * (-1260 ps). Clock routing is of the same length and topology but the PCB
 * board is too thick, resulting in different impedances of the differential
 * pairs and different propagation time.
 *
 * @{
 */

/** slave crate 2 phase delay - reference clock from IB0 [ps] */
#define IB0_PHASE_DELAY -1020
/** slave crate 1 phase delay - reference clock from IB1 [ps] */
#define IB1_PHASE_DELAY -955
/** reference clock from CST phase delay (testing or UCTS board used ) [ps] */
#define CST_PHASE_DELAY 0

/**@}*/

/** @name Crate clock initialization delays
 *
 * Clock initialization delays for master and slave crates
 *
 * @{
 */

/**
 * clock initialization of the slave crates is delayed to give time for the
 * master to configure its clock first [ms]
 */
#define PRE_INI_SLAVE_DELAY   5000

/**
 * master waits after its clock initialization is finished to let the slave
 * crates catch up and continue further initialization synchronously [ms]
 */
#define POST_INI_MASTER_DELAY 5000

/**@}*/

/**************************** Type Definitions *******************************/

/** FPGA reference clock source */
enum eSel {
    SEL_SYS = 0,    /**< differential from main PLL */
    SEL_SE  = 1     /**< single ended from local oscillator */
};

/** Main PLL reference clock multiplexer */
enum eMux {
    MUX_CST = 0,    /**< CST */
    MUX_IB1 = 2,    /**< InfiniBand IB1 */
    MUX_IB0 = 3     /**< InfiniBand IB0 */
};

/** FPGA/main PLL clock selector/multiplexer */
typedef struct sMuxSel {
    enum eSel clk_sel : 1;  /**< FPGA reference clock selector */
    enum eMux clk_mux : 2;  /**< Main PLL clock multiplexer */
} sMuxSel;

/** FPGA/main PLL clock selector/multiplexer */
typedef union uMuxSel {
    u8 All; /**< common byte */
    struct sMuxSel Bit; /**< individual bits */
} uMuxSel;

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Variable Definitions *****************************/

/**
 * Main PLL configuration table - White Rabbit clock reference
 */
extern Reg_Data const Reg_Store_PLL_0_XTAL[];
extern Reg_Data const Reg_Store_PLL_0_XTAL_SYS_CLK_25MHz[];
extern Reg_Data const Reg_Store_PLL_0_SMA[];
extern Reg_Data const Reg_Store_PLL_0_SMA_10MHz[];
extern Reg_Data const Reg_Store_PLL_0_SMA_SYS_CLK_25MHz[];
extern Reg_Data const Reg_Store_PLL_1_XTAL[];
extern Reg_Data const Reg_Store_PLL_1_SMA[];
extern Reg_Data const Reg_Store_PLL_1_EXT[];

/**
 * Main PLL configuration table - external clock reference
 * (selected by clock multiplexer)
 */
//extern Reg_Data const Reg_Store_EXT[];

/**
 * Main PLL configuration table - White Rabbit clock reference
 */
//extern Reg_Data const Reg_Store_WR[];

/**
 * Auxiliary PLL configuration table - White Rabbit DMTD clock reference
 */
//extern Reg_Data const Reg_Store_WR_DMTD[];

/**
 * Main PLL configuration table - SMA clock reference
 */
//extern Reg_Data const Reg_Store_SMA[];

/************************** Function Prototypes ******************************/

static XStatus Configure_SI5338(u8 i2c_addr, char grade,
                                Reg_Data const * config_table,
                                u8 lock_mask,u8 los_mask, s16 phase_delay);

static void AdjustPhaseDelay(u8 i2c_addr, u8 channel, s32 phase_delay);
static void AdjustPhaseDelayAll(u8 i2c_addr, s32 phase_delay);

static void I2C_ByteWrite(u8 addr, u8 reg, u8 val);
static u8 I2C_ByteRead(u8 addr, u8 reg);

/*****************************************************************************/
/**
* Initializes clock system I2C interface used for main and White Rabbit
* PLLs communication. Must be called before clock system configuration.
*
* @return
*           - XST_SUCCESS on successful completion.
*           - XST_FAILURE on error.
*
* @note     None.
*
******************************************************************************/
XStatus Clock_Initialize(void)
{
XStatus Status;

    return XST_SUCCESS;
}

/*****************************************************************************/
/**
* Configures clock system PLLs.
*
* @param    ID is a pointer to S_ID structure holding key system parameters.
* @param    clk_source indicates reference clock source to be used for main
*           PLL.
* @param    pll_setup indicates if PLLs should be (r)initialized
*           (0 - no, 1 - yes).
*
* @return
*           - XST_SUCCESS on successful completion.
*           - XST_FAILURE on error.
*
* @note     None.
*
******************************************************************************/
XStatus Clock_Configure(enum eCLK_SOURCE clk_source_0,enum eCLK_SOURCE clk_source_1,s16 phase_delay,u8 pll_setup)
{
XStatus Status;

    xil_printf("Clock configuration:\r\n");

    Status = Iicps_SelectChannel(0);

    if(Status != XST_SUCCESS)
    {
        xil_printf("Clock configuration error\r\n");

        return XST_FAILURE;
    }

    /*
     * configure SI5338 clock generator
     */

    if(pll_setup)
    {
        switch(clk_source_0) {
            case XTAL:
                xil_printf("Clock 0: reference from XTAL\r\n");
                Status = Configure_SI5338(SI5338_0_I2C_ADDR,'A',Reg_Store_PLL_0_XTAL_SYS_CLK_25MHz,LOCK_MASK_0,LOS_MASK_0,phase_delay);
                break;
            case SMA:
                xil_printf("Clock 0: reference from SMA\r\n");
                Status = Configure_SI5338(SI5338_0_I2C_ADDR,'A',Reg_Store_PLL_0_SMA_SYS_CLK_25MHz,LOCK_MASK_0,LOS_MASK_0,phase_delay);
                break;
            default:
                xil_printf("Clock 0: reference UNKNOWN\r\n");
                Status = XST_FAILURE;
                break;
        }

        if(Status != XST_SUCCESS)
        {
            xil_printf("Clock 0: configuration error\r\n");

            return XST_FAILURE;
        }

        switch(clk_source_1) {
            case XTAL:
                xil_printf("Clock 1: reference from XTAL\r\n");
                Status = Configure_SI5338(SI5338_1_I2C_ADDR,'A',Reg_Store_PLL_1_XTAL,LOCK_MASK_0,LOS_MASK_0,0);
                break;
            case EXT:
                xil_printf("Clock 1: reference from EXT - REC\r\n");
                Status = Configure_SI5338(SI5338_1_I2C_ADDR,'A',Reg_Store_PLL_1_EXT,LOCK_MASK_1,LOS_MASK_1,0);
                break;
            case SMA:
                xil_printf("Clock 1: reference from SMA\r\n");
                Status = Configure_SI5338(SI5338_1_I2C_ADDR,'A',Reg_Store_PLL_1_SMA,LOCK_MASK_0,LOS_MASK_0,0);
                break;
            default:
                xil_printf("Clock 1: reference UNKNOWN\r\n");
                Status = XST_FAILURE;
                break;
        }

        if(Status != XST_SUCCESS)
        {
            xil_printf("Clock 1: configuration error\r\n");

            return XST_FAILURE;
        }
    }

    xil_printf("Clock : configured\r\n");

    return XST_SUCCESS;
}

/*****************************************************************************/
/**
* Main PLL interrupt handler.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void ClockMainPllInterruptHandler(void)
{
    /*
     * restart system
     */

    xil_printf("Clock interrupt - main pll\r\n");
}

/*****************************************************************************/
/**
* White Rabbit interrupt handler.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void ClockWrPllInterruptHandler(void)
{
    /*
     * restart system
     */

    xil_printf("Clock interrupt - wr pll\r\n");
}

/*****************************************************************************/
/**
* Configures SI5338 chip by writing it registers with the values taken from
* configuration table.
*
* @param    i2c_addr is an I2C bus address of the chip.
* @param    grade is an expected chip grade to be compared with internal one.
* @param    config_table is a pointer to configuration table.
* @param    lock_mask is a PLL lock mask to be used.
* @param    los_mask is a PLL lost of signal mask to be used.
* @param    phase_delay is a phase delay to be programmed.
*
* @return
*           - XST_SUCCESS on successful completion.
*           - XST_FAILURE on error.
*
* @note     None.
*
******************************************************************************/
static XStatus Configure_SI5338(u8 i2c_addr, char grade,
                                Reg_Data const * config_table,
                                u8 lock_mask,u8 los_mask,s16 phase_delay)
{
u32 counter;
u8 curr_chip_val, clear_curr_val, clear_new_val, combined, reg;
u8 chip_type;
char chip_grade;
Reg_Data curr;

    /*
     * check communication and part type
     */

    /* read chip type from dev_config_2 register */
    chip_type = I2C_ByteRead(i2c_addr,2) & 0x3F;

    /* read chip grade from dev_config_3 register */
    chip_grade = (I2C_ByteRead(i2c_addr,3) >> 3) + 0x40;

    if(chip_type != 38 || chip_grade != grade)
    {
        xil_printf(" No communication or wrong part type detected (type = %d, grade = %c)\r\n",chip_type,chip_grade);
        return XST_FAILURE;
    }

    xil_printf(" Correct part type detected (type = %d, grade = %c)\r\n",chip_type,chip_grade);

    usleep(SI5338_DELAY);

    I2C_ByteWrite(i2c_addr,230,0x10); /* OEB_ALL = 1 */
    I2C_ByteWrite(i2c_addr,241,0xE5); /* DIS_LOL = 1 */

    /*
     * for all the register values in the Reg_Store array
     * get each value and mask and apply it to the Si5338
     */

    for(counter=0; counter<NUM_REGS_MAX; counter++)
    {
        curr = config_table[counter];
        if(curr.Reg_Mask != 0x00)
        {
            if(curr.Reg_Mask == 0xFF)
            {
                /*
                 * do a write transaction only since the mask is all ones
                 */

                I2C_ByteWrite(i2c_addr,curr.Reg_Addr,curr.Reg_Val);
            }
            else
            {
                /*
                 * do a read-modify-write
                 */

                curr_chip_val = I2C_ByteRead(i2c_addr,curr.Reg_Addr);
                clear_curr_val = curr_chip_val & ~curr.Reg_Mask;
                clear_new_val = curr.Reg_Val & curr.Reg_Mask;
                combined = clear_new_val | clear_curr_val;
                I2C_ByteWrite(i2c_addr,curr.Reg_Addr,combined);
            }
        }
    }

    /*
     * adjust phase delay on all outputs ir required
     */

    if(phase_delay != 0)
    {
        xil_printf(" Adjusting phase (delay = %d ps)\r\n",phase_delay);

        AdjustPhaseDelay(i2c_addr,3,phase_delay);

        //AdjustPhaseDelayAll(i2c_addr,phase_delay);
    }

    /*
     * check LOS alarm for the xtal input on IN1 and IN2 (and IN3 if necessary)
     * change this mask if using inputs on IN4, IN5, IN6
     */

    reg = I2C_ByteRead(i2c_addr,218) & los_mask;

    counter = 0;

    while(reg != 0)
    {
        reg = I2C_ByteRead(i2c_addr,218) & los_mask;

        xil_printf(" LOS timeout\r\n");

        usleep(SI5338_TIMEOUT);

        counter++;

        if(counter >= SI5338_RETRY) {
            return XST_FAILURE;
        }
    }

    I2C_ByteWrite(i2c_addr,49,I2C_ByteRead(i2c_addr,49) & 0x7F); /* FCAL_OVRD_EN = 0 */
    I2C_ByteWrite(i2c_addr,246,2); /* soft reset */
    I2C_ByteWrite(i2c_addr,241,0x65); /* DIS_LOL = 0 */

    /*
     * wait for Si5338 to be ready after calibration (ie, soft reset)
     */

    usleep(SI5338_DELAY);

    /*
     * make sure the device locked by checking PLL_LOL and SYS_CAL
     */

    reg = I2C_ByteRead(i2c_addr,218) & lock_mask;

    counter = 0;

    while(reg != 0)
    {
        reg = I2C_ByteRead(i2c_addr,218) & lock_mask;

        xil_printf(" LOCK timeout\r\n");

        usleep(SI5338_TIMEOUT);

        counter++;

        if(counter >= SI5338_RETRY) {
            return XST_FAILURE;
        }
    }

    /*
     * copy FCAL values
     */

    I2C_ByteWrite(i2c_addr,45,I2C_ByteRead(i2c_addr,235));
    I2C_ByteWrite(i2c_addr,46,I2C_ByteRead(i2c_addr,236));

    /*
     * clear bits 0 and 1 from 47 and combine with bits 0 and 1 from 237
     */

    reg = (I2C_ByteRead(i2c_addr,47) & 0xFC) | (I2C_ByteRead(i2c_addr,237) & 3);
    I2C_ByteWrite(i2c_addr,47, reg);
    I2C_ByteWrite(i2c_addr,49, I2C_ByteRead(i2c_addr,49) | 0x80); /* FCAL_OVRD_EN = 1 */
    I2C_ByteWrite(i2c_addr,230, 0x00); /* OEB_ALL = 0 */

    return XST_SUCCESS;
}

/*****************************************************************************/
/**
* Adjusts phase delay of one of the main PLL channels.
*
* @param    channel is a number of channel.
* @param    phase_delay is a new phase delay to be programmed expressed
*           in [ps].
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
static void AdjustPhaseDelay(u8 i2c_addr, u8 channel, s32 phase_delay)
{
s16 val;
u8 reg_addr;
u8 byte_l, byte_h;

    Xil_AssertVoid(channel <= SI5338_CH_NUM - 1);

    /*
     * VCO frequency of the Si5338 is 2.5GHz
     *
     * phase delay[s] = (val[14:0]*1/Fvco)/128
     *
     * step = 0,003125ns
     */

    val = (phase_delay*1000)/3125;

    /*
     * address of the MS0_PHOFF[7:0] register is 107
     */

    reg_addr = 107 + channel*4;

    byte_l =  val & 0xFF;
    byte_h = (val >> 8) & 0x7F;

    /*
     * for channel 2 msb of the second
     * byte must be set to 1
     */

    if(channel == 2)  byte_h |= 0x80;

    I2C_ByteWrite(i2c_addr,reg_addr++,byte_l);
    I2C_ByteWrite(i2c_addr,reg_addr,byte_h);
}

/*****************************************************************************/
/**
* Adjusts phase delay of all the main PLL channels.
*
* @param    phase_delay is a new phase delay to be programmed expressed
*           in [ps].
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
static void AdjustPhaseDelayAll(u8 i2c_addr, s32 phase_delay)
{
int i;

    for(i = 0; i < SI5338_CH_NUM; i++)
    {
        AdjustPhaseDelay(i2c_addr,i,phase_delay);
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

    //xil_printf("i2c mw 0x%X 0x%X 0x%X\r\n", addr, reg, val);    
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
