module apb_slave_interface  #(parameter     ADDR_WIDTH  =   8,
                              parameter     DATA_WIDTH  =   8) 
(
    input                               pclk_i              ,   //  clock
    input                               preset_ni           ,   //  reset signal is active-LOW
    input   [ADDR_WIDTH - 1 : 0]        paddr_i             ,   //  address of APB slave and register map
    input                               pwrite_i            ,   //  HIGH is write, LOW is read
    input                               psel_i              ,   //  select slave interface
    input                               penable_i           ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    input   [DATA_WIDTH - 1 : 0]        pwdata_i            ,   //  data write
    input                               fifo_full_i         ,   //  FIFO is full
    input                               fifo_empty_i        ,   //  FIFO is empty
    input   [7:0]                       data_fifo_i         ,   //  data from FIFO memory

    output  [DATA_WIDTH - 1 : 0]        prdata_o            ,   //  data read
    output                              pready_o            ,   //  ready to receive data
    output     [7:0]                    reg_transmit_o      ,   //  register
    output     [7:0]                    reg_slave_address_o ,   //  register
    output     [7:0]                    reg_command_o       ,   //  register
    output     [7:0]                    reg_prescale_o          //  register

);

    // Decalar register map
    reg     [7:0]                       reg_transmit            ;   //  0x00
    reg     [7:0]                       reg_receive             ;   //  0x01
    reg     [7:0]                       reg_status              ;   //  0x02
    reg     [7:0]                       reg_slave_address       ;   //  0x03
    reg     [7:0]                       reg_command             ;   //  0x04
    reg     [7:0]                       reg_prescale            ;   //  0x05

    //  Decalar reg of output
    reg     [DATA_WIDTH - 1 : 0]        prdata              ;
    reg                                 pready              ;

    // Connect to Output
    assign      prdata_o                =   prdata              ;
    assign      pready_o                =   pready              ;
    assign      reg_transmit_o          =   reg_transmit        ;
    assign      reg_slave_address_o     =   reg_slave_address   ; 
    assign      reg_command_o           =   reg_command         ;
    assign      reg_prescale_o          =   reg_prescale        ;

    //  Write transfer with no wait states
    always @(posedge    pclk_i,    negedge  preset_ni) begin

        if (~preset_ni) begin

            prdata              <=      0       ;
            pready              <=      0       ;

            reg_transmit            <=      0       ;
            reg_receive             <=      0       ;
            reg_status              <=      0       ;
            reg_slave_address       <=      0       ;
            reg_command             <=      0       ;
            reg_prescale            <=      0       ;

        end 

        else begin

            // pwrite HIGH and psel HIGHT, this is write cycle
            if (penable_i == 1 && psel_i == 1 && pwrite_i == 1) begin
                
                case (paddr_i[ADDR_WIDTH - 3 : 0])

                    0       :       reg_transmit            <=  pwdata_i    ;
                    3       :       reg_slave_address       <=  pwdata_i    ;
                    4       :       reg_command             <=  pwdata_i    ;
                    5       :       reg_prescale            <=  pwdata_i    ;   
                    default :       reg_transmit            <=  pwdata_i    ;

                endcase

                pready  <=  1   ;
                
            end 
            
            // pwrite Low and psel HIGHT, this is read cycle
            else if (penable_i == 1 && psel_i == 1 && pwrite_i == 0)begin
                
                case (paddr_i[ADDR_WIDTH - 3 : 0])

                    0       :       prdata            <=  reg_transmit      ;
                    1       :       prdata            <=  reg_receive       ;
                    2       :       prdata            <=  reg_status        ;
                    3       :       prdata            <=  reg_slave_address ;
                    4       :       prdata            <=  reg_command       ;
                    5       :       prdata            <=  reg_prescale      ;   
                    default :       prdata            <=  reg_transmit      ;

                endcase

                pready  <=  1   ;
                
            end

            else begin

                pready  <= 0    ;

            end
        end
    end

    //  receive data from fifo memory
    always @(*) begin
        reg_receive     =   data_fifo_i     ;
    end

endmodule