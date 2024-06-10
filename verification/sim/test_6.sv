

`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;
    bit [7:0] data;

    initial begin
		env		=	new(intf);

        env.drvr.apb_reset()                        ;
        env.drvr.Apb_Write(1, 4)                    ;   //  Prescale
        env.drvr.Apb_Write(2, 8'b001_0000_0)        ;   //  Address of slave and R/W bit
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   // Cmd to enable
        env.drvr.Apb_Write(4, 0)                    ;

        env.drvr.Apb_Write_n_byte_random(10);

        env.drvr.Check_Stop_condition(stop_done)    ;   // Wait to write finish
        stop_done = 0;


        env.drvr.Apb_Write(2, 8'b001_0000_1)        ;   //  Address of slave and R/W bit

        fork
            env.drvr.Check_Stop_condition(stop_done)    ;
            while (!start_done) begin
                env.drvr.Get1Byte_From_Sda(data[0]);
                env.drvr.Check_ACK();
            end
        join_any

        env.drvr.Apb_Read_n_byte(4, 10)                ;
        #500;
        $finish;
    end

endprogram


