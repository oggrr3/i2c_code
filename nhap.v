    .data_i               (             )         ,   // data from fifo buffer
    .addr_i               (             )         ,   // address of slave
    .count_bit_i          (             )         ,   // sda input
    .i2c_core_clk_i       (             )         ,   // i2c core clock
    .reset_ni             (             )         ,   // reset negetive signal from MCU
    .i2c_sda_i            (             )         ,   // sda line

    .sda_low_i            (             )         ,   // control sda signal from FSM, when 1 sda = 0
    .write_data_en_i      (             )         ,   // enable write data signal from FSM
    .write_addr_en_i      (             )         ,   // enable write slave's signal to sda 
    .receive_data_en_i    (             )         ,   // enable receive data from sda

    .data_from_sda_o      (             )         ,   // data from sda to write to FIFO buffer
    .i2c_sda_o            (             )         ,   // i2c sda output   
    .data_done            (             )            // finish processed data input and output  