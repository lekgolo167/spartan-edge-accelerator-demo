
# Clock signal 100 MHz
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports sys_clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports sys_clk]
create_clock -period 100.000 -name esp_qspi_clk -waveform {0.000 50.000} [get_ports esp_qspi_clk]

# Note: D0 - D1 are used as UART RX TX and require an output enable signal
# ARDUINO_D2 - D7
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports {ar_d[0]}]
set_property -dict {PACKAGE_PIN B6  IOSTANDARD LVCMOS33} [get_ports {ar_d[1]]}]
set_property -dict {PACKAGE_PIN A5  IOSTANDARD LVCMOS33} [get_ports {ar_d[2]}]
set_property -dict {PACKAGE_PIN B5  IOSTANDARD LVCMOS33} [get_ports {ar_d[3]}]
set_property -dict {PACKAGE_PIN A4  IOSTANDARD LVCMOS33} [get_ports {ar_d[4]}]
set_property -dict {PACKAGE_PIN A3  IOSTANDARD LVCMOS33} [get_ports {ar_d[5]}]

# ARDUINO_D8 - D13
set_property -dict {PACKAGE_PIN B3  IOSTANDARD LVCMOS33} [get_ports {ar_d[6]}]
set_property -dict {PACKAGE_PIN A2  IOSTANDARD LVCMOS33} [get_ports {ar_d[7]}]
set_property -dict {PACKAGE_PIN B2  IOSTANDARD LVCMOS33} [get_ports {ar_d[8]}]
set_property -dict {PACKAGE_PIN B1  IOSTANDARD LVCMOS33} [get_ports {ar_d[9]}]
set_property -dict {PACKAGE_PIN H1  IOSTANDARD LVCMOS33} [get_ports {ar_d[10]}]
set_property -dict {PACKAGE_PIN H2  IOSTANDARD LVCMOS33} [get_ports {ar_d[11]}]

# FPGA_IO_0 - IO_9
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {fpga_io[0]}]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {fpga_io[1]}]
set_property -dict {PACKAGE_PIN C4  IOSTANDARD LVCMOS33} [get_ports {fpga_io[2]}]
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS33} [get_ports {fpga_io[3]}]
set_property -dict {PACKAGE_PIN N10 IOSTANDARD LVCMOS33} [get_ports {fpga_io[4]}]
set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVCMOS33} [get_ports {fpga_io[5]}]
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVCMOS33} [get_ports {fpga_io[6]}]
set_property -dict {PACKAGE_PIN D3  IOSTANDARD LVCMOS33} [get_ports {fpga_io[7]}]
set_property -dict {PACKAGE_PIN P5  IOSTANDARD LVCMOS33} [get_ports {fpga_io[8]}]
set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVCMOS33} [get_ports {fpga_io[9]}]

# FPGA_LED_1 - LED_2
set_property -dict {PACKAGE_PIN J1  IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports {led[1]}]

# FPGA_RGB
set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports {led_rgb}]

# K1 - K4
set_property -dict {PACKAGE_PIN M2  IOSTANDARD LVCMOS33} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN L2  IOSTANDARD LVCMOS33} [get_ports {sw[1]}]
set_property -dict {PACKAGE_PIN L3  IOSTANDARD LVCMOS33} [get_ports {sw[2]}]
set_property -dict {PACKAGE_PIN K3  IOSTANDARD LVCMOS33} [get_ports {sw[3]}]

# USER_1 - USER_2
set_property -dict {PACKAGE_PIN C3  IOSTANDARD LVCMOS33} [get_ports {usr_btns[0]}]
set_property -dict {PACKAGE_PIN M4  IOSTANDARD LVCMOS33} [get_ports {usr_btns[1]}]

# FPGA_RST
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports {fpga_rst}]

# FPGA_QSPI
set_property -dict {PACKAGE_PIN P2  IOSTANDARD LVCMOS33} [get_ports esp_qspi_d]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports esp_qspi_clk]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports esp_qspi_cs]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports esp_qspi_q]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports esp_qspi_hd]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports esp_qspi_wp]

# FPGA_SPI_OE
set_property -dict {PACKAGE_PIN M3  IOSTANDARD LVCMOS33} [get_ports ar_spi_sck]

# FPGA_SPI
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports ar_spi_sck]
set_property -dict {PACKAGE_PIN M5  IOSTANDARD LVCMOS33} [get_ports ar_spi_mosi]
set_property -dict {PACKAGE_PIN L5  IOSTANDARD LVCMOS33} [get_ports ar_spi_miso]
set_property -dict {PACKAGE_PIN K4  IOSTANDARD LVCMOS33} [get_ports ar_reset]

# FPGA_UART_I2C_OE
set_property -dict {PACKAGE_PIN N4  IOSTANDARD LVCMOS33} [get_ports ar_spi_sck]

# FPGA_UART
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports {}]
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports {}]

# FPGA_I2C
set_property -dict {PACKAGE_PIN P12 IOSTANDARD LVCMOS33} [get_ports {i2c_scl}]
set_property -dict {PACKAGE_PIN P13 IOSTANDARD LVCMOS33} [get_ports {i2c_sda}]

# FPGA_ESP_ANALOG_SWITCH
# When LOW, the ESP32 is connected to the fpga i2c pins
# When HIGH, the ESP32 is connected to analog pins A4 - A5
set_property -dict {PACKAGE_PIN H3  IOSTANDARD TMDS_33}  [get_ports {esp_input_sel}]

# GPIO_FPGA_ESP
# Used during configuration of FPGA to load bit stream form the ESP32
# Could be used as an interrupt to the ESP32 after configuration or as GPIO
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports esp32_io]

# FLASH
# Shared with the ESP32
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports flash_scs]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports flash_sck]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports flash_sdo]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports flash_sdi]

# ARDUINO_3V3
set_property -dict {PACKAGE_PIN L13 IOSTANDARD TMDS_33}  [get_ports {ar_3v3_en}]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD TMDS_33}  [get_ports {ar_3v3_det}]

# IMU_AD
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {imu_ad}]
# IMU_INT2
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS33} [get_ports {imu_int2}]

# ADC1173_OE
set_property -dict {PACKAGE_PIN J4  IOSTANDARD LVCMOS33} [get_ports {adc_oe_n}]

# ADC1173_CLK
set_property -dict {PACKAGE_PIN C5  IOSTANDARD LVCMOS33} [get_ports {adc_clk}]

# ADC1173_DATA
set_property -dict {PACKAGE_PIN J3  IOSTANDARD LVCMOS33} [get_ports {adc_raw_data[0]}]
set_property -dict {PACKAGE_PIN J2  IOSTANDARD LVCMOS33} [get_ports {adc_raw_data[1]}]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports {adc_raw_data[2]}]
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports {adc_raw_data[3]}]
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS33} [get_ports {adc_raw_data[4]}]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {adc_raw_data[5]}]
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33} [get_ports {adc_raw_data[6]}]
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS33} [get_ports {adc_raw_data[7]}]

# DAC7311 CLK
set_property -dict {PACKAGE_PIN M1  IOSTANDARD LVCMOS33} [get_ports {dac_serial_clk}]

# DAC7311 SYNC
set_property -dict {PACKAGE_PIN N1  IOSTANDARD LVCMOS33} [get_ports {dac_sync}]

# DAC7311 DATA
set_property -dict {PACKAGE_PIN L1  IOSTANDARD LVCMOS33} [get_ports {dac_serial_data}]

# HDMI TX
set_property -dict {PACKAGE_PIN D4  IOSTANDARD TMDS_33}  [get_ports {hdmi_hpd_det}]
set_property -dict {PACKAGE_PIN F2  IOSTANDARD TMDS_33}  [get_ports {hdmi_sda}]
set_property -dict {PACKAGE_PIN F3  IOSTANDARD TMDS_33}  [get_ports {hdmi_scl}]
set_property -dict {PACKAGE_PIN E4  IOSTANDARD TMDS_33}  [get_ports {hdmi_cec}]
set_property -dict {PACKAGE_PIN F4  IOSTANDARD TMDS_33}  [get_ports {hdmi_tck_n}]
set_property -dict {PACKAGE_PIN G4  IOSTANDARD TMDS_33}  [get_ports {hdmi_tck_p}]
set_property -dict {PACKAGE_PIN F1  IOSTANDARD TMDS_33}  [get_ports {hdmi_td_n[0]}]
set_property -dict {PACKAGE_PIN G1  IOSTANDARD TMDS_33}  [get_ports {hdmi_td_p[0]}]
set_property -dict {PACKAGE_PIN D2  IOSTANDARD TMDS_33}  [get_ports {hdmi_td_n[1]}]
set_property -dict {PACKAGE_PIN E2  IOSTANDARD TMDS_33}  [get_ports {hdmi_td_p[1]}]
set_property -dict {PACKAGE_PIN C1  IOSTANDARD TMDS_33}  [get_ports {hdmi_td_n[2]}]
set_property -dict {PACKAGE_PIN D1  IOSTANDARD TMDS_33}  [get_ports {hdmi_td_p[2]}]

# CAMERA
set_property -dict {PACKAGE_PIN F11 IOSTANDARD LVCMOS33} [get_ports {cam_c_n}]
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports {cam_c_p}]
set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVCMOS33} [get_ports {cam_scl}]
set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVCMOS33} [get_ports {cam_d_n[0]}]
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS33} [get_ports {cam_d_p[0]}]
set_property -dict {PACKAGE_PIN P11 IOSTANDARD LVCMOS33} [get_ports {cam_d_n[1]}]
set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVCMOS33} [get_ports {cam_d_p[1]}]
set_property -dict {PACKAGE_PIN M11 IOSTANDARD LVCMOS33} [get_ports {cam_gpio1}]
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS33} [get_ports {cam_rst}]
# Connected to cam_d_p[0]
set_property -dict {PACKAGE_PIN C10 IOSTANDARD LVCMOS33} [get_ports {fpga_io12}]
# Connected to cam_d_p[0]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports {fpga_io13}]

# FPGA_SEA_VERSION_PINS
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {version[0]}]
set_property -dict {PACKAGE_PIN P3  IOSTANDARD LVCMOS33} [get_ports {version[1]}]
set_property -dict {PACKAGE_PIN P4  IOSTANDARD LVCMOS33} [get_ports {version[2]}]


#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets esp_qspi_clk_IBUF]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets esp_qspi_cs_IBUF]