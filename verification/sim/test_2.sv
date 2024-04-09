
`include "env.sv"
program testcase(intf_i2c intf);
    environment env           ;
    bit start_done  =   0      ;
    bit stop_done   =   0   ;
    bit [7:0] data;

    initial begin
		env     =   new(intf);
    
        //  Step 1: config register map in order
        env.drvr.apb_reset();
        env.drvr.Apb_Write(1, 4)                    ;   //  Prescale
        env.drvr.Apb_Write(2, 8'b0010_000_0)        ;   //  Address of slave and R/W bit
        env.drvr.Apb_Write(6, 8'b1001_0000)         ;   //  cmd
        env.drvr.Apb_Write(4, 0)                    ;
        env.drvr.Apb_Write(4, 1)                    ;
        env.drvr.Apb_Write(4, 2)                    ;
        env.drvr.Apb_Write(4, 3)                    ;

        env.drvr.Check_Stop_condition(stop_done)    ;   //  wait to when finish write
        stop_done   =   0                           ;

        env.drvr.Apb_Write(2, 8'b0010_000_1)        ;   //  Address of slave and R/W bit
        repeat(18) @(posedge intf.scl)              ;

        
        #1000;
        env.drvr.Apb_Read(5)                        ;   // start read
        env.drvr.Apb_Read(3)                        ;
        $finish;
    end

endprogram