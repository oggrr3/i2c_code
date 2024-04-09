`ifndef ASSERT
`define ASSERT

module assertion_cov(intf_i2c intf);
        //Feature_3 : cover property (@(posedge intf.clk)  (intf.count !=0)  |-> intf.reset == 0 );
        Check_PRDATA_change : assert   property ( (@(posedge intf.apb_clk)) (intf.psel & intf.penable) |-> stable(intf.prdata) )
                              else     $error("PRDATA changed while psel and penable hight at time = %0t", $time);

endmodule
`endif