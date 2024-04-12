`ifndef ASSERT
`define ASSERT

module assertion_cov(intf_i2c intf);
        //Feature_3 : cover property (@(posedge intf.clk)  (intf.count !=0)  |-> intf.reset == 0 );
        property p_prdata;
                @(posedge intf.apb_clk) (intf.psel & intf.penable) |-> $stable(intf.prdata) ;
        endproperty
        Check_PRDATA_change : assert   property (p_prdata)
                              else     $error("PRDATA changed while psel and penable hight at time = %0t", $time);

endmodule
`endif