module i2c_dut 
(
    input                               i2c_core_clk_i      ,   // clock core of i2c
    input                               pclk_i              ,   //  APB clock
    input                               preset_ni           ,   //  reset signal is active-LOW
    input   [7 : 0]         			paddr_i             ,   //  address of APB slave and inputister map
    input                               pwrite_i            ,   //  HIGH is write, LOW is read
    input                               psel_i              ,   //  select slave interface
    input                               penable_i           ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    input   [7 : 0]         			pwdata_i            ,   //  data write

    output  [7 : 0]         			prdata_o            ,   //  data read
    output                              pready_o            ,   //  ready to receive data
    output                              sda_io              ,
    output                              scl_io              
);

    i2c_top     i2c_master_top (
        .i2c_core_clk_i (i2c_core_clk_i )     ,   // clock core of i2c
        .pclk_i         (pclk_i         )     ,   //  APB clock
        .preset_ni      (preset_ni      )     ,   //  reset signal is active-LOW
        .paddr_i        (paddr_i        )     ,   //  address of APB slave and register map
        .pwrite_i       (pwrite_i       )     ,   //  HIGH is write, LOW is read
        .psel_i         (psel_i         )     ,   //  select slave interface
        .penable_i      (penable_i      )     ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
        .pwdata_i       (pwdata_i       )     ,   //  data write

        .prdata_o       (prdata_o       )     ,   //  data read
        .pready_o       (pready_o       )     ,   //  ready to receive data
        .sda            (sda_io         )     ,
        .scl            (scl_io         )     
    );

    i2c_slave_model i2c_slave   (
        .sda    (sda_io )   ,
        .scl    (scl_io )   
    );
    
endmodule