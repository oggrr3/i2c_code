module i2c_top      #(parameter     DATA_SIZE   =   8   ,
                      parameter     ADDR_SIZE   =   8   )
(
    input   [DATA_SIZE - 1 : 0]     data_transmit_i                 ,   // data transmit from MCU to FIFO
    input   [ADDR_SIZE - 1 : 0]     slave_addr_rw_i                 ,   // Slave's address and read/write bit
    input   [7 : 0]                 command_i                       ,   // command from MCU include: enable, repeat_start, reset, r/w
    input   [7 : 0]                 prescale_i                      ,   // value used to generate scl_clk from core_clk
    input                           i2c_core_clk_i                  ,   // clock core of i2c
    input                           APB_clk_i                       ,   // APB clock
    input                           i2c_sda_i                       ,   // sda line input
    input                           i2c_scl_i                       ,   // scl line input

    output                          i2c_sda_o                       ,   // sda line output
    output                          i2c_scl_o                       ,   // scl line output
    output                          interrupt_o                     ,   // interrrupt signal output
    output   [DATA_SIZE - 1 : 0]    data_receive_o                  ,   // data recieved from FIFO
    output   [7 : 0]                status_o                        ,   // status of FIFO: full, empty
    output                          i2c_sda_en_o                    ,
    output                          i2c_scl_en_o        
);


	// Full, empty = 0 dung de test, nao xong FIFO xoa doan nay di roi xoa comment o full, empty,  ben duoi
	// va sua lai dong 106 noi day data_in va data_path
	//-------------------------------------------------------
	reg		FIFO_full	= 0;
	reg		FIFO_empty	= 0;
	assign	full	=	FIFO_full	;
	assign	empty	=	FIFO_empty	;
	//------------------------------------------------------

    // Decalar netlist
    wire                        i2c_sda_en                      ;
    wire                        i2c_scl_en                      ;
    wire                        i2c_sda                         ;
    wire                        i2c_scl                         ;

    wire                        clk_en                          ;
    wire                        reset_n                         ;
    wire                        enable                          ;
    wire                        repeat_start                    ;
    wire                        rw                              ;
    //wire                        full                            ;
    //wire                        empty                           ;
	wire						w_fifo_en						;
	wire						r_fifo_en_o						;
    wire                        sda_low_en                      ;
    wire                        write_data_en                   ;
    wire                        write_addr_en                   ;
    wire                        receive_data_en                 ;
    wire	[3:0]                        count_bit                       ;

    wire  [DATA_SIZE - 1 : 0]   data                            ;
    wire  [DATA_SIZE - 1 : 0]   data_from_sda                   ;




    // get command bit
    assign      enable          =       command_i[6]            ;
    assign      reset_n         =       command_i[7]            ;
    assign      repeat_start    =       command_i[5]            ;
    assign      rw              =       command_i[4]            ;

    // push data to i2c line
    assign      i2c_sda_o       =       i2c_sda     ;
    assign      i2c_scl_o       =       i2c_scl     ;

    // dut
    clock_generator                              clock_generator 
    (
		.i2c_core_clk_i	    (i2c_core_clk_i     )     ,   // i2c core clock
    	.clk_en_i		    (clk_en		        )     ,   // enbale clock to scl
		.reset_ni		    (reset_n		    )	  ,
        .prescale_i         (prescale_i         )     ,
    	.i2c_scl_o 		    (i2c_scl		    )         // scl output
    );

    i2c_master_fsm                                  i2c_master_fsm
    (
        .enable_i           (enable             )      ,   // enable signal from MCU
    	.reset_ni           (reset_n            )      ,   // reset negative signal from MCU
    	.repeat_start_i     (repeat_start       )      ,   // repeat start signal from MCU
    	.rw_i               (rw                 )      ,   // bit 1 is read - 0 is write
    	.full_i             (full               )      ,   // FIFO buffer is full
    	.empty_i            (empty              )      ,   // FIFO buffer is empty
    	.i2c_core_clk_i     (i2c_core_clk_i     )      ,   // i2c core clock
    	.i2c_sda_i          (i2c_sda_i          )      ,   // i2c sda feedback to FSM
    	.i2c_scl_i          (i2c_scl_i          )      ,   // i2c scl feedback to FSM

		.w_fifo_en_o		(w_fifo_en			)		,
		.r_fifo_en_o		(r_fifo_en			)		,

    	.sda_low_en_o       (sda_low_en         )      ,   // when = 1 enable sda down 0
    	.clk_en_o           (clk_en             )      ,   // enbale to generator clk
    	.write_data_en_o    (write_data_en      )      ,   // enable write data on sda
    	.write_addr_en_o    (write_addr_en      )      ,   // enable write address of slave on sda
    	.receive_data_en_o  (receive_data_en    )      ,   // enable receive data from sda
    	.count_bit_o        (count_bit          )      ,   // count bit data from 7 down to 0
    	.i2c_sda_en_o       (i2c_sda_en_o       )      ,   // allow impact to sda
    	.i2c_scl_en_o       (i2c_scl_en_o       )          // allow impact to scl
    );

    data_path_i2c_to_core   # (DATA_SIZE    , ADDR_SIZE    )                           
    data_path_i2c_to_core (
        .data_i               (data_transmit_i  )         ,   // data from fifo buffer
        .addr_i               (slave_addr_rw_i  )         ,   // address of slave
        .count_bit_i          (count_bit        )         ,   // sda input
        //.i2c_core_clk_i       (i2c_core_clk_i   )         ,   // i2c core clock
        //.reset_ni             (reset_n          )         ,   // reset negetive signal from MCU
        .i2c_sda_i            (i2c_sda_i        )         ,   // sda line

        .sda_low_en_i         (sda_low_en       )         ,   // control sda signal from FSM, when 1 sda = 0
        .write_data_en_i      (write_data_en    )         ,   // enable write data signal from FSM
        .write_addr_en_i      (write_addr_en    )         ,   // enable write slave's signal to sda 
        .receive_data_en_i    (receive_data_en  )         ,   // enable receive data from sda

        .data_from_sda_o      (data_from_sda    )         ,   // data from sda to write to FIFO buffer
        .i2c_sda_o            (i2c_sda          )            // i2c sda output   
        //.data_done_o          (data_done        )            // finish processed data input and output  
    );

endmodule