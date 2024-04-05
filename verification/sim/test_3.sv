

`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;

    initial begin
		env		=	new(intf);
        // Step 1: read default registers
        //env.drvr.Apb_Write(6, 8'b0010_0000);
        for (int i = 0 ; i < 10 ; i ++ ) begin
            env.drvr.Apb_Read(i);
        end

        // Step 2: apb write
        for (int i = 0 ; i < 10 ; i ++ ) begin
            env.drvr.Apb_Write(i, i);
        end   

        // Step 3: apb read 
        //env.drvr.Apb_Write(6, 8'b0010_0000);
        env.drvr.Apb_Read(1);
        env.drvr.Apb_Read(2);
        env.drvr.Apb_Read(4);
        env.drvr.Apb_Read(6);

        #100;

    end

endprogram


