# Constraints clock
create_clock -period 10.000 -name pclk_i -waveform {0.000 5.000} -add [get_ports pclk_i]
create_clock -period 20.000 -name i2c_core_clk_i -waveform {0.000 10.000} -add [get_ports i2c_core_clk_i]

## Create primary clocks
#create_clock -name pclk_i -period 10 [get_ports pclk_i]  # 100 MHz clock
#create_clock -name i2c_core_clk_i -period 20 [get_ports i2c_core_clk_i]  # 50 MHz clock

## Define clock groups as asynchronous
#set_clock_groups -logically_exclusive -group [get_clocks pclk_i] -group [get_clocks i2c_core_clk_i]

## Define false paths between these clock domains (optional, if no paths should be analyzed)
#set_false_path -from [get_clocks pclk_i] -to [get_clocks i2c_core_clk_i]
#set_false_path -from [get_clocks i2c_core_clk_i] -to [get_clocks pclk_i]

##set_clock_groups -asynchronous -group [get_clocks pclk_i] -group [get_clocks i2c_core_clk_i]
##create_clock -period 10 -name pclk_i [get_ports pclk_i]
##create_generated_clock -source [get_ports pclk_i] -name i2c_core_clk_i -divide_by 2 [get_ports i2c_core_clk_i]

#set_property PACKAGE_PIN AE7      [get_ports "pclk_i"] ;# Bank  33 VCCO - VCCO_2V5 - IO_L17P_T2_33
#set_property IOSTANDARD  LVDS_25  [get_ports "pclk_i"] ;# Bank  33 VCCO - VCCO_2V5 - IO_L17P_T2_33
#set_property PACKAGE_PIN AE8      [get_ports "i2c_core_clk_i"] ;# Bank  33 VCCO - VCCO_2V5 - IO_L17N_T2_33
#set_property IOSTANDARD  LVDS_25  [get_ports "i2c_core_clk_i"] ;# Bank  33 VCCO - VCCO_2V5 - IO_L17N_T2_33

# Setting pull-up resistors for I2C lines
set_property PULLUP true [get_ports scl]
set_property PULLUP true [get_ports sda]

