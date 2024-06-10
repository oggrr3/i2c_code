//`include "stimulus.sv"
`include "interface.sv"
//`include "scoreboard.sv"
//`include "driver.sv"
//`include "monitor.sv"
//`include "env.sv"
`include "assertion.sv"

//`include "test_2.sv"

`ifdef TEST1
  `include "test_1.sv"
`elsif TEST2
  `include "test_2.sv"
`elsif TEST3
  `include "test_3.sv"
`elsif TEST4
  `include "test_4.sv"
`elsif TEST5
  `include "test_5.sv"
`elsif TEST6
  `include "test_6.sv"
`elsif TEST7
  `include "test_7.sv"
`elsif TEST8
  `include "test_8.sv"
`elsif TEST9
  `include "test_9.sv"
`elsif TEST10
  `include "test_10.sv"
`elsif TEST11
  `include "test_11.sv"
`elsif TEST12
  `include "test_12.sv"
`endif

module top();

    //  Clock generator
    reg     i2c_clk     =   0   ;
    reg     apb_clk     =   0   ;

    always  #20    i2c_clk     =   ~i2c_clk    ;
    always  #10     apb_clk     =   ~apb_clk    ;

    //  DUT, assertion monitor, testcase instances
    intf_i2c    intf(i2c_clk, apb_clk)          ;

    // i2c_dut_slave_model     TOP (
    //     .i2c_core_clk_i (i2c_clk           )     ,   
    //     .pclk_i         (apb_clk           )     ,   
    //     .preset_ni      (intf.preset_n     )     ,   
    //     .paddr_i        (intf.paddr        )     ,     
    //     .pwrite_i       (intf.pwrite       )     ,   
    //     .psel_i         (intf.psel         )     ,   
    //     .penable_i      (intf.penable      )     ,   
    //     .pwdata_i       (intf.pwdata       )     ,   

    //     .prdata_o       (intf.prdata       )     ,   
    //     .pready_o       (intf.pready       )     ,   
    //     .sda_io         (intf.sda          )     ,
    //     .scl_io         (intf.scl          )     
    // );

    top_level     dut (
        .PCLK       (apb_clk),
        .PRESETn    (intf.preset_n),
        .PSELx      (intf.psel),
        .PWRITE     (intf.pwrite),
        .PENABLE    (intf.penable),
        .PADDR      (intf.paddr),
        .PWDATA     (intf.pwdata),
        .core_clk   (i2c_clk),

        .PREADY     (intf.pready),
        .PRDATA     (intf.prdata),
        .sda        (intf.sda),
        .scl        (intf.scl)
    );

    i2c_slave_model  i2c_slave_model (
        .sda  (intf.sda)  ,
        .scl  (intf.scl)
    );

    testcase test(intf)                         ;
    assertion_cov acov(intf)                    ;
endmodule