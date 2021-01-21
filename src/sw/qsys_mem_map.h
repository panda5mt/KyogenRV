#ifndef _ALTERA_QSYS_MEM_MAP_H_
#define _ALTERA_QSYS_MEM_MAP_H_

/*
 * This file was automatically generated by the swinfo2header utility.
 * 
 * Created from SOPC Builder system 'kyogenrv_fpga' in
 * file 'C:\RISCV\kyogenrv\fpga/kyogenrv_fpga.swinfo'.
 */

/*
 * This file contains macros for module 'KyogenRV_0' and devices
 * connected to the following master:
 *   avalon_data_master
 * This master belong to master group 'KyogenRV_0_avalon_data_master'
 * 
 * Do not include this header file and another header file created for a
 * different module or master group at the same time.
 * Doing so may result in duplicate macro names.
 * Instead, use the system header file which has macros with unique names.
 */

/*
 * Macros for device 'onchip_memory2_0', class 'altera_avalon_onchip_memory2'
 * The macros are prefixed with 'ONCHIP_MEMORY2_0_'.
 * The prefix is the slave descriptor.
 */
#define ONCHIP_MEMORY2_0_COMPONENT_TYPE altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_COMPONENT_NAME onchip_memory2_0
#define ONCHIP_MEMORY2_0_BASE 0x0
#define ONCHIP_MEMORY2_0_SPAN 32768
#define ONCHIP_MEMORY2_0_END 0x7fff
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE AUTO
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE blinker_intel
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID NONE
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 1
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE AUTO
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE DONT_CARE
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 1
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 32768
#define ONCHIP_MEMORY2_0_WRITABLE 1
#define ONCHIP_MEMORY2_0_MEMORY_INFO_DAT_SYM_INSTALL_DIR SIM_DIR
#define ONCHIP_MEMORY2_0_MEMORY_INFO_GENERATE_DAT_SYM 1
#define ONCHIP_MEMORY2_0_MEMORY_INFO_GENERATE_HEX 1
#define ONCHIP_MEMORY2_0_MEMORY_INFO_HAS_BYTE_LANE 0
#define ONCHIP_MEMORY2_0_MEMORY_INFO_HEX_INSTALL_DIR QPF_DIR
#define ONCHIP_MEMORY2_0_MEMORY_INFO_MEM_INIT_DATA_WIDTH 32
#define ONCHIP_MEMORY2_0_MEMORY_INFO_MEM_INIT_FILENAME blinker_intel

/*
 * Macros for device 'pio_0', class 'altera_avalon_pio'
 * The macros are prefixed with 'PIO_0_'.
 * The prefix is the slave descriptor.
 */
#define PIO_0_COMPONENT_TYPE altera_avalon_pio
#define PIO_0_COMPONENT_NAME pio_0
#define PIO_0_BASE 0x8000
#define PIO_0_SPAN 16
#define PIO_0_END 0x800f
#define PIO_0_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_0_CAPTURE 0
#define PIO_0_DATA_WIDTH 8
#define PIO_0_DO_TEST_BENCH_WIRING 0
#define PIO_0_DRIVEN_SIM_VALUE 0
#define PIO_0_EDGE_TYPE NONE
#define PIO_0_FREQ 70000000
#define PIO_0_HAS_IN 0
#define PIO_0_HAS_OUT 1
#define PIO_0_HAS_TRI 0
#define PIO_0_IRQ_TYPE NONE
#define PIO_0_RESET_VALUE 0

/*
 * Macros for device 'uart_0', class 'altera_avalon_uart'
 * The macros are prefixed with 'UART_0_'.
 * The prefix is the slave descriptor.
 */
#define UART_0_COMPONENT_TYPE altera_avalon_uart
#define UART_0_COMPONENT_NAME uart_0
#define UART_0_BASE 0x8020
#define UART_0_SPAN 32
#define UART_0_END 0x803f
#define UART_0_BAUD 9600
#define UART_0_DATA_BITS 8
#define UART_0_FIXED_BAUD 1
#define UART_0_FREQ 70000000
#define UART_0_PARITY 'N'
#define UART_0_SIM_CHAR_STREAM ""
#define UART_0_SIM_TRUE_BAUD 0
#define UART_0_STOP_BITS 1
#define UART_0_SYNC_REG_DEPTH 2
#define UART_0_USE_CTS_RTS 0
#define UART_0_USE_EOP_REGISTER 0


#endif /* _ALTERA_QSYS_MEM_MAP_H_ */
