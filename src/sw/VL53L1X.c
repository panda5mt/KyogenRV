#include <stdio.h>
#include <stdint.h>
#include "VL53L1X.h"
#include "xprintf.h"


void VL53L1X_writeReg(uint16_t reg, uint8_t value) {
    i2c_start_transmit(I2C_0_BASE,0x52>>1,0);    //bus->beginTransmission(address);
    i2c_write(I2C_0_BASE, (reg >> 8) & 0xFF, 0); //bus->write((reg >> 8) & 0xFF); // reg high byte
    i2c_write(I2C_0_BASE, reg & 0xFF, 0);//bus->write( reg       & 0xFF); // reg low byte
    i2c_write(I2C_0_BASE, value, 1);//bus->write(value);
    return;
}
// Write a 16-bit register
void VL53L1X_writeReg16Bit(uint16_t reg, uint16_t value) {
    i2c_start_transmit(I2C_0_BASE,0x52>>1,0);//bus->beginTransmission(address);
    i2c_write(I2C_0_BASE, (reg >> 8) & 0xFF, 0);//bus->write((reg >> 8) & 0xFF); // reg high byte
    i2c_write(I2C_0_BASE, reg & 0xFF, 0);//bus->write( reg       & 0xFF); // reg low byte

    i2c_write(I2C_0_BASE, (value >> 8) & 0xFF, 0);//bus->write((value >> 8) & 0xFF); // value high byte
    i2c_write(I2C_0_BASE, value & 0xFF, 1);//bus->write( value       & 0xFF); // value low byte
    //last_status = bus->endTransmission();
}

// Write a 32-bit register
void VL53L1X_writeReg32Bit(uint16_t reg, uint32_t value) {
    i2c_start_transmit(I2C_0_BASE,0x52>>1,0);//bus->beginTransmission(address);
    i2c_write(I2C_0_BASE, (reg >> 8) & 0xFF, 0);//bus->write((reg >> 8) & 0xFF); // reg high byte
    i2c_write(I2C_0_BASE, reg & 0xFF, 0);//bus->write( reg       & 0xFF); // reg low byte
    i2c_write(I2C_0_BASE, (value >> 24) & 0xFF, 0);
    i2c_write(I2C_0_BASE, (value >> 16) & 0xFF, 0);
    i2c_write(I2C_0_BASE, (value >> 8) & 0xFF, 0);
    i2c_write(I2C_0_BASE, value & 0xFF, 1);
}

uint8_t VL53L1X_readReg(uint16_t reg) {
    uint8_t value;

    i2c_start_transmit(I2C_0_BASE,0x52>>1,0);//bus->beginTransmission(address);
    i2c_write(I2C_0_BASE, (reg >> 8) & 0xFF, 0);//bus->write((reg >> 8) & 0xFF); // reg high byte
    i2c_write(I2C_0_BASE, reg & 0xFF, 1);//bus->write( reg       & 0xFF); // reg low byte
    //last_status = bus->endTransmission();

    i2c_start_transmit(I2C_0_BASE,0x52>>1,1);//bus->requestFrom(address, (uint8_t)1);
    value = i2c_read(I2C_0_BASE,1);//value = bus->read();

    return value;
}

// Read a 16-bit register
uint16_t VL53L1X_readReg16Bit(uint16_t reg) {
    uint16_t value;
    i2c_start_transmit(I2C_0_BASE,0x52>>1,0);
    i2c_write(I2C_0_BASE, (reg >> 8) & 0xFF, 0);
    i2c_write(I2C_0_BASE, reg & 0xFF, 1);

    i2c_start_transmit(I2C_0_BASE,0x52>>1,1);   //bus->requestFrom(address, (uint8_t)2);
    value = (uint16_t) (i2c_read(I2C_0_BASE,0) << 8); //value  = (uint16_t)bus->read() << 8; // value high byte
    value |= i2c_read(I2C_0_BASE,1);    // value low byte

    return value;
}

// Read a 32-bit register
uint32_t VL53L1X_readReg32Bit(uint16_t reg) {
    uint32_t value;

    i2c_start_transmit(I2C_0_BASE,0x52>>1,0);
    i2c_write(I2C_0_BASE, (reg >> 8) & 0xFF, 0);
    i2c_write(I2C_0_BASE, reg & 0xFF, 1);

    i2c_start_transmit(I2C_0_BASE,0x52>>1,1);

    value = (uint32_t) (i2c_read(I2C_0_BASE,0) << 24);//value  = (uint32_t)bus->read() << 24; // value highest byte
    value |= (uint32_t) (i2c_read(I2C_0_BASE,0) << 16);//bus->read() << 16;
    value |= (uint16_t) (i2c_read(I2C_0_BASE,0) << 8);//bus->read() <<  8;
    value |=  i2c_read(I2C_0_BASE,1);      // value lowest byte

    return value;
}


void VL53L1X_init(void) {
uint16_t fast_osc_frequency;
    uint16_t osc_calibrate_val;
    static const uint16_t TargetRate = 0x0A00;


    VL53L1X_writeReg(SOFT_RESET, 0x00);
    wait_ms(100);
    VL53L1X_writeReg(SOFT_RESET, 0x01);
    wait_ms(1000);
    while ((VL53L1X_readReg(FIRMWARE__SYSTEM_STATUS) & 0x01) == 0);

    // switch to 2V8 I/O
    VL53L1X_writeReg(PAD_I2C_HV__EXTSUP_CONFIG,
    VL53L1X_readReg(PAD_I2C_HV__EXTSUP_CONFIG) | 0x01);

    // store oscillator info for later use
    fast_osc_frequency = VL53L1X_readReg16Bit(OSC_MEASURED__FAST_OSC__FREQUENCY);
    osc_calibrate_val = VL53L1X_readReg16Bit(RESULT__OSC_CALIBRATE_VAL);

    // VL53L1_DataInit() end

    // VL53L1_StaticInit() begin

    // Note that the API does not actually apply the configuration settings below
    // when VL53L1_StaticInit() is called: it keeps a copy of the sensor's
    // register contents in memory and doesn't actually write them until a
    // measurement is started. Writing the configuration here means we don't have
    // to keep it all in memory and avoids a lot of redundant writes later.

    // the API sets the preset mode to LOWPOWER_AUTONOMOUS here:
    // VL53L1_set_preset_mode() begin

    // VL53L1_preset_mode_standard_ranging() begin

    // values labeled "tuning parm default" are from vl53l1_tuning_parm_defaults.h
    // (API uses these in VL53L1_init_tuning_parm_storage_struct())

    // static config
    // API resets PAD_I2C_HV__EXTSUP_CONFIG here, but maybe we don't want to do
    // that? (seems like it would disable 2V8 mode)
    VL53L1X_writeReg16Bit(DSS_CONFIG__TARGET_TOTAL_RATE_MCPS, TargetRate); // should already be this value after reset
    VL53L1X_writeReg(GPIO__TIO_HV_STATUS, 0x02);
    VL53L1X_writeReg(SIGMA_ESTIMATOR__EFFECTIVE_PULSE_WIDTH_NS, 8); // tuning parm default
    VL53L1X_writeReg(SIGMA_ESTIMATOR__EFFECTIVE_AMBIENT_WIDTH_NS, 16); // tuning parm default
    VL53L1X_writeReg(ALGO__CROSSTALK_COMPENSATION_VALID_HEIGHT_MM, 0x01);
    VL53L1X_writeReg(ALGO__RANGE_IGNORE_VALID_HEIGHT_MM, 0xFF);
    VL53L1X_writeReg(ALGO__RANGE_MIN_CLIP, 0); // tuning parm default
    VL53L1X_writeReg(ALGO__CONSISTENCY_CHECK__TOLERANCE, 2); // tuning parm default

    // general config
    VL53L1X_writeReg16Bit(SYSTEM__THRESH_RATE_HIGH, 0x0000);
    VL53L1X_writeReg16Bit(SYSTEM__THRESH_RATE_LOW, 0x0000);
    VL53L1X_writeReg(DSS_CONFIG__APERTURE_ATTENUATION, 0x38);

    // timing config
    // most of these settings will be determined later by distance and timing
    // budget configuration
    VL53L1X_writeReg16Bit(RANGE_CONFIG__SIGMA_THRESH, 360); // tuning parm default
    VL53L1X_writeReg16Bit(RANGE_CONFIG__MIN_COUNT_RATE_RTN_LIMIT_MCPS, 192); // tuning parm default

    // dynamic config

    VL53L1X_writeReg(SYSTEM__GROUPED_PARAMETER_HOLD_0, 0x01);
    VL53L1X_writeReg(SYSTEM__GROUPED_PARAMETER_HOLD_1, 0x01);
    VL53L1X_writeReg(SD_CONFIG__QUANTIFIER, 2); // tuning parm default

    // VL53L1_preset_mode_standard_ranging() end

    // from VL53L1_preset_mode_timed_ranging_*
    // GPH is 0 after reset, but writing GPH0 and GPH1 above seem to set GPH to 1,
    // and things don't seem to work if we don't set GPH back to 0 (which the API
    // does here).
    VL53L1X_writeReg(SYSTEM__GROUPED_PARAMETER_HOLD, 0x00);
    VL53L1X_writeReg(SYSTEM__SEED_CONFIG, 1); // tuning parm default

    // from VL53L1_config_low_power_auto_mode
    VL53L1X_writeReg(SYSTEM__SEQUENCE_CONFIG, 0x8B); // VHV, PHASECAL, DSS1, RANGE
    VL53L1X_writeReg16Bit(DSS_CONFIG__MANUAL_EFFECTIVE_SPADS_SELECT, 200 << 8);
    VL53L1X_writeReg(DSS_CONFIG__ROI_MODE_CONTROL, 2); // REQUESTED_EFFFECTIVE_SPADS

    // VL53L1_set_preset_mode() end

    // default to long range, 50 ms timing budget
    // note that this is different than what the API defaults to
    //setDistanceMode(Long);
    //setMeasurementTimingBudget(50000);

    // VL53L1_StaticInit() end

    // the API triggers this change in VL53L1_init_and_start_range() once a
    // measurement is started; assumes MM1 and MM2 are disabled
    VL53L1X_writeReg16Bit(ALGO__PART_TO_PART_RANGE_OFFSET_MM,
    VL53L1X_readReg16Bit(MM_CONFIG__OUTER_OFFSET_MM) * 4);


    //uint32_t aaa = VL53L1X_readReg(FIRMWARE__SYSTEM_STATUS);
    xprintf("I2C Init OK!\r\n...freq=%d\r\noscval=%d\r\n",fast_osc_frequency,osc_calibrate_val);
    return;

}