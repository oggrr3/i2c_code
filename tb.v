module tb ;
    reg           i2c_core_clk_i      ;   // i2c core clock
    reg           clk_en_i            ;   // enbale clock to scl
    reg           reset_ni            ;   // reset negetive

    wire          i2c_scl_o           ;   // scl output

	// dut
	clock_generator	dut (
		.i2c_core_clk_i	(i2c_core_clk_i )     ,   // i2c core clock
    	.clk_en_i		(clk_en_i		)     ,   // enbale clock to scl
		.reset_ni		(reset_ni		)	  ,
    	.i2c_scl_o 		(i2c_scl_o		)         // scl output
	);

	always	#5	i2c_core_clk_i	=	~i2c_core_clk_i		;

	initial begin
		clk_en_i			=	0		;
		reset_ni			=	1		;
		i2c_core_clk_i		=	0		;
		#5;
	
		reset_ni			=	0		;
		#3;
		reset_ni			=	1		;
		
		#123						;

		clk_en_i	=	1		;
		#265						;

		clk_en_i	=	0		;
		#50						;
		$stop					;

	end

endmodule
