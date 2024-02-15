module i2c_master_fsm (
    input           enable_i            ,   // enable signal from MCU
    input           reset_ni            ,   // reset negative signal from MCU
    input           repeat_start_i      ,   // repeat start signal from MCU
    input           rw_i                ,   // bit 1 is read - 0 is write
    input           full_i              ,   // FIFO buffer is full
    input           empty_i             ,   // FIFO buffer is empty
    input           i2c_core_clk_i      ,   // i2c core clock
    input           i2c_sda_i           ,   // i2c sda feedback to FSM
    input           i2c_scl_i           ,   // i2c scl feedback to FSM

    output          w_fifo_en_o         ,   //  enable write data into fifo memory
    output          r_fifo_en_o         ,   //  enable read data from fifo memory

    output	    reg             sda_low_en_o        ,   // when = 1 enable sda down 0
    output	    reg             clk_en_o            ,   // enbale to generator clk
    output	    reg             write_data_en_o     ,   // enable write data on sda
    output	    reg             write_addr_en_o     ,   // enable write address of slave on sda
    output	    reg             receive_data_en_o   ,   // enable receive data from sda
    output      reg     [2:0]   count_bit_o         ,   // count bit data from 7 down to 0
    output	    reg             i2c_sda_en_o        ,   // allow impact to sda
    output	    reg             i2c_scl_en_o            // allow impact to scl 
);

    // State
    parameter   IDLE            =   4'b0000   ;
    parameter   START           =   4'b0001   ;
    parameter   ADDRESS         =   4'b0010   ;
    parameter   READ_ACK        =   4'b0011   ;
    parameter   WRITE_DATA      =   4'b0100   ;
    parameter   READ_LATER_ACK  =   4'b0101   ;

    parameter   READ_DATA       =   4'b0110   ;
    parameter   WRITE_ACK       =   4'b0111   ;

    parameter   REPEAT_START    =   4'b1000   ;
    parameter   STOP            =   4'b1001   ;

    // Declare current state, next state
    reg     [3:0]       currrent_state              ;
    reg     [3:0]       next_sate                   ;

    // Declare count value
    reg     [2:0]       count_clk_core     =    0   ;
    reg                 confirm            =    0   ;   // when i2c_scl_i from 1 down to 0, confirm = 1 
    reg                 pre_scl_clk                 ;

    // Declare register of ouput
    reg                 w_fifo_en                       ;
    reg                 r_fifo_en                       ;

    assign              w_fifo_en_o     =   w_fifo_en   ;
    assign              r_fifo_en_o     =   r_fifo_en   ;

    // Current State register logic
    always @ (posedge i2c_core_clk_i,   negedge reset_ni) begin
        if (~reset_ni) begin
            currrent_state       <=     IDLE        ;            
        end

        else begin

            currrent_state  	<=  next_sate       ;

        end

    end

    // Next state comnibational logic
    always @ (*)    begin

        case (currrent_state)

            IDLE    :   begin

                if (enable_i) begin
                    next_sate   =   START      ;
                end
                else begin
                    next_sate   =   IDLE       ;
                end

            end


            START   :   begin
				if (confirm)
                	next_sate   =   ADDRESS         ;
                else begin
                    next_sate   =   START           ;
                end

            end


            ADDRESS :   begin

                if (count_bit_o == 0) begin
                    next_sate   =   READ_ACK    ;
                end
                else begin
                    next_sate   =   ADDRESS     ;
                end 

            end

            READ_ACK    :   begin

                if (i2c_sda_i == 0) begin

                    case (rw_i)
                        1       :   if (full_i)     next_sate   =   STOP        ;
                                    else            next_sate   =   READ_DATA   ;  

                        0       :   if (empty_i)    next_sate   =   STOP        ;
                                    else            next_sate   =   WRITE_DATA  ;

                        default :                   next_sate   =   READ_DATA   ;
                    endcase
                end 

                else begin
                                                    next_sate   =   STOP        ;
                end

            end

            WRITE_DATA  :   begin

                if (count_bit_o == 0) begin
                    next_sate   =   READ_LATER_ACK      ;
                end 
                else begin
                    next_sate   =   WRITE_DATA          ;
                end

            end

            READ_LATER_ACK  :   begin

                if (repeat_start_i) begin
                    next_sate       =      REPEAT_START   ; 
                end 
                else if (i2c_sda_i == 0 && empty_i == 0) begin
                    next_sate       =       WRITE_DATA    ;
                end
                else begin
                    next_sate       =       STOP          ;
                end

            end

            READ_DATA   :   begin

                if (count_bit_o == 0) begin
                    next_sate       =       WRITE_ACK       ;
                    
                end 
                else begin
                    next_sate       =       READ_DATA       ;
                end

            end

            WRITE_ACK   :   begin

                if (repeat_start_i) begin
                    next_sate       =      REPEAT_START     ; 
                end 
                else if (i2c_sda_i == 0 && full_i == 0) begin
                    next_sate       =       READ_DATA       ;
                end
                else begin
                    next_sate       =       STOP            ;
                end

            end

            REPEAT_START    :    begin
                if (confirm) begin
                    next_sate           =       ADDRESS         ;
                end
                else begin
                    next_sate           =       REPEAT_START    ;
                end

            end

            STOP    :   begin
                next_sate           =       IDLE            ;
            end

            default: next_sate      =       IDLE            ;
        endcase

    end

    // Output combinational logic
    always @(*) begin
        
        case (currrent_state)
            
            IDLE            :   begin
                clk_en_o            =       0           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       0           ;
                i2c_scl_en_o        =       0           ;
            end

            //-------------------------------------------------------
            START           :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       1           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       1           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            ADDRESS         :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       1           ;
                receive_data_en_o   =       0           ;

                //confirm = 1, scl is low, we can impact to sda
                if (confirm)    
                    i2c_sda_en_o    =       1           ;
                else    
                    i2c_sda_en_o    =       0           ;

                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            READ_ACK        :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       0           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            WRITE_DATA      :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       1           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;

                //confirm = 1, scl is low, we can impact to sda
                if (confirm)    
                    i2c_sda_en_o    =       1           ;
                else    
                    i2c_sda_en_o    =       0           ;

                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            READ_LATER_ACK  :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       0           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            READ_DATA       :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;

                //confirm = 0, scl is hight, we can receive data from sda
                if (~confirm)    
                    receive_data_en_o   =       1       ;
                else    
                    i2c_sda_en_o    =       0           ;

                i2c_sda_en_o        =       0           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            WRITE_ACK       :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       1           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       1           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            REPEAT_START    :   begin
                clk_en_o            =       1           ;

                // Frist, when scl is low, we have to set sda up to 1
                if (i2c_scl_i == 0) begin
                    sda_low_en_o    =       1           ;
                end
                else begin
                    sda_low_en_o    =       0           ;
                end

                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       1           ;
                i2c_scl_en_o        =       1           ;
                // After, we have to set sda down to 0 when scl is hight

            end

            //-------------------------------------------------------
            STOP            :   begin
                clk_en_o            =       0           ;
                sda_low_en_o        =       1           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       1           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            default         :   begin
                clk_en_o            =       0           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       0           ;
                i2c_scl_en_o        =       0           ;
            end
        endcase

    end

    // Detect negative scl 
    always @(posedge    i2c_core_clk_i) begin

        pre_scl_clk         <=      i2c_scl_i          ;
        if (pre_scl_clk == 1 && i2c_scl_i == 0) begin
            confirm         <=       1                 ;    // scl line from 1 to 0 => confirm = 1
        end

        else begin	 
            confirm         <=       0                  ;
        end

    end
    // when negetive i2c_scl_i, count_bit_o --
    always @(*) begin

        //confirm     =       1       ;
        if (currrent_state  ==  ADDRESS || currrent_state == READ_DATA	|| currrent_state  ==  WRITE_DATA) begin
            if (confirm)
                count_bit_o   =   count_bit_o - 1   ;
        end
        else begin
            count_bit_o       =   7                 ;
        end

    end

    // Handle read/write-enbale signal to FIFO
    always @ (*) begin

        //when handle  1 byte data and scl is hight => enable read, write to FIFO memory
        if (count_bit_o == 0 && i2c_scl_i == 1) begin
            w_fifo_en     =   1           ;
            r_fifo_en     =   1           ;
        end 

        else begin
            w_fifo_en     =   0           ;
            r_fifo_en     =   0           ;
        end

    end

endmodule