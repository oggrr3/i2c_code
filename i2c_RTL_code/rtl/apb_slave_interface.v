module apb_slave_interface  #(parameter     DATA_WIDTH  =   8,
                              parameter     ADDR_WIDTH  =   8) 
(
    input                               i2c_core_clk_i      ,   //  clock core of i2c
    input                               pclk_i              ,   //  APB clock
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
    output     [7:0]                    reg_slave_address_o ,   //  register has been synchronized from apb_clk to i2c_clk
    output     [7:0]                    reg_command_o       ,   //  register has been synchronized from apb_clk to i2c_clk
    output     [7:0]                    reg_prescale_o          //  register has been synchronized from apb_clk to i2c_clk

);

    // Decalar register map
    reg     [7:0]                       reg_transmit            ;   //  0x00
    reg     [7:0]                       reg_slave_address       ;   //  0x0c
    reg     [7:0]                       reg_command             ;   //  0x10
    reg     [7:0]                       reg_prescale            ;   //  0x14

    //  Decalar reg of output
    reg     [DATA_WIDTH - 1 : 0]        prdata                  ;
    reg                                 tx_winc                 ;
    
    reg     [7:0]                       sync1_command           ;   //  two flipflops to CDC
    reg     [7:0]                       sync2_command           ;
    reg     [7:0]                       sync1_slave_address     ;
    reg     [7:0]                       sync2_slave_address     ;
    reg     [7:0]                       sync1_prescale          ;
    reg     [7:0]                       sync2_prescale          ;
    
    wire                                tx_winc_temp            ;

    // Connect to Output
    assign      prdata_o                =   prdata              ;
    assign      reg_transmit_o          =   reg_transmit        ;
    assign      reg_slave_address_o     =   sync2_slave_address   ; 
    assign      reg_command_o           =   sync2_command         ;
    assign      reg_prescale_o          =   sync2_prescale        ;
	assign 		pready_o				=	psel_i ? 1 : 0		;

    assign      tx_winc_temp    =   (penable_i == 1 && psel_i == 1 && pwrite_i == 1 && paddr_i == 8'h00) ? 1 : 0    ;
    assign      rx_rinc_o       =   (penable_i == 0 && psel_i == 1 && pwrite_i == 0 && paddr_i == 8'h04) ? 1 : 0    ;
    assign      tx_winc_o       =   tx_winc;
    //  Write transfer with no wait states
    always @(posedge    pclk_i,    negedge  preset_ni) begin

        if (~preset_ni) begin
            prdata                  <=      0       ;
            tx_winc                 <=      0       ;
            reg_transmit            <=      0       ;
            reg_slave_address       <=      0       ;
            reg_command             <=      0       ;
            reg_prescale            <=      0       ;

        end 

        else begin
			tx_winc         <=   tx_winc_temp           ;    //  hold 1 cycle
            // pwrite HIGH and psel HIGHT, this is write cycle
            if (penable_i == 1 && psel_i == 1 && pwrite_i == 1) begin
                
                case (paddr_i)

                    8'h00       :	begin						// When data into reg_transmit, enable write data to TX-FIFO
						reg_transmit    <=  pwdata_i    ;
					end

                    8'h0c       :   begin
                        reg_slave_address       <=  pwdata_i    	;
                    end
                    
                    8'h10       :   begin
                        reg_command             <=  pwdata_i        ;
                    end

                    8'h14       :   begin  
                        reg_prescale            <=  pwdata_i    	; 
                    end

                endcase
            end
            else if (reset_done_i) begin
                reg_command[7]  <=  1   ;
            end
            else if (start_done_i) begin
                reg_command[6]  <=  0   ;
            end

            //  prdata to apb read, prdata must to prepared before penable == 1.
            if ( (psel_i == 1) && (penable_i == 0) && (pwrite_i == 0) )begin
                
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

    //  Sync from apb_clk domain to i2c_clk domain
    always @(posedge    i2c_core_clk_i,    negedge  preset_ni) begin
    
        if (~preset_ni) begin
            sync1_command               <=      0       ;
            sync2_command               <=      0       ;
            sync1_slave_address         <=      0       ;
            sync2_slave_address         <=      0       ;
            sync1_prescale              <=      0       ;
            sync2_prescale              <=      0       ;
        end 
        else begin
            {sync2_command, sync1_command}              <=  {sync1_command, reg_command}                ;
            {sync2_prescale, sync1_prescale}            <=  {sync1_prescale, reg_prescale}              ;
            {sync2_slave_address, sync1_slave_address}  <=  {sync1_slave_address, reg_slave_address}    ;
        end
        
     end     
endmodule