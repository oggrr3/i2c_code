`timescale 1us/1ps

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
    wire    [7:0]   data    ;
    //integer i;
    
    //  --------------- for debug --------------
    //wire [7:0]  debug_command;
    //  --------------- end debug --------------

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
	reg            detect_stop     ;

    i2c_top     uut (
        .i2c_core_clk_i (i2c_core_clk_i )     ,   // clock core of i2c
        .pclk_i         (pclk_i         )     ,   //  APB clock
        .preset_ni      (preset_ni      )     ,   //  reset signal is active-LOW
        .paddr_i        (paddr_i        )     ,   //  address of APB slave and register map
        .pwrite_i       (pwrite_i       )     ,   //  HIGH is write, LOW is read
        .psel_i         (psel_i         )     ,   //  select slave interface
        .penable_i      (penable_i      )     ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
        .pwdata_i       (pwdata_i       )     ,   //  data write

        //.debug_command  (debug_command  )     ,
        
        .prdata_o       (prdata_o       )     ,   //  data read
        .pready_o       (pready_o       )     ,   //  ready to receive data
        .sda            (sda_io         )     ,
        .scl            (scl_io         )     
    );
    
    //  i2c slave model
    // i2c_slave_model i2c_slave (
    //     .sda (sda_io),
    //     .scl (scl_io)
    // );

    // initial  clock 
    always #10       i2c_core_clk_i  =   ~i2c_core_clk_i             ;
    always #5        pclk_i          =   ~pclk_i                     ;

    task Apb_Write(input 	[7:0]	addr, input	[7:0]	data);
		begin
        	@(posedge   pclk_i)                       		;
        	paddr_i      <=  addr                        ;
        	pwrite_i     <=  1                           ;
        	psel_i       <=  1                           ;
        	penable_i    <=  0                           ;
        	pwdata_i     <=  data                        ;
        	@(posedge   pclk_i);
        	penable_i    <=  1                           ;
        	@(posedge   pclk_i)                       ;
        	$display("APB write data = %h into register = %h  at time = %t", data, addr, $time);
        	psel_i       <=  0                           ;
        	penable_i    <=  0                           ;
        	@(negedge pclk_i)                         ;
		end
    endtask
    
    task Check_Stop_Condition ();
        begin
            detect_stop     =   0   ;
            while (!detect_stop) begin
                @(posedge   sda_io);
                if(scl_io) begin     
                    $display("\tSTOP condition found at %t", $time); 
                    detect_stop =   1   ;
                end
            end
        end
    endtask

    // task Get1Byte_From_Sda (output data );
    //     begin
    //         for (i = 0; i < 8 ; i = i + 1) begin
    //             @(posedge scl_io) ;
    //             data[7-i]     =    sda_io   ;
    //         end

    //         $display("--------Deteced 1 byte data = %h from SDA at time = %0t--------", data, $time);
    //     end
    // endtask 

    // task Check_ACK();
    //     begin
    //         @(posedge scl_io) ;
    //         if (!sda_io)
    //             $display("---Detected  ACK at time = %0t", $time)    ;
    //         else    
    //             $display("---Detected NACK at time = %0t", $time)    ;
    //     end
    // endtask
    
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
        #53;
        preset_ni       =       1           ;
        #4;

        // ------------------------test write data---------------------------------------
		// Step 1 : write data to TX-FIFO
		Apb_Write(8'h00, 8'h00);				// to reg_transmit
		Apb_Write(8'h00, 8'h1b);				// to reg_transmit
		Apb_Write(8'h00, 8'h42);				// to reg_transmit
        repeat(2) Apb_Write(8'h00, $urandom());
        
		// Step 2 : write slave's address
		Apb_Write(8'h03, 8'h20);					// to reg_addr_slave

		// Step 3 : write prescale to generate to scl
		Apb_Write(8'h05, 8'h06);				// to reg_prescale;

		// Step 4 : Write command to start i2c
		Apb_Write(8'h04, 8'hc0);					// addr [5:0] = 4 , command_reg
												// cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = read-only
												// cmd[3] = read-only ; cmd[2] = read-only ; cmd[1] = read-only ; cmd[0] = read-only
        Apb_Write(8'h04, 8'hff);
        Apb_Write(8'h04, 8'hc0);
		// Step 7 : Run FSM

//		repeat(8) begin
//			 @ (posedge scl_io) begin
//				temp[i] = 	sda_io	;
//				i 		= 	i - 1	;
//			end
//		end
//		@ (negedge scl_io) begin
//			get_value_sda_tb	=	temp;
//			i 					=	7	;
//		end

		repeat(9) begin
			 @ (posedge scl_io);
		end
        en_tb = 1;
        sda_slave_en_tb = 1;
        @ (posedge scl_io);
        en_tb = 0;
        sda_slave_en_tb = 0;

        Check_Stop_Condition();
		
		#500;
		$stop;
		//------------------------Done write test------------------------
    end

endmodule
