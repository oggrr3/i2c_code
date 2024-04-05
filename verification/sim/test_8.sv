

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
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   // Cmd to enable, not reset, and repeat start
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write(4, 1)                    ;

        env.drvr.Check_Stop_condition(stop_done)    ;
        repeat(5) @(intf.i2c_clk)                   ;
        env.drvr.Apb_Write(2, 8'b001_0000_1)        ;   //  Address of slave and R/W bit

        repeat(10) @(intf.scl)                       ;
        env.drvr.Apb_Write(6, 8'b1001_1000)         ;   // Cmd to enable, not reset, and repeat start
        env.drvr.Apb_Write(2, 8'b001_0000_0)        ;   //  Address of slave and R/W bit
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write(4, 1)                    ;

        repeat(5) @(intf.scl)                   ;
        //env.drvr.Apb_Write(6, 8'b1001_1000)         ;
        env.drvr.Apb_Write(2, 8'b001_0000_1)        ;   //  Address of slave and R/W bit
        #10000;
    end

endprogram


