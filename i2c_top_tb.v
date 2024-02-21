module i2c_top_tb ();
    
    reg       [7 : 0]               data_transmit_i                 ;    // data transmit from MCU to FIFO
    reg       [7 : 0]               slave_addr_rw_i                 ;    // Slave's address and read/write bit
    reg       [7 : 0]               command_i                       ;    // command from MCU include: enable, repeat_start, reset, r/w
    reg       [7 : 0]               prescale_i                      ;    // value used to generate scl_clk from core_clk
    reg                             i2c_core_clk_i                  ;    // clock core of i2c
    reg                             APB_clk_i                       ;    // APB clock

    wire                             i2c_sda_i                       ;    // sda line input    
    wire                             i2c_scl_i                       ;    // scl line input

    wire                            i2c_sda_o                       ;    // sda line output
    wire                            i2c_scl_o                       ;    // scl line output
    wire                            interrupt_o                     ;    // interrrupt signal output
    wire       [7 : 0]              data_receive_o                  ;    // data recieved from FIFO
    wire       [7 : 0]              status_o                        ;   // status of FIFO: full, empty
    wire                            i2c_sda_en                    ;
    wire                            i2c_scl_en                    ;


	// Decalar value to test
	//assign 			i2c_sda_o	=	(i2c_sda_o == 1'bz) ? 1 : i2c_sda_o		;

    //uut
    reg sda_o_tb;
    wire sda_i_tb;
    wire sda;
    wire scl;
    reg sda_slave_en = 0;

    assign  i2c_sda_i   =   sda_o_tb                            ;
    assign  sda         =   i2c_sda_en ? i2c_sda_o : 1'bz       ;
    assign  scl         =   i2c_scl_en ? i2c_scl_o : 1'bz       ;
    pullup (sda);
    pullup (scl);

    i2c_top     uut (
        .data_transmit_i    (data_transmit_i)             ,   // data transmit from MCU to FIFO
        .slave_addr_rw_i    (slave_addr_rw_i)             ,   // Slave's address and read/write bit
        .command_i          (command_i      )             ,   // command from MCU include: enable, repeat_start, reset, r/w
        .prescale_i         (prescale_i     )             ,   // value used to generate scl_clk from core_clk
        .i2c_core_clk_i     (i2c_core_clk_i )             ,   // clock core of i2c
        .APB_clk_i          (APB_clk_i      )             ,   // APB clock
        .i2c_sda_i          (i2c_sda_i      )             ,   // sda line input
        .i2c_scl_i          (scl            )             ,   // scl line input

        .i2c_sda_o          (i2c_sda_o      )             ,   // sda line output
        .i2c_scl_o          (i2c_scl_o      )             ,   // scl line output
        .interrupt_o        (interrupt_o    )             ,   // interrrupt signal output
        .data_receive_o     (data_receive_o )             ,   // data recieved from FIFO
        .status_o           (status_o       )             ,    // status of FIFO: full, empty
        .i2c_sda_en_o       (i2c_sda_en   )             ,
        .i2c_scl_en_o       (i2c_scl_en   )
    );

    // initial i2c clock core
    always #5       i2c_core_clk_i  =   ~i2c_core_clk_i             ;
    
    initial begin

        sda_o_tb            =       0                               ;
        data_transmit_i     =       8'b00110001                     ;
        slave_addr_rw_i     =       8'b11001110                     ;   //bit 0th,  1-read, 0-write
        command_i           =       8'b01000000                     ;   //bit 4th,  1-read, 0-write
        prescale_i          =       8                               ;
        i2c_core_clk_i      =       0                               ;
        APB_clk_i           =       0                               ;
        #8                                                          ;

        // test write data
        command_i           =       8'b11000000                     ;   // bit 4th, 1-read, 0-write
        repeat (9) @(negedge i2c_scl_o);
        sda_slave_en = 1    ;
        #10;
        sda_slave_en = 0    ;
        sda_o_tb    =   0   ;
        repeat (9) @(negedge i2c_scl_o);
        sda_slave_en = 1    ;
        #10;
        sda_slave_en = 0    ;
        data_transmit_i     =       8'b00011101                     ;

        repeat (9) @(negedge i2c_scl_o);
        sda_slave_en = 1    ;
        #10;
        sda_slave_en = 0    ;
        sda_o_tb        =       1               ;   // NACK
        command_i       =       8'b10000000     ;   // bit 6th - enable, bit 4th, 1-read, 0-write
        #500;

        // test read-data
        command_i       =       8'b01010000     ;   // reset, read mode
        #8;
        command_i       =       8'b11010000     ;   // not reset, enable, not repeat, read mode

        repeat (9) @(negedge i2c_scl_o);
        sda_slave_en = 1    ;
        #10;
        sda_o_tb    =   0   ; // Slaver ACK
        sda_slave_en = 0    ;
        // transfer data
        repeat (4)  begin
            sda_o_tb    =   1   ;
            #80;    //wait 1 cycle scl
            sda_o_tb    =   0   ;
            #80;
        end

        #1000;
        $stop;
    end
endmodule