

`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;
    bit [7:0]   data        ;
    reg enable = 0;

    initial begin
		env		=	new(intf);

        env.drvr.apb_reset()                        ;
        env.drvr.Apb_Write(1, 8)                    ;   //  Prescale
        env.drvr.Apb_Write(2, 8'b001_0000_0)        ;   //  Address of slave and R/W bit
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   // Cmd to enable
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write_n_byte_random(4)         ;

        env.drvr.Check_Start_condition(start_done)  ;   // Wait to write begin
        repeat (3) begin                                    //  Wait to when finish to write 2 byte
            env.drvr.Get1Byte_From_Sda(data)        ;
            env.drvr.Check_ACK()                    ;
        end

        env.drvr.Apb_Write(6, 8'b1000_0000)         ;   // Cmd to reset
        repeat (2) @(negedge intf.i2c_clk)          ;
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   // Cmd to enable
        env.drvr.Apb_Write(2, 8'b001_0000_1)        ;   //  

        env.drvr.Check_Start_condition(start_done)  ;   //  Start read-mode
        repeat (2) begin                                    //  Wait to when finish to write 2 byte
            env.drvr.Get1Byte_From_Sda(data)        ;
            env.drvr.Check_ACK()                    ;
        end

        env.drvr.Apb_Write(6, 8'b1000_0000)         ;   // Cmd to reset
        repeat (2) @(negedge intf.i2c_clk)          ;
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   // Cmd to enable
        env.drvr.Apb_Write(2, 8'b001_0000_0)        ;   //  
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write_n_byte_random(4)         ;

        repeat (2) begin                                    //  Wait to when finish to write 2 byte
            env.drvr.Get1Byte_From_Sda(data)        ;
            env.drvr.Check_ACK()                    ;
        end

        #500;
        $finish;
    end

endprogram


