module apb_slave_interface  #(parameter     DATA_WIDTH  =   8,
                              parameter     ADDR_WIDTH  =   8) 
(
    input                               pclk_i              ,   //  clock
    input                               preset_ni           ,   //  reset signal is active-LOW
    input   [ADDR_WIDTH - 1 : 0]        paddr_i             ,   //  address of APB slave and register map
    input                               pwrite_i            ,   //  HIGH is write, LOW is read
    input                               psel_i              ,   //  select slave interface
    input                               penable_i           ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    input   [DATA_WIDTH - 1 : 0]        pwdata_i            ,   //  data write
    input   [7:0]                       to_status_reg_i     ,   //  status of FIFO memory
    input   [7:0]                       data_fifo_i         ,   //  data from FIFO memory
    input                               start_done_i        ,   //  i2c-core done start, let turn off enable
    input                               reset_done_i        ,   //  i2c-core done reset, let turn off reset

    output                              tx_winc_o           ,   //  enable to write data to TX-FIFO
    output                              rx_rinc_o           ,   //  enable to read data from RX-FIFO
    output  [DATA_WIDTH - 1 : 0]        prdata_o            ,   //  data read
    output                              pready_o            ,   //  ready to receive data
    output     [7:0]                    reg_transmit_o      ,   //  register
    output     [7:0]                    reg_slave_address_o ,   //  register
    output     [7:0]                    reg_command_o       ,   //  register
    output     [7:0]                    reg_prescale_o          //  register

);

    // Decalar register map
    reg     [7:0]                       reg_transmit            ;   //  0x00
    reg     [7:0]                       reg_slave_address       ;   //  0x0c
    reg     [7:0]                       reg_command             ;   //  0x10
    reg     [7:0]                       reg_prescale            ;   //  0x14

    //  Decalar reg of output
    reg     [DATA_WIDTH - 1 : 0]        prdata              ;

    // Connect to Output
    assign      prdata_o                =   prdata              ;
    assign      reg_transmit_o          =   reg_transmit        ;
    assign      reg_slave_address_o     =   reg_slave_address   ; 
    assign      reg_command_o           =   reg_command         ;
    assign      reg_prescale_o          =   reg_prescale        ;
	assign 		pready_o				=	psel_i ? 1 : 0		;

    assign      tx_winc_o   =   (penable_i == 1 && psel_i == 1 && pwrite_i == 1 && paddr_i == 8'h00) ? 1 : 0    ;
    assign      rx_rinc_o   =   (penable_i == 0 && psel_i == 1 && pwrite_i == 0 && paddr_i == 8'h04) ? 1 : 0    ;

    //  Write transfer with no wait states
    always @(posedge    pclk_i,    negedge  preset_ni) begin

        if (~preset_ni) begin

            reg_transmit            <=      0       ;
            reg_slave_address       <=      0       ;
            reg_command             <=      0       ;
            reg_prescale            <=      0       ;

        end 

        else begin
			
            // pwrite HIGH and psel HIGHT, this is write cycle
            if (penable_i == 1 && psel_i == 1 && pwrite_i == 1) begin
                
                case (paddr_i)

                    8'h00       :	begin						// When data into reg_transmit, enable write data to TX-FIFO
						reg_transmit    <=  pwdata_i    ;
					end

                    8'h0c       :       reg_slave_address       <=  pwdata_i    	;
                    8'h10       :   begin
                        reg_command[7:5]             <=  pwdata_i[7:5]        ;
                    end

                    8'h14       :       reg_prescale            <=  pwdata_i    	; 

                endcase
            end
            else if (reset_done_i) begin
                reg_command[7]  <=  1   ;
            end
            else if (start_done_i) begin
                reg_command[6]  <=  0   ;
            end

            //  prdata to apb read
            if ( (psel_i == 1) && (pwrite_i == 0) )begin
                
                case (paddr_i)

                    8'h00       :       prdata            <=  reg_transmit      ;

                    8'h04       :   begin
										prdata            <=  data_fifo_i       ;
					end

                    8'h08       :       prdata            <=  to_status_reg_i   ;
                    8'h0c       :       prdata            <=  reg_slave_address ;
                    8'h10       :       prdata            <=  reg_command       ;
                    8'h14       :       prdata            <=  reg_prescale      ;   

                endcase     
        end
            
        end
    end


endmodule