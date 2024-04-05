

`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;

    initial begin
		env		=	new(intf);

        env.drvr.Apb_Write_n_byte_random(10);
        env.drvr.apb_reset();

        for (int i = 0 ; i < 10 ; i++) begin
            env.drvr.Apb_Read(i);
        end

        #100;
    end

endprogram


