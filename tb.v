module tb ;
    reg           i2c_core_clk_i      ;   // i2c core clock
    reg           clk_en_i            ;   // enbale clock to scl
    wire          i2c_scl_o           ;   // scl output

	// dut
	clock_generator	dut (
		.i2c_core_clk_i	(i2c_core_clk_i )     ,   // i2c core clock
    	.clk_en_i		(clk_en_i		)     ,   // enbale clock to scl
    	.i2c_scl_o 		(i2c_scl_o		)         // scl output
	);

	always	#5	i2c_core_clk_i	=	~i2c_core_clk_i		;

	initial begin
		clk_en_i	=	0		;
		i2c_core_clk_i	=	0	;
		#123						;

		clk_en_i	=	1		;
		#165						;

		clk_en_i	=	0		;
		#50						;
		$stop					;

	end

endmodule
