module i2c_top_tb ();
    
    reg                               i2c_core_clk_i      ;   // clock core of i2c
    reg                               pclk_i              ;   //  APB clock
    reg                               preset_ni           ;   //  reset signal is active-LOW
    reg   [7 : 0]         			  paddr_i             ;   //  address of APB slave and register map
    reg                               pwrite_i            ;   //  HIGH is write, LOW is read
    reg                               psel_i              ;   //  select slave interface
    reg                               penable_i           ;   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    reg   [7 : 0]         			  pwdata_i            ;   //  data write

    wire  [7 : 0]         			  prdata_o            ;   //  data read
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
    always #2        pclk_i          =   ~pclk_i                     ;
    //always #10      clk_slave_tb    =   ~clk_slave_tb               ;
    
    initial begin

		temp				=		0		;
		i					=		7		;

        sda_slave_tb        =       0       ;
        sda_slave_en_tb     =  		0		;
		en_tb				=		0		;

        i2c_core_clk_i      =       0       ;
			
		// reset apb -> reset i2c core
		//---------------------------------------------
		pclk_i          =       1           ;
        preset_ni       =       0           ;
        paddr_i         =       8'b00000001 ;
        pwrite_i        =       0           ;  
        psel_i          =       0           ;
        penable_i       =       0           ;
        pwdata_i        =       8'b00000000 ;
        #50;
        preset_ni       =       1           ;
        #5;

        // ------------------------test write data---------------------------------------
		// Step 1 : write data to TX-FIFO
		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =       8'b00000000 ;	// to reg_transmit
		pwdata_i        =       8'b1000_1010 ;	// 8a
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#4;

		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =       8'b00000000 ;	// to reg_transmit
		pwdata_i        =       8'b0010_1011 ;	// 2b
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#4;

		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =       8'b00000000 ;	// to reg_transmit
		pwdata_i        =       8'b1100_0011 ;	// c3
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#4;


		// Step 2 : write slave's address

		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =       8'b0000_0011 ;	// addr [5:0] = 3 , slave's address
		pwdata_i        =       8'b0100_1010 ;	// addr = 0100_101 and RW = 0 => WRITE
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#15;

		// Step 3 : write prescale to generate to scl
		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =       8'b0000_0101 ;	// addr [5:0] = 5 , prescale_reg
		pwdata_i        =       6			 ;	// 6
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#15;

		// Step 4 : Write command to start i2c


		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =   8'b0000_0100 	;   // addr [5:0] = 4 , command_reg
        pwdata_i        =   8'b110_00000 	;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = read-only
                                                // cmd[3] = read-only ; cmd[2] = read-only ; cmd[1] = read-only ; cmd[0] = read-only
        #10;
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#15;

		// Step 7 : Run FSM

		repeat (4) begin
		repeat(8) begin
			 @ (posedge scl_io) begin
				temp[i] = 	sda_io	;
				i 		= 	i - 1	;
			end
		end
		@ (negedge scl_io) begin
			get_value_sda_tb	=	temp;
			i 					=	7	;
		end
		#20;
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;
		sda_slave_tb        =   0   ;
		#120;
		en_tb 				= 	0	;	
		sda_slave_en_tb 	=	0	;
		end
		
		#500;
		//------------------------Done write test------------------------

		//------------------------Test read------------------------------
		//Step 1 : reset APB -> reset i2c core
		preset_ni	=	0	;
		#50;
		preset_ni	=	1	;
		#5;

		// Step 2 : write slave's address
		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =       8'b0000_0011 ;	// addr [5:0] = 3 , slave's address
		pwdata_i        =       8'b0110_1001 ;	// addr = 0110_100 and RW = 1 => READ
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#15;

		// Step 3 : write prescale to generate to scl
		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =       8'b0000_0101 ;	// addr [5:0] = 5 , prescale_reg
		pwdata_i        =       6			 ;	// 6
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#15;

		// Step 4 : Write command to start i2c
		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		1			;
        paddr_i         =   8'b0000_0100 	;   // addr [5:0] = 4 , command_reg
        pwdata_i        =   8'b110_00000 	;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = read-only
                                                // cmd[3] = read-only ; cmd[2] = read-only ; cmd[1] = read-only ; cmd[0] = read-only
        #10;
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done write 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		0			;
		#15;

		// Step 5 : Slave sent ACK 
		repeat(8) begin
			 @ (posedge scl_io) begin
				temp[i] = 	sda_io	;
				i 		= 	i - 1	;
			end
		end
		@ (negedge scl_io) begin
			get_value_sda_tb	=	temp;
			i 					=	7	;
		end
		#20;
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;
		sda_slave_tb        =   0   ;	// Slave ACK
		#120;
		// Step 6 : Slave prepare data

		repeat (4) begin
		// Write byte 1001_0100 = 0x94
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;

		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		en_tb 				= 	0	;	
		sda_slave_en_tb 	=	0	;
		#120;

		// Write byte 1100_0101 = 0xc5
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;

		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   1   ;
		#120;
		en_tb 				= 	0	;	
		sda_slave_en_tb 	=	0	;
		#120;


		// Write byte 0010_0001 = 0x21
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;

		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   1   ;
		#120;
		en_tb 				= 	0	;	
		sda_slave_en_tb 	=	0	;
		#120;

		// Write byte 1000_0100 = 0x84
		en_tb 				= 	1	;	
		sda_slave_en_tb 	=	1	;

		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   1   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		sda_slave_tb        =   0   ;
		#120;
		en_tb 				= 	0	;	
		sda_slave_en_tb 	=	0	;
		#120;
		end


		pwrite_i		=		1			;
		#499;
		// Step 7: Finally, CPU read data from RX-FIFO
		repeat (18) begin
		psel_i          =       1           ;
        penable_i       =       0           ;
		pwrite_i		=		0			;
        paddr_i         =       8'b00000001 ;	// addr [5:0] = 1 , read from FIFO
		#4;
		penable_i		=		1			;
		#4;
		psel_i			=		0			;	// done read 1 byte data
		penable_i       =       0           ;
		pwrite_i		=		1			;
		#10;
		penable_i       =       1           ;
		#10;		
		end
	

		#200;
        $stop;


    end

endmodule
