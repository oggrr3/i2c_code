module i2c_core     #(parameter     DATA_SIZE   =   8   ,
                      parameter     ADDR_SIZE   =   8   )
(
    input   [DATA_SIZE - 1]     data_transmit_i                 ,   // data transmit from MCU to FIFO
    input   [ADDR_SIZE - 1]     slave_addr_rw_i                 ,   // Slave's address and read/write bit
    input   [7 : 0]             command_i                       ,   // command from MCU include: enable, repeat_start, reset, r/w
    input   [7 : 0]             prescale_i                      ,   // value used to generate scl_clk from core_clk
    input                       i2c_core_clk_i                  ,   // clock core of i2c
    input                       APB_clk_i                       ,   // APB clock
    input                       i2c_sda_i                       ,   // sda line input
    input                       i2c_scl_i                       ,   // scl line input

    output                      i2c_sda_o                       ,   // sda line output
    output                      i2c_scl_o                       ,   // scl line output
    output                      interrupt_o                     ,   // interrrupt signal output
    output   [DATA_SIZE - 1]    data_receive_o                  ,   // data recieved from FIFO
    output   [7 : 0]            status_o                            // status of FIFO: full, empty
);

    wire                        i2c_sda_en                      ;
    wire                        i2c_scl_en                      ;
    wire                        i2c_sda                         ;
    wire                        i2c_scl                         ;

    // Decalar netlist
    wire                        clk_en                          ;
    wire                        reset_n                         ;
    wire                        enable                          ;
    wire                        repeat_start                    ;
    wire                        rw                              ;
    wire                        full                            ;
    wire                        empty                           ;
    wire                        sda_low_en                      ;
    wire                        write_data_en                   ;
    wire                        write_addr_en                   ;
    wire                        receive_data_en                 ;
    wire                        count_bit                       ;



    assign      i2c_sda_o       =       i2c_sda_en ? i2c_sda : 1'bz     ;
    assign      i2c_scl_o       =       i2c_scl_en ? i2c_scl : 1'bz     ;
    assign      i2c_scl_i       =       i2c_scl_o                       ;
    assign      i2c_sda_i       =       i2c_sda_o                       ;

    // dut
    clock_generator #(parameter DIVIDE_BY = 8)     clock_generator 
    (
		.i2c_core_clk_i	(i2c_core_clk_i )     ,   // i2c core clock
    	.clk_en_i		(clk_en		    )     ,   // enbale clock to scl
		.reset_ni		(reset_n		)	  ,     
    	.i2c_scl_o 		(i2c_scl		)         // scl output
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

    	.sda_low_en_o       (sda_low_en         )      ,   // when = 1 enable sda down 0
    	.clk_en_o           (clk_en             )      ,   // enbale to generator clk
    	.write_data_en_o    (write_data_en      )      ,   // enable write data on sda
    	.write_addr_en_o    (write_addr_en      )      ,   // enable write address of slave on sda
    	.receive_data_en_o  (receive_data_en    )      ,   // enable receive data from sda
    	.count_bit_o        (count_bit          )      ,   // count bit data from 7 down to 0
    	.i2c_sda_en_o       (i2c_sda_en         )      ,   // allow impact to sda
    	.i2c_scl_en_o       (i2c_scl_en         )          // allow impact to scl
    );





    
endmodule