program testcase(intf_i2c intf)
    environment env     =   new(intf)                       ;

    initial begin
        fork
            begin
                //  Step 1: config register map in order
                env.drvr.apb_reset();
                env.drvr.Apb_Write(1, 4)                    ;   //  Prescale
                env.drvr.Apb_Write(2, 8'b001_0000_0)        ;   //  Address of slave and R/W bit
                env.drvr.Apb_Write(4, 1)                    ;   //  TX_data
                env.drvr.Apb_Write(4, 2)                    ;   //  TX_data
                env.drvr.Apb_Write(4, 3)                    ;   //  
                env.drvr.Apb_Write(4, 4)                    ;   //  
                env.drvr.Apb_Write(4, 5)                    ;   //  TX_data
                env.drvr.Apb_Write(4, 11)                   ;   //  TX_data

                //  Step 2: Enable in commands register connect to I2C master enable
                env.drvr.Apb_Write(6, 8'b1000_0000)         ;   //  cmd
                // Step 3: W_enable connects to FIFO TX write enable
                env.drvr.Apb_Write(6, 8'b1100_0000)         ;   //  cmd
            end
        join
    end

endprogram