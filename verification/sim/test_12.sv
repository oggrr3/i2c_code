

`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;
    bit [7:0]   data        ;

    initial begin
		env		=	new(intf);

        env.drvr.apb_reset()                        ;
        env.drvr.Apb_Write(1, 8)                    ;   //  Prescale
        env.drvr.Apb_Write(2, 8'b001_0000_0)        ;   //  Address of slave and R/W bit
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   // Cmd to enable
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write_n_byte_random(7)         ;

        // write 4 byte
        repeat(5) begin
                env.drvr.Get1Byte_From_Sda(data[0]);
                env.drvr.Check_ACK();
        end

        // Reset_n
        env.drvr.Apb_Write(6, 8'b1000_0000)         ;   // Cmd 
        repeat(2) @(negedge intf.i2c_clk)           ;
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   // Cmd to enabble
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write_n_byte_random(7)         ;

        // Continue write 2 byte
        repeat(3) begin
                env.drvr.Get1Byte_From_Sda(data[0]);
                env.drvr.Check_ACK();
        end
        env.drvr.Get1Byte_From_Sda(data[0]);
        env.drvr.Apb_Write(6, 8'b1001_1000)         ;   // Cmd to enabble
        env.drvr.Check_ACK();

        // Repeat start
        env.drvr.Apb_Write(6, 8'b1001_1000)         ;   // Cmd to enabble
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write_n_byte_random(10)        ;

        // Continue write
        fork
            env.drvr.Check_Stop_condition(stop_done)    ;
            while (!start_done) begin
                env.drvr.Get1Byte_From_Sda(data[0]);
                env.drvr.Check_ACK();
            end
        join_any

        #1000;
        $finish;
    end

endprogram


