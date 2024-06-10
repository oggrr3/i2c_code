
module fifo_toplevel_tb # (parameter 	DATASIZE = 8,
						   parameter	ADDRSIZE = 4 ) 
();
	
	// Inputs
	reg		[DATASIZE - 1 : 0]		wdata_i	; // data which write to FIFO buffer

	reg								winc_i	; // write increase how many cells
	reg								wclk_i	; // The clock of write-domain
	reg								wrst_ni	; // The negative reset signal of write-domain

	reg								rinc_i	; // read increase how many cells
	reg								rclk_i	; // The clock of read-domain
	reg								rrst_ni	; // The negative reset signal of read-domain

	// Outputs
	wire	[DATASIZE - 1 : 0]		rdata_o	; // Data which read from FIFO buffer
	wire							rempty_o; // State of FIFO buffer is empty
	wire							wfull_o	; // State of FIFO buffer is full
	wire							w_almost_full_o		;
	wire							r_almost_empty_o	;

	integer i = 0;	
	// Instantiate the Unit Under Test	
	fifo_toplevel	uut
	(
		.wdata_i	(wdata_i 	)	, // data which write to FIFO buffer

		.winc_i		(winc_i	  	)	, // write increase how many cells
		.wclk_i		(wclk_i		)	, // The clock of write-domain
		.wrst_ni	(wrst_ni	)	, // The negative reset signal of write-domain

		.rinc_i		(rinc_i		)	, // read increase how many cells
		.rclk_i		(rclk_i		)	, // The clock of read-domain
		.rrst_ni	(rrst_ni	)	, // The negative reset signal of read-domain

		.rdata_o	(rdata_o	)	, // Data which read from FIFO buffer
		.rempty_o	(rempty_o	)	, // State of FIFO buffer is empty
		.wfull_o	(wfull_o	)	, // State of FIFO buffer is full
		.w_almost_full_o	(w_almost_full_o )	,
		.r_almost_empty_o	(r_almost_empty_o)
	);

	always	#5		wclk_i	=	~wclk_i		;
	always	#10		rclk_i	=	~rclk_i		;

	//always	#400 	winc_i	=	~winc_i		;
	//always	#400	rinc_i	=	~rinc_i		;


	initial begin
		//Initial input
		wdata_i		=	2		;
		winc_i		=	1		; // write data
		wclk_i		=	0		;
		wrst_ni		=	0		;
		
		rinc_i		=	0		;
		rclk_i		=	0		;
		rrst_ni		=	0		;
		#50;
		
		// Set reset at read-domain and write-domain up to 1
		wrst_ni		=	1		;
		rrst_ni		=	1		;
		#10;

		// Data input
			
		for (i = 4 ; i < 29; i = i + 1) begin
      		wdata_i		=	i	;	
			#10;
    	end

		#10		winc_i		=	0	; // stop write data
		#100 	rinc_i		= 	1	; // start read data
		#500;
		$stop;

	end

endmodule
