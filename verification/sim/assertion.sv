`ifndef ASSERT
`define ASSERT

   module assertion_cov(intf_i2c intf);
        //Feature_3 : cover property (@(posedge intf.clk)  (intf.count !=0)  |-> intf.reset == 0 );
    endmodule
`endif