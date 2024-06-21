# Set GPIO for sda and scl
set_property PACKAGE_PIN A14      [get_ports sda_0] ;# Bank  16 VCCO - VCCO_3V3 - IO_L1P_T0_16
set_property IOSTANDARD  LVCMOS33 [get_ports sda_0] ;# Bank  16 VCCO - VCCO_3V3 - IO_L1P_T0_16
set_property PACKAGE_PIN A15      [get_ports scl_0] ;# Bank  16 VCCO - VCCO_3V3 - IO_L1N_T0_16
set_property IOSTANDARD  LVCMOS33 [get_ports scl_0] ;# Bank  16 VCCO - VCCO_3V3 - IO_L1N_T0_16

# Setting pull-up resistors for I2C lines
#set_property PULLUP true [get_ports scl_0];
#set_property PULLUP true [get_ports sda_0];