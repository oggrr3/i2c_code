/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "sleep.h"
#include "xil_io.h"

int main()
{
    init_platform();
    int data;
//    u32 transmit_reg = XPAR_I2C_TOP_0_BASEADDR;				//	0x44A00000, but s_apb_i2c get 8 LSB bits (1-byte) to paddr, and start 0x00 is
//    u32 receive_reg	=	XPAR_I2C_TOP_0_BASEADDR + 1;
//    u32 status_reg = XPAR_I2C_TOP_0_BASEADDR + 8;
//    u32 slave_addr_reg = XPAR_I2C_TOP_0_BASEADDR + 12;
//    u32 command_reg = XPAR_I2C_TOP_0_BASEADDR + 16;
//    u32	prescale_reg = XPAR_I2C_TOP_0_BASEADDR + 20;

    u32 transmit_reg 	= 0x44A00000;				//	XPAR_I2C_TOP_0_BASEADDR 0x44A00000, but s_apb_i2c get 8 LSB bits (1-byte) to paddr, and start 0x00 is
    u32 receive_reg		= 0x44A00004;
    u32 status_reg 		= 0x44A00008;
    u32 slave_addr_reg 	= 0x44A0000c;
    u32 command_reg 	= 0x44A00010;
    u32	prescale_reg 	= 0x44A00014;

    xil_printf("Hello World VI nez\n\r");
    Xil_Out32(transmit_reg, 0x00);
    Xil_Out32(slave_addr_reg, 0xa6);
    Xil_Out32(prescale_reg, 0x06);
    xil_printf("Write to reg done\n\r");

    Xil_Out32(command_reg, 0xc0);
    sleep(2);											//	Sleep for micro second (us)

    print("Successfully write and then read\n\r");
    Xil_Out32(slave_addr_reg, 0xa7);
    Xil_Out32(command_reg, 0xc0);
    sleep(2);
    //while(1) {
    	data = (int) (Xil_In32(receive_reg));
    	xil_printf("Data Received = %d\n\r", data);
    	sleep(1);
    //}

//    xil_printf("Status = %lu", Xil_In32(status_reg));
    print("Successfully ran Hello World application\n\r");
    cleanup_platform();
    return 0;
}
