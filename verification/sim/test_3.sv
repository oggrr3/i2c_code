

`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;

    initial begin
		env		=	new(intf);

        env.drvr.apb_reset();
        // Step 1: apb write
        for (int i = 0 ; i < 10 ; i ++ ) begin
            env.drvr.Apb_Write(i, i);
        end   

        // Step 2: apb read 
        //env.drvr.Apb_Write(6, 8'b0011_0000);
        env.drvr.Apb_Read(1);
        env.drvr.Apb_Read(2);
        env.drvr.Apb_Read(3);
        env.drvr.Apb_Read(4);
        env.drvr.Apb_Read(5);
        env.drvr.Apb_Read(6);

        #100;

    end

endprogram


