`ifndef ENV
`define ENV

`include "driver.sv"
//`include "scoreboard.sv"
`include "interface.sv"

class environment;
          driver drvr;
           virtual intf_i2c intf;
           
           function new(virtual intf_i2c intf);
                 this.intf = intf;
             
                 drvr = new(intf);
              
           endfunction
           
endclass

`endif