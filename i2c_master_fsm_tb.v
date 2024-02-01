module i2c_master_fsm_tb ();
    reg           enable_i            ;   // enable signal from MCU
    reg           reset_ni            ;   // reset negative signal from MCU
    reg           repeat_start_i      ;   // repeat start signal from MCU
    reg           rw_i                ;   // bit 1 is read - 0 is write
    reg           full_i              ;   // FIFO buffer is full
    reg           empty_i             ;   // FIFO buffer is empty
    reg           i2c_core_clk_i      ;   // i2c core clock
    reg           i2c_sda_i           ;   // i2c sda feedback to FSM
    wire           i2c_scl_i           ;   // i2c scl feedback to FSM

    wire          	sda_low_en_o        ;   // when = 1 enable sda down 0
    wire          	clk_en_o            ;   // enbale to generator clk
    wire          	write_data_en_o     ;   // enable write data on sda
    wire          	write_addr_en_o     ;   // enable write address of slave on sda
    wire          	receive_data_en_o   ;   // enable receive data from sda
    wire	[2:0]   count_bit_o         ;   // count bit data from 7 down to 0
    wire        	i2c_sda_en_o        ;   // allow impact to sda
    wire          	i2c_scl_en_o        ;   // allow impact to scl


    //  dut
    clock_generator     clock_generator(
        .i2c_core_clk_i (i2c_core_clk_i )      ,   // i2c core clock
        .clk_en_i       (clk_en_o       )      ,   // enbale clock to scl
        .i2c_scl_o      (i2c_scl_i      )          // scl output
    );

    i2c_master_fsm      i2c_master_fsm(
    	.enable_i           (enable_i           )      ,   // enable signal from MCU
    	.reset_ni           (reset_ni           )      ,   // reset negative signal from MCU
    	.repeat_start_i     (repeat_start_i     )      ,   // repeat start signal from MCU
    	.rw_i               (rw_i               )      ,   // bit 1 is read - 0 is write
    	.full_i             (full_i             )      ,   // FIFO buffer is full
    	.empty_i            (empty_i            )      ,   // FIFO buffer is empty
    	.i2c_core_clk_i     (i2c_core_clk_i     )      ,   // i2c core clock
    	.i2c_sda_i          (i2c_sda_i          )      ,   // i2c sda feedback to FSM
    	.i2c_scl_i          (i2c_scl_i          )      ,   // i2c scl feedback to FSM

    	.sda_low_en_o       (sda_low_en_o       )      ,   // when = 1 enable sda down 0
    	.clk_en_o           (clk_en_o           )      ,   // enbale to generator clk
    	.write_data_en_o    (write_data_en_o    )      ,   // enable write data on sda
    	.write_addr_en_o    (write_addr_en_o    )      ,   // enable write address of slave on sda
    	.receive_data_en_o  (receive_data_en_o  )      ,   // enable receive data from sda
    	.count_bit_o        (count_bit_o        )      ,   // count bit data from 7 down to 0
    	.i2c_sda_en_o       (i2c_sda_en_o       )      ,   // allow impact to sda
    	.i2c_scl_en_o       (i2c_scl_en_o       )          // allow impact to scl
    );

    always #5   i2c_core_clk_i      =       ~i2c_core_clk_i         ;

    initial begin
        enable_i            =       0       ;   
        reset_ni            =       1       ;   
        repeat_start_i      =       0       ;   
        rw_i                =       1       ;   
        full_i              =       0       ;   
        empty_i             =       0       ;   
        i2c_core_clk_i      =       1       ;  
        i2c_sda_i           =       1       ;   

        #50;

        enable_i            =       1       ;
		#3;
		reset_ni			=		0		;
		#5
		reset_ni			=		1		;
        #1000;
        $stop;
    end

endmodule