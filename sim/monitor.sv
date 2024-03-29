//  Sample DUT output then Compares with Exp

`ifdef MONITOR 
`define MONITOR

`include "scoreboard.sv"
`include "interface.sv"

class monitor;
    scoreboard          sb          ;
    virtrual intf_i2c   intf        ;


    function    new(virtrual intf_i2c intf, scoreboard  sb);
        this.intf   =   intf        ;
        this.sb     =   sb          ;
    endfunction

    task check();
        forever begin
            @ (posedge intf.apb_clk)
            if (intf.sda  !=  sb.sda)
                $error(" DUT sda is %b :: SB sda is %b at %d", intf.sda, sb.sda, $time);
            else
                $display(" DUT sda is %b :: SB sda is %b at %d", intf.sda, sb.sda, $time);
        end

    endtask

endclass

`endif 