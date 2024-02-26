module apb_slave_interface_tb ();

    localparam ADDR_WIDTH = 8   ;
    localparam DATA_WIDTH = 8   ;

    reg                               pclk_i              ;     //  clock
    reg                               preset_ni           ;     //  reset signal is active-LOW
    reg   [ADDR_WIDTH - 1 : 0]        paddr_i             ;     //  address of APB slave and register map
    reg                               pwrite_i            ;     //  HIGH is write, LOW is read
    reg                               psel_i              ;     //  select slave interface
    reg                               penable_i           ;     //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    reg   [DATA_WIDTH - 1 : 0]        pwdata_i            ;     //  data write
    reg   [7:0]                       to_status_reg_i     ;
	reg   [7:0]                       data_fifo_i         ;     //  data from FIFO memory

    wire  [DATA_WIDTH - 1 : 0]        prdata_o            ;     //  data read
    wire                              pready_o            ;     //  ready to receive data
    wire     [7:0]                    reg_transmit_o      ;   //  register
    wire     [7:0]                    reg_slave_address_o ;   //  register
    wire     [7:0]                    reg_command_o       ;   //  register
    wire     [7:0]                    reg_prescale_o      ;    //  register

    //uut
    apb_slave_interface #(ADDR_WIDTH, DATA_WIDTH)   apb_slave_interface(
    .pclk_i             (pclk_i         )         ,   //  clock
    .preset_ni          (preset_ni      )         ,   //  reset signal is active-LOW
    .paddr_i            (paddr_i        )         ,   //  address of APB slave and register map
    .pwrite_i           (pwrite_i       )         ,   //  HIGH is write, LOW is read
    .psel_i             (psel_i         )         ,   //  select slave interface
    .penable_i          (penable_i      )         ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    .pwdata_i           (pwdata_i       )         ,   //  data write
    .to_status_reg_i    (to_status_reg_i)         ,
	.data_fifo_i        (data_fifo_i    )	      ,

    .prdata_o           (prdata_o       )         ,   //  data read
    .pready_o           (pready_o       )         ,   //  ready to receive data
    .reg_transmit_o     (reg_transmit_o )         ,
    .reg_slave_address_o(reg_slave_address_o)     ,
    .reg_command_o      (reg_command_o  )         ,
    .reg_prescale_o     (reg_prescale_o )    
    );

    always  #5  pclk_i  =   ~pclk_i     ;

    initial begin
        pclk_i          =       1           ;
        preset_ni       =       0           ;
        paddr_i         =       8'b11000001 ;
        pwrite_i        =       1           ;  
        psel_i          =       0           ;
        penable_i       =       1           ;
        pwdata_i        =       8'b10010011 ;
		data_fifo_i		=		3			;
        #8;
        preset_ni       =       1           ;
        #3;

        psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
		penable_i	    =		0			;
        paddr_i         =       8'b11000000 ;	// to reg_transmit

		// read-write data
		pwdata_i        =       8'b10010010 ;
		#10;
		penable_i		=		1			;
		data_fifo_i		=		8'b10101010	;
		#10;
		pwdata_i        =       8'b10000010 ;
		psel_i			=		0			;
        #20;

		// test read
		#2;
		paddr_i			=		8'b11100001	;	//	read from reg_receive
		pwrite_i		=		0			;
		psel_i			=		1			;
		penable_i	    =		0			;
		data_fifo_i		=		8'b11110001	;
		#10;
		penable_i	    =		1			;
		data_fifo_i		=		20			;
		#10;
		psel_i			=		0			;
		data_fifo_i		=		25			;
		#20;
        $stop;
    end

endmodule