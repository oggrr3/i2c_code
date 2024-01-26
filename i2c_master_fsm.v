module i2c_master_fsm (
    input           enable_i            ,   // enable signal from MCU
    input           reset_ni            ,   // reset negative signal from MCU
    input           repeat_start_i      ,   // repeat start signal from MCU
    input           rw_i                ,   // bit 1 is read - 0 is write
    input           full_i              ,   // FIFO buffer is full
    input           empty_i             ,   // FIFO buffer is empty
    input           i2c_core_clk_i      ,   // i2c core clock
    input           sda_feedback_i      ,   // sda feedback to FSM
    input           scl_feedback_i      ,   // scl feedback to FSM

    output          sad_en_o            ,   // when = 1 enable sda down 0
    output          scl_en_o            ,   // enbale clock to scl
    output          write_data_en_o     ,   // enable write data on sda
    output          write_addr_en_o     ,   // enable write address of slave on sda
    output          receive_data_en_o       // enable receive data from sda
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
    parameter   stop            =   4'b1000   ;

    // Declare current state, next state
    reg     [3:0]       currrent_state  ;
    reg     [3:0]       next_sate       ;

    // Declare count value
    reg     [2:0]       count           ;

    // State register logic
    always @ (posedge i2c_core_clk_i,   negedge reset_ni) begin
        if (~reset_ni) begin
            currrent_state       <=     idle    ;
            
        end

        else begin
            currrent_state      <=  next_sate   ;
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
                // count_clock = 4
            end

            start   :   begin

                //if (sda_feedback_i == 0 && scl_feedback_i == 1) begin
                //    count       =    7          ;
                //    next_sate   =   address     ;
                //end 
                else begin
                    next_sate   =   address       ;
                end

            end

            address :   begin

                if (count == 0) begin
                    next_sate   =   read_ack    ;
                end 
                else begin
                    count       =   count - 1   ;
                    next_sate   =   address     ;
                end

            end

            read_ack    :   begin

                if (sda_feedback_i == 0) begin
                    count   =   7                               ;   
                    case (rw_i)
                        1       :   next_sate   =   read_data   ;
                        0       :   next_sate   =   write_data  ;
                        default :   next_sate   =   read_data   ;
                    endcase
                end 
                else begin
                                    next_sate   =   stop        ;
                end

            end

            write_data  :   begin

                if (empty_i == 1) begin
                    next_sate   =   stop    ;
                end 
                else begin
                    if (count == 0) begin
                        next_sate   =   read_later_ack  ;
                    end 
                    else begin
                        count       =   count - 1       ;
                        next_sate   =   write_data      ;
                    end
                end

            end

            read_later_ack  :   begin

                if (sda_feedback_i == 0) begin
                    count           =      7            ;
                    next_sate       =      write_data   ; 
                end 
                else begin
                    next_sate       =       stop        ;
                end

            end

            read_data   :   begin

                if (full_i == 1) begin
                    next_sate       =       stop        ;
                    
                end 
                else begin
                    if (count == 0) begin
                        next_sate   =       write_ack   ;
                        
                    end 
                    else begin
                        count       =       count - 1   ;
                        next_sate   =       read_data   ;
                    end
                end

            end

            write_ack   :   begin
                
                count       =       7                   ;
                if (sda_feedback_i == 0) begin
                    next_sate       =       read_data   ;
                end 
                else begin
                    next_sate       =       stop        ;
                end

            end

            stop    :   begin
                next_sate           =       idle        ;
            end

            default: next_sate      =       idle        ;
        endcase

    end

    // Output combinational logic
    always @(currrent_state) begin
        
        case (currrent_state)
            
            idle            :   begin
                scl_en_o            =       0           ;
                sad_en_o            =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end

            start           :   begin
                scl_en_o            =       0           ;
                sad_en_o            =       1           ;
                //start_gen_o         =       1           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end

            address         :   begin
                scl_en_o            =       1           ;
                sad_en_o            =       1           ;
                //start_gen_o         =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       1           ;
                receive_data_en_o   =       0           ;
            end

            read_ack        :   begin
                scl_en_o            =       1           ;
                sad_en_o            =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end

            write_data      :   begin
                scl_en_o            =       1           ;
                sad_en_o            =       0           ;
                write_data_en_o     =       1           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end

            read_later_ack  :   begin
                scl_en_o            =       1           ;
                sad_en_o            =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end

            read_data       :   begin
                scl_en_o            =       1           ;
                sad_en_o            =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       1           ;
            end

            write_ack       :   begin
                scl_en_o            =       1           ;
                sad_en_o            =       1           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end

            stop            :   begin
                scl_en_o            =       0           ;
                sad_en_o            =       1           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end

            default         :   begin
                scl_en_o            =       0           ;
                sad_en_o           =       0           ;
                write_data_en_o     =       0           ;
                write_addr_en_o     =       0           ;
                receive_data_en_o   =       0           ;
            end
        endcase

    end

    // when nagative
    always @(negedge scl_feedback_i) begin
        case (current)
            address: begin
                sda_en_o    =   1   ;
            end

            write_ack   :   begin

            end


            write_data  :   begin

            end

            default: 
        endcase
    end

    /// 
        // when nagative
    always @(posedge scl_feedback_i) begin
        case (current)

            // tru sart stop repeat
            address: begin
                sda_en_o    =   0   ;
            end

            write_ack   :   begin

            end


            write_data  :   begin

            end

            default: 
        endcase
    end
endmodule