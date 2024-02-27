module i2c_top_tb ();
    
    reg                               i2c_core_clk_i      ;   // clock core of i2c
    reg                               pclk_i              ;   //  APB clock
    reg                               preset_ni           ;   //  reset signal is active-LOW
    reg   [7 : 0]         paddr_i             ;   //  address of APB slave and register map
    reg                               pwrite_i            ;   //  HIGH is write, LOW is read
    reg                               psel_i              ;   //  select slave interface
    reg                               penable_i           ;   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    reg   [7 : 0]         pwdata_i            ;   //  data write

    wire  [7 : 0]         prdata_o            ;   //  data read
    wire                              pready_o            ;   //  ready to receive data
    wire                              sda_io                 ;
    wire                              scl_io                 ;


    //i2c_slave_tb
	reg     en_tb			;

    reg     sda_slave_tb    ;
    reg     sda_slave_en_tb ;

    
    assign  sda_io     =   sda_slave_en_tb ? sda_slave_tb : 1'bz    ;
	pullup (sda_io);

	// used test
	reg [7:0] 	get_value_sda_tb	;
	reg	 [7:0]	temp				;
	reg	 [2:0] 	i					;

    i2c_top     uut (
        .i2c_core_clk_i (i2c_core_clk_i )     ,   // clock core of i2c
        .pclk_i         (pclk_i         )     ,   //  APB clock
        .preset_ni      (preset_ni      )     ,   //  reset signal is active-LOW
        .paddr_i        (paddr_i        )     ,   //  address of APB slave and register map
        .pwrite_i       (pwrite_i       )     ,   //  HIGH is write, LOW is read
        .psel_i         (psel_i         )     ,   //  select slave interface
        .penable_i      (penable_i      )     ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
        .pwdata_i       (pwdata_i       )     ,   //  data write

        .prdata_o       (prdata_o       )     ,   //  data read
        .pready_o       (pready_o       )     ,   //  ready to receive data
        .sda            (sda_io         )     ,
        .scl            (scl_io         )     
    );

    // initial  clock 
    always #10       i2c_core_clk_i  =   ~i2c_core_clk_i             ;
    always #5        pclk_i          =   ~pclk_i                     ;
    //always #10      clk_slave_tb    =   ~clk_slave_tb               ;
    
    initial begin

		temp				=		0		;
		i					=		7		;

        sda_slave_tb        =       0       ;
        sda_slave_en_tb     =  		0		;
		en_tb				=		0		;

        i2c_core_clk_i      =       0       ;

		//---------------------------------------------
		pclk_i          =       1           ;
        preset_ni       =       0           ;
        paddr_i         =       8'b11000001 ;
        pwrite_i        =       1           ;  
        psel_i          =       0           ;
        penable_i       =       1           ;
        pwdata_i        =       8'b10010011 ;
		//data_fifo_i		=		3			;
        #8;
        preset_ni       =       1           ;
        #3;

        psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
		penable_i	    =		0			;
        paddr_i         =       8'b11000000 ;	// to reg_transmit

        // test write data
		// Step 1 : write to reset 
		paddr_i         =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
		pwdata_i        =   8'b0000_0000 ;   // cmd[7] = rst_n   ; cmd[6] = enable  ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                             // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc     ; cmd[0] = RX_rinc
		#10;
		penable_i		=		1			;
		#53; // time reset

		// Step 1b : off reset_n and but enable = 0 FSM does not active
		paddr_i         =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
		pwdata_i        =   8'b1000_0000 ;   // cmd[7] = rst_n   ; cmd[6] = enable  ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                             // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc     ; cmd[0] = RX_rinc
		#10;

		// Step 2 : write slave's address
		paddr_i         =       8'b1100_0011 ;	// to reg_slave
		pwdata_i        =       8'b11000010  ;
		#10;

		// Step 3 : write prescale to generate to scl
        paddr_i             =   8'b11000101 ;   // addr [5:0] = 5 , prescale_reg
        pwdata_i            =   8           ;
		#10;


		// Step 4a : Write data
        paddr_i             =   8'b11000000 ;   // addr [5:0] = 0 , transmit_reg
        pwdata_i            =   11       ;
        #20;
		// Step 4b : Enable Write data to TX-FIFO mem
		paddr_i         =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
		pwdata_i        =   8'b1000_1000 ;   // cmd[7] = rst_n   ; cmd[6] = enable  ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                             // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc     ; cmd[0] = RX_rinc
		#10;
		// Next byte
		paddr_i             =   8'b11000000 ;   // addr [5:0] = 0 , transmit_reg
        pwdata_i            =   12       ;
        #10;
        pwdata_i            =   13       ;
        #10;

		// Step 4c : done write data, cannot write to TX_FIFO
		paddr_i         =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
		pwdata_i        =   8'b1000_0000 ;   // cmd[7] = rst_n   ; cmd[6] = enable  ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                             // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc     ; cmd[0] = RX_rinc
		#10;


		// Step 5 : Write command to start i2c
        paddr_i             =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
        pwdata_i            =   8'b1100_0111 ;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                                 // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc ; cmd[0] = RX_rinc
        #10;

		// Step 5 :finsish write command and prepare data
        penable_i       =       0           ;
		pwdata_i        =   8'b0000_1111;

		// Step 7 : Run FSM
		// Slave write ACK 1
		#1417;
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;
		sda_slave_tb        =   0   ;
		#163;
		sda_slave_en_tb		= 	0	;
		en_tb 				= 	0	;	

		repeat(8) begin
			 @ (posedge scl_io) begin
				temp[i] = 	sda_io	;
				i 		= 	i - 1	;
			end
		end
		get_value_sda_tb	=	temp;
		i 					=	7	;
		#100;

		// Slave write later ACK 2
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;
		sda_slave_tb        =   0   ;
		#160;
		sda_slave_en_tb		= 	0	;
		en_tb 				= 	0	;	

		repeat(8) begin
			 @ (posedge scl_io) begin
				temp[i] = 	sda_io	;
				i 		= 	i - 1	;
			end
		end
		get_value_sda_tb	=	temp;
		i 					=	7	;
		#100;

		// Slave write later ACK 3
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;
		sda_slave_tb        =   0   ;
		#160;
		sda_slave_en_tb		= 	0	;
		en_tb 				= 	0	;	

		repeat(8) begin
			 @ (posedge scl_io) begin
				temp[i] = 	sda_io	;
				i 		= 	i - 1	;
			end
		end
		get_value_sda_tb	=	temp;
		i 					=	7	;
		#100;

		// Slave write later ACK 4
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;
		sda_slave_tb        =   0   ;
		#160;
		sda_slave_en_tb		= 	0	;
		en_tb 				= 	0	;	
		#100;

		// Finsh write-test, CPU write cmd to turn off enable
		penable_i				=	1			 ; 
        paddr_i             =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
        pwdata_i            =   8'b1000_0111 ;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                                 // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc ; cmd[0] = RX_rinc
        #10;
		penable_i			=	0			;
		psel_i				=	0			;
		#500;

		//--------------------------------------------------------------------------------
		// Test read-data
		// Step 1 : reset apb => reset reg
		preset_ni	=	0	;
		#8;
		preset_ni 	=	1	;
		#3;
		psel_i		=	1	;
		pwrite_i	=	1	;

		// Step 2 : CPU write slave's address
		paddr_i         =   8'b1100_0011 ;	// to reg_slave
		pwdata_i        =   8'b1100_0101 ;
		penable_i		=	1			 ;
		#10;
		
		// Step 3 : write prescale to generate to scl
        paddr_i             =   8'b11000101 ;   // addr [5:0] = 5 , prescale_reg
        pwdata_i            =   8           ;
		#10;

		// Step 4 : CPU write cmd to turn on enable
        paddr_i             =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
        pwdata_i            =   8'b1100_0111 ;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
        										 // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc ; cmd[0] = RX_rinc
        #10;

		// Step 5 : APB read
		//pwrite_i	=	0	;
		// Slave write ACK
		#1509;
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;
		sda_slave_tb        =   0   ;
		#163;
		sda_slave_en_tb		= 	0	;
		en_tb 				= 	0	;	



		#2000;  
        $stop;
    end
endmodule