#include <stdio.h>
#include <stdint.h>
#include "qsys_i2c.h"


/* offsets */
/*
    uint32_t tfr_cmd = i2c_base + TFR_CMD_OFFSET;
    uint32_t ctrl = i2c_base + CTRL_OFFSET;
    uint32_t iser = i2c_base + ISER_OFFSET;
    uint32_t isr = i2c_base + ISR_OFFSET;
    uint32_t scl_low = i2c_base + SCL_LOW_OFFSET;
    uint32_t scl_high = i2c_base + SCL_HIGH_OFFSET;
    uint32_t sda_hold = i2c_base + SDA_HOLD_OFFSET;
*/

void i2c_init(uint32_t i2c_base, uint32_t i2c_freq) {

    uint32_t ctrl = i2c_base + CTRL_OFFSET;

    // disable I2C
    uint32_t ctrl_param = get32(ctrl);
    ctrl_param = ctrl_param & 0xFFFFFFFFE;
    ctrl_param = ctrl_param | 0x02;
    put32(ctrl, ctrl_param);

    // 400kHz config and enable i2c core
    ctrl_param = get32(ctrl);
    ctrl_param |= 0x03;
    put32(ctrl, ctrl_param);

}

void i2c_disable_isr(uint32_t i2c_base){}

void i2c_start_transmit(uint32_t i2c_base, uint8_t i2c_slave_address, uint8_t is_Read) {
    if(1 != is_Read) is_Read = 0; // isRead != 1 : Write

    //[31:10]rsv,[9]STA=1, [8]STO=0,[7:1]AD=i2c_slave_address(7bit),[0]RW_D=0
    uint32_t tfr_cmd = i2c_base + TFR_CMD_OFFSET;
    uint32_t isr = i2c_base + ISR_OFFSET;

    // ISR[0]:TX_READY=1?(1:OK to send?)
    while(!(get32(isr) & 0x0001));     //while(!(*(volatile uint32_t *)isr & 0x0001));

    // send Start + I2C Slave address
    if(is_Read){
        put32(tfr_cmd,  (1U << 9) + (0U << 8) + (i2c_slave_address << 1) + 1);
    } // read
    else {
        put32(tfr_cmd,  (1U << 9) + (0U << 8) + (i2c_slave_address << 1) + 0);
    } // write

    return ;
}

uint32_t i2c_start_receive(uint32_t i2c_base, uint8_t i2c_slave_address) {
    return 0;
}


uint32_t i2c_write(uint32_t i2c_base, uint8_t data, bool send_stop_bit) {

    uint32_t tfr_cmd = i2c_base + TFR_CMD_OFFSET;
    uint32_t isr = i2c_base + ISR_OFFSET;

    // ISR[0]:TX_READY=1?(1:OK to send?)
    while(!(get32(isr) & 0x0001));  //	while(!(*(volatile uint32_t *)isr & 0x0001));
    // send Start + I2C Slave address

    if(1U == send_stop_bit)
        put32(tfr_cmd ,(0U << 9) + (1U << 8) + (data));
    else
        put32(tfr_cmd ,(0U << 9) + (0U << 8) + (data));

    return 0;
}

uint32_t i2c_read(uint32_t i2c_base, bool send_stop_bit) {

    uint32_t tfr_cmd = i2c_base + TFR_CMD_OFFSET;
    uint32_t rx_data = i2c_base + RX_DATA_OFFSET;
    uint32_t isr = i2c_base + ISR_OFFSET;

    // ISR[0]:TX_READY=1?(1:OK to send?)
    while(!(get32(isr) & 0x0001));

    if(1U == send_stop_bit)
        put32(tfr_cmd, (0U << 9) + (1U << 8) + (0x00));
    else
        put32(tfr_cmd, (0U << 9) + (0U << 8) + (0x00));

    // ISR[1]:RX_READY=1?(1:RX finish)
    while(!(get32(isr) & 0x0002));

    //return *(volatile uint32_t*)rx_data;
    return (get32(rx_data));
}
