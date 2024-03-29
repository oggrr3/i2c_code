`ifdef ENVIRONMENT
`define ENVIRONMENT

`include "generator.sv"
`include "driver.sv"
`include "scoreboard.sv"
`include "monitor.sv"
`include "interface.sv"

class environment;
    generator           gen             ;
    driver              drvr            ;
    scoreboard          sb              ;
    monitor             mntr            ;
    virtrual intf_i2c   intf            ;  

    mailbox             gen2driv        ;   //  Handle mailbox from generator to driver   
    mailbox             sb2mntr         ;   //  Handle mailbox from scoreboard to monitor

    event               gen_ended       ;   //  event for synchrozation between generator and test

    function    new (virtrual intf_i2c intf);
        this.intf   =   intf            ;

        //  Creating the mailbox
        gen2driv    =   new()           ;
        sb2mntr     =   new()           ;

        // Creating generator and driver
        gen         =   new(gen2driv, ended)    ;
        drvr        =   new(intf, sb, gen2driv) ;
        mntr        =   new(intf, sb)           ;
        sb          =   new()                   ;

    endfunction

endclass

`endif 