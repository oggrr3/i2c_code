
`ifdef TEST1
    `include "test1_write_1_byte.sv"
`elsif TEST2
    `include "test2_read_1_byte.sv"
`endif 

module top ();
    //  Clock generator
    i2c_clk     =   0   ;
    apb_clk     =   0   ;

    always  #20    i2c_clk     =   ~i2c_clk    ;
    always  #5     apb_clk     =   ~apb_clk    ;

    //  DUT, assertion monitor, testcase instances
    intf_i2c    intf(i2c_clk, apb_clk)          ;
    i2c_dut     DUT (
        .i2c_core_clk_i (i2c_clk           )     ,   
        .pclk_i         (apb_clk           )     ,   
        .preset_ni      (intf.preset_n     )     ,   
        .paddr_i        (intf.paddr        )     ,     
        .pwrite_i       (intf.pwrite       )     ,   
        .psel_i         (intf.psel         )     ,   
        .penable_i      (intf.penable      )     ,   
        .pwdata_i       (intf.pwdata       )     ,   

        .prdata_o       (intf.prdata       )     ,   
        .pready_o       (intf.pready       )     ,   
        .sda            (intf.sda          )     ,
        .scl            (intf.scl          )     
    );
    testcase test(intf)                         ;

endmodule