//Driver class is responsible for,
//receive the stimulus generated from the generator and drive to DUT by assigning transaction class values to interface signals.

`ifdef DRIVER
`define DRIVER

`include "scoreboard.sv"
`include "interface.sv"

class driver;
    scoreboard          sb                              ;   // Creating scoreboard handle to generate covegroup
    //generator           gen                             ;   // Creating generator handle
    virtual intf_i2c    inf                             ;   // Creating virtrual interface handle                         
    mailbox             gen2driv                        ;   // Creating mailbox handle

    covergroup cov                                          //  Covergroup
        // Instance  
    endgroup

    function new(virtual intf_i2c intf, scoreboard  sb, mailbox gen2driv) ;   //  Constuctor

        this.inf        =   intf                        ;
        this.sb         =   sb                          ;
        this.gen2driv   =   gen2driv                    ;   //  Getting the mailbox handle from  environment 
        cov             =   new()                       ;   //  Instance covergroup

    endfunction 

    task apb_reset();   // apb reset method
        intf.preset_n   <=  0                           ;
        repeat(2)   @(negedge   intf.apb_clk)           ;
        intf.preset_n   <=  1                           ;
        #1;
    endtask 

    task Apb_Write(bit [7:0] addr, bit [7:0] data);

        intf.paddr      <=  addr                        ;
        intf.pwrite     <=  1                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        intf.pwdata     <=  data                        ;
        @(posedge   intf.apb_clk);
        #1;
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk)                       ;
        #1;
        intf.psel       <=  0                           ;

    endtask

    task Apb_Read (bit [7:0] addr);
        intf.paddr      <=  addr                        ;
        intf.pwrite     <=  0                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        @(posedge   intf.apb_clk);
        #1;
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk)                       ;
        #1;
        intf.psel       <=  0                           ;

    endtask


endclass //driver

`endif 
