

`include "env.sv"
program testcase(intf_i2c intf);
    environment env             ;
	bit start_done  =   0      ;
    bit stop_done   =   0   ;
    bit [7:0] data [20:0] ;
    bit i = 0 ;

    initial begin
		env		=	new(intf);

        fork 
            begin
                env.drvr.Apb_Write_n_byte_random(10);
            end

            // begin
            //     env.drvr.Check_Stop_condition(stop_done);
            // end

        join_any

        repeat(10) begin
            env.drvr.Get1Byte_From_Sda(data[0]);
            @(posedge intf.scl)
            if (intf.sda)
                $display("Detected NACK at time = %0t", $time);
            else
                $display("Detected ACK at time = %0t", $time);
        end

        #100;
    end

endprogram


