var g_data = {"name":"../sim/i2c_dut_slave_model.v","src":"module i2c_dut_slave_model \r\n(\r\n    input                               i2c_core_clk_i      ,   // clock core of i2c\r\n    input                               pclk_i              ,   //  APB clock\r\n    input                               preset_ni           ,   //  reset signal is active-LOW\r\n    input   [7 : 0]         			paddr_i             ,   //  address of APB slave and inputister map\r\n    input                               pwrite_i            ,   //  HIGH is write, LOW is read\r\n    input                               psel_i              ,   //  select slave interface\r\n    input                               penable_i           ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.\r\n    input   [7 : 0]         			pwdata_i            ,   //  data write\r\n\r\n    output  [7 : 0]         			prdata_o            ,   //  data read\r\n    output                              pready_o            ,   //  ready to receive data\r\n    output                              sda_io              ,\r\n    output                              scl_io              \r\n);\r\n\r\n    top_level     dut (\r\n        .PCLK       (pclk_i),\r\n        .PRESETn    (preset_ni),\r\n        .PSELx      (psel_i),\r\n        .PWRITE     (pwrite_i),\r\n        .PENABLE    (penable_i),\r\n        .PADDR      (paddr_i),\r\n        .PWDATA     (pwdata_i),\r\n        .core_clk   (i2c_core_clk_i),\r\n\r\n        .PREADY     (pready_o),\r\n        .PRDATA     (prdata_o),\r\n        .sda        (sda_io),\r\n        .scl        (scl_io)\r\n    );\r\n\r\n    i2c_slave_model i2c_slave   (\r\n        .sda    (sda_io )   ,\r\n        .scl    (scl_io )   \r\n    );\r\n    \r\nendmodule","lang":"verilog"};
processSrcData(g_data);