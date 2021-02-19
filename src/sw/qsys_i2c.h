#ifndef _QSYS_I2C_H_
#define _QSYS_I2C_H_

#include "krv_utils.h"

#include <stdint.h>
#include <stdbool.h>

// define I2C_0_BASE 0xxxxxx
// See "ug_embedded_ip" p.172"
#define TFR_CMD_OFFSET				(0x0 * 4)	//[31:10]resv, 9:STA, 8:STO, [7:1]AD, 0:RW_D
#define RX_DATA_OFFSET				(0x1 * 4)	//[31:8]resv, [7:0]RXDATA
#define CTRL_OFFSET					(0x2 * 4)
#define ISER_OFFSET					(0x3 * 4)
#define ISR_OFFSET					(0x4 * 4)
#define STATUS_OFFSET				(0x5 * 4)
#define TFR_CMD_FIFO_LVL_OFFSET		(0x6 * 4)
#define RX_DATA_FIFO_LVL_OFFSET		(0x7 * 4)
#define SCL_LOW_OFFSET				(0x8 * 4)
#define SCL_HIGH_OFFSET				(0x9 * 4)
#define SDA_HOLD_OFFSET				(0xA * 4)

void i2c_init(uint32_t);
void i2c_disable_isr(uint32_t);
void i2c_start_transmit(uint32_t, uint8_t, uint8_t);
//uint32_t i2c_start_transmit(uint32_t* i2c_base, uint8_t i2c_slave_address);

uint32_t i2c_start_receive(uint32_t, uint8_t);
uint32_t i2c_write(uint32_t, uint8_t , bool);
uint32_t i2c_read(uint32_t, bool);



#endif // _QSYS_I2C_H_
