module i2c_core     #(parameter     DATA_SIZE   =   8   ,
                      parameter     ADDR_SIZE   =   8   )
(
    input   [DATA_SIZE - 1]     data_transmit_i                 ,
    input   [ADDR_SIZE - 1]     slave_addr_rw_i                 ,
    input   [7 : 0]             command_i                       ,
    input   [7 : 0]             prescale_i                      ,
    input                       i2c_core_clk_i                  ,
    input                       APB_clk_i                       ,
    input                       i2c_sda_i                       ,
    input                       i2c_scl_i                       ,

    output                      i2c_sda_o                       ,
    output                      i2c_scl_o                       ,
    output                      interrupt_o                     ,


);


    
endmodule