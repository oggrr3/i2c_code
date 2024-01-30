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

    output          sda_low_en_o        ,   // when = 1 enable sda down 0
    output          clk_en_o            ,   // enbale to generator clk
    output          write_data_en_o     ,   // enable write data on sda
    output          write_addr_en_o     ,   // enable write address of slave on sda
    output          receive_data_en_o   ,   // enable receive data from sda
    output          count_bit_o         ,   // count bit data from 7 down to 0
    output          i2c_sda_en_o        ,   // allow impact to sda
    output          i2c_scl_en_o            // allow impact to scl 
);

    // State
    parameter   idle            =   4'b0000   ;
    parameter   start           =   4'b0001   ;
    parameter   address         =   4'b0010   ;
    parameter   read_ack        =   4'b0011   ;
    parameter   write_data      =   4'b0100   ;
    parameter   read_later_ack  =   4'b0101   ;

    parameter   read_data       =   4'b0110   ;
    parameter   write_ack       =   4'b0111   ;

    parameter   repeat_start    =   4'b1000   ;
    parameter   stop            =   4'b1001   ;

    // Declare current state, next state
    reg     [3:0]       currrent_state              ;
    reg     [3:0]       next_sate                   ;

    // Declare count value
    reg     [2:0]       count_bit                   ;
    reg     [2:0]       count_clk_core     =    0   ;
    reg                 confirm            =    0   ;   // when i2c_scl_i from 1 down to 0, confirm = 1 


    assign  count_bit_o     =   count_bit           ;   // Push count bit to output


    // State register logic
    always @ (posedge i2c_core_clk_i,   negedge reset_ni) begin
        if (~reset_ni) begin
            currrent_state       <=     idle    ;
            
        end

        else begin
            case (next_sate)
                // State-Start wait for 4 cycle-core before change to Address-State
                // start   :   begin
                //     if (count_clk_core == 3) begin
                //         currrent_state   <=   start                 ;
                //         count_bit        <=   7                     ;
                //         count_clk_core   <=   0                     ;
                //     end
                //     else begin
                //         count_clk_core   <=   count_clk_core + 1    ;
                //     end
                // end

                start       :   begin
                    if (confirm) begin
                        currrent_state  <=  next_sate               ;
                    end
                    else begin
                        currrent_state  <=  currrent_state          ;
                    end
                end

                //-------------------------------------------------------
                address     :   begin
                    if (count_bit == 0) begin
                        currrent_state  <=  next_sate               ;
                    end
                    else begin
                        currrent_state  <=  currrent_state          ;
                    end                    
                end

                //------------------------------------------------------
                read_ack    :   begin
                    if (confirm) begin
                        currrent_state  <=  next_sate               ;
                    end
                    else begin
                        currrent_state  <= currrent_state           ;
                    end
                end

                default :   begin
                    currrent_state       <=  next_sate              ;
                end
            endcase
        end
        
    end

    // Next state comnibational logic
    always @ (currrent_state, full_i, empty_i)    begin

        case (currrent_state)

            idle    :   begin

                if (enable_i) begin
                    next_sate   =   start      ;
                end
                else begin
                    next_sate   =   idle       ;
                end

            end


            start   :   begin

                next_sate   =   address         ;

            end


            address :   begin

                if (count_bit == 0) begin
                    next_sate   =   read_ack    ;
                end
                else begin
                    next_sate   =   address     ;
                end 

            end

            read_ack    :   begin

                if (i2c_sda_i == 0) begin

                    case (rw_i)
                        1       :   if (full_i)     next_sate   =   stop        ;
                                    else            next_sate   =   read_data   ;  

                        0       :   if (empty_i)    next_sate   =   stop        ;
                                    else            next_sate   =   write_data  ;

                        default :                   next_sate   =   read_data   ;
                    endcase
                end 

                else begin
                                                    next_sate   =   stop        ;
                end

            end

            write_data  :   begin

                if (count_bit == 0) begin
                    next_sate   =   read_later_ack      ;
                end 
                else begin
                    next_sate   =   write_data          ;
                end

            end

            read_later_ack  :   begin

                if (repeat_start_i) begin
                    next_sate       =      repeat_start   ; 
                end 
                else if (i2c_sda_i == 0 && empty_i == 0) begin
                    next_sate       =       write_data    ;
                end
                else begin
                    next_sate       =       stop          ;
                end

            end

            read_data   :   begin

                if (count_bit == 0) begin
                    next_sate       =       write_ack       ;
                    
                end 
                else begin
                    next_sate       =       read_data       ;
                end

            end

            write_ack   :   begin

                if (repeat_start_i) begin
                    next_sate       =      repeat_start     ; 
                end 
                else if (i2c_sda_i == 0 && full_i == 0) begin
                    next_sate       =       read_data       ;
                end
                else begin
                    next_sate       =       stop            ;
                end

            end

            repeat_start    :    begin
                next_sate           =       address         ;
            end

            stop    :   begin
                next_sate           =       idle            ;
            end

            default: next_sate      =       idle            ;
        endcase

    end

    // Output combinational logic
    always @(currrent_state) begin
        
        case (currrent_state)
            
            idle            :   begin
                clk_en_o            =       0           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       0           ;
                i2c_scl_en_o        =       0           ;
            end

            //-------------------------------------------------------
            start           :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       1           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       1           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            address         :   begin
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
            read_ack        :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       0           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            write_data      :   begin
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
            read_later_ack  :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       0           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            read_data       :   begin
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
            write_ack       :   begin
                clk_en_o            =       1           ;
                sda_low_en_o        =       1           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
                i2c_sda_en_o        =       1           ;
                i2c_scl_en_o        =       1           ;
            end

            //-------------------------------------------------------
            repeat_start    :   begin
                clk_en_o            =       1           ;

                // Frist, when scl is low, we have to set sda up to 1
                if (i2c_scl_i == 0) begin
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
            stop            :   begin
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
                sda_low_en_o           =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end
        endcase

    end

    // when negetive i2c_scl_i, count_bit --
    always @(negedge i2c_scl_i) begin

        confirm     =       1       ;
        if (currrent_state  ==  address || currrent_state == read_data
            currrent_state  ==  write_data) begin
            
                count_bit   =   count_bit - 1   ;
        end
        else begin
            count_bit       =   7               ;
        end

    end

    /// 
    // when nagative
    always @(posedge i2c_scl_i) begin
        confirm     =       0       ;
    end
endmodule