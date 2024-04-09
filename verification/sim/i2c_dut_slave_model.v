module i2c_dut_slave_model 
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

    top_level     dut (
        .PCLK       (pclk_i),
        .PRESETn    (preset_ni),
        .PSELx      (psel_i),
        .PWRITE     (pwrite_i),
        .PENABLE    (penable_i),
        .PADDR      (paddr_i),
        .PWDATA     (pwdata_i),
        .core_clk   (i2c_core_clk_i),

        .PREADY     (pready_o),
        .PRDATA     (prdata_o),
        .sda        (sda_io),
        .scl        (scl_io)
    );

    i2c_slave_model i2c_slave   (
        .sda    (sda_io )   ,
        .scl    (scl_io )   
    );
    
endmodule