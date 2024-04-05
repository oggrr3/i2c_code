
`include "env.sv"
program testcase(intf_i2c intf);
    environment env           ;
    bit start_done  =   0      ;
    bit stop_done   =   0   ;

    initial begin
		env     =   new(intf);
    
        //  Step 1: config register map in order
        env.drvr.apb_reset();
        env.drvr.Apb_Write(1, 4)                   ;   //  Prescale
        env.drvr.Apb_Write(2, 8'b0010_0001)        ;   //  Address of slave and R/W bit

        //  Step 2: Enable in commands register connect to I2C master enable
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   //  cmd

        #20000;

    end

endprogram