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
    wire                              sda                 ;
    wire                              scl                 ;


    //i2c_slave_tb
    reg     sda_inout_tb    ;
    reg     scl_inout_tb    ;

    reg     sda_slave_tb    ;
    reg     sda_slave_en_tb ;
    reg     clk_slave_tb    ;
    
    assign  sda     =   sda_slave_en_tb ? sda_slave_tb : sda    ;

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
        .sda            (sda            )     ,
        .scl            (scl            )     
    );

    // initial  clock 
    always #5       i2c_core_clk_i  =   ~i2c_core_clk_i             ;
    always #2       pclk_i          =   ~pclk_i                     ;
    always #10      clk_slave_tb    =   ~clk_slave_tb               ;
    
    initial begin

        sda_slave_tb        =       0                               ;
        clk_slave_tb        =       0                               ;

        i2c_core_clk_i      =       0       ;
        pclk_i              =       0       ;
        preset_ni           =       0       ;
        paddr_i             =   0           ;
        pwrite_i            =   1           ;
        psel_i              =   0           ;
        penable_i           =   0           ;
        pwdata_i            =   11          ;
        #8;

        preset_ni           =   1           ;
        #3;

        //  write command to reset and enable to write data to FIFO
        paddr_i             =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
        pwdata_i            =   8'b0000_1111 ;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                                // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc ; cmd[0] = RX_rinc
        #4;
        //  write adress slave
        paddr_i             =   8'b11000011 ;   // addr [5:0] = 3 , slave_reg
        psel_i              =   0           ;
        penable_i           =   1           ;
        #4;

        penable_i           =   1           ;
        pwdata_i            =   8'b1100_1010       ;   // slave's address 
        #4;
        paddr_i             =   8'b11000101 ;   // addr [5:0] = 5 , prescale_reg
        pwdata_i            =   2'h08       ;
        #4;

        //  write data to transmit
        paddr_i             =   8'b11000000 ;   // addr [5:0] = 0 , transmit_reg
        pwdata_i            =   2'h21       ;
        #4;
        pwdata_i            =   2'h22       ;
        #4;
        pwdata_i            =   2'h23       ;
        #4;

        //  write command to not reset
        paddr_i             =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
        pwdata_i            =   8'b1000_1111 ;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                                // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc ; cmd[0] = RX_rinc
        #4;

        // write command to enable write to sda
        paddr_i             =   8'b1100_0100 ;   // addr [5:0] = 4 , command_reg
        pwdata_i            =   8'b1100_1111 ;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = 1-Read, 0-Write
                                                // cmd[3] = TX_winc ; cmd[2] = TX_rinc ; cmd[1] = RX_winc ; cmd[0] = RX_rinc

        #1000;
        $stop;
    end
endmodule