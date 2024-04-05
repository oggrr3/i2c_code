

`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;
    bit [7:0]   data        ;

    initial begin
		env		=	new(intf);

        env.drvr.apb_reset()                        ;
        env.drvr.Apb_Write(1, 4)                    ;   //  Prescale
        env.drvr.Apb_Write(2, 8'b001_0000_0)        ;   //  Address of slave and R/W bit
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   // Cmd to enable
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write(4, 1)                    ;
        env.drvr.Apb_Write(4, 2)                    ;
        env.drvr.Apb_Write(4, 3)                    ;

        repeat(28) @(posedge intf.scl)              ;
        env.drvr.Apb_Write(2, 8'b001_0000_1)        ;   //  Address of slave and R/W bit
        env.drvr.Apb_Write(6, 8'b1000_0000)         ;   // Cmd to enable
        
        repeat(5) @(posedge intf.i2c_clk)           ;
        
        #10000;
    end

endprogram


