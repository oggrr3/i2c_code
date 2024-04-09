
`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;
    bit [7:0] data;
    initial begin
		env		=	new(intf);
        fork
            begin
                //  Step 1: config register map in order
                env.drvr.apb_reset();
                env.drvr.Apb_Write(1, 8)                    ;   //  Prescale
                env.drvr.Apb_Write(2, 8'b001_0000_0)        ;   //  Address of slave and R/W bit
                env.drvr.Apb_Write(4, 0)                    ;   //  TX_data write mem's address of slave model
                env.drvr.Apb_Write(4, 3)                    ; 
                //  Step 2: Enable in commands register connect to I2C master enable
                env.drvr.Apb_Write(6, 8'b1001_0000)         ;   //  cmd

            end
        join
	
        env.drvr.Check_Start_condition(start_done)  ;
        env.drvr.Get1Byte_From_Sda(data);
        env.drvr.Check_Stop_condition(stop_done)  ;
        if(stop_done == 1) begin
            env.drvr.Apb_Read(4);
            repeat(10) @(negedge intf.i2c_clk);
            $stop   ;
        end

    end

endprogram