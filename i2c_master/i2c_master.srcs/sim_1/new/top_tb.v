module top_tb ();


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
    wire                              sda_io              ;
    wire                              scl_io              ;

    // initial  clock 
    always #10       i2c_core_clk_i  =   ~i2c_core_clk_i             ;
    always #2        pclk_i          =   ~pclk_i                     ;

    i2c_top     i2c_master_top (
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

    i2c_slave_model i2c_slave   (
        .sda    (sda_io )   ,
        .scl    (scl_io )   
    );

    // Initial
    initial begin
        i2c_core_clk_i  =       0           ;
        pclk_i          =       0           ;
        preset_ni       =       0           ;
        paddr_i         =       8'b00000001 ;
        pwrite_i        =       0           ;  
        psel_i          =       0           ;
        penable_i       =       0           ;
        pwdata_i        =       8'b00000000 ;
        #50;
        preset_ni       =       1           ;
        #5;
        
                // Step 1 : write data to TX-FIFO
                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =       8'b00000000 ;    // to reg_transmit
                pwdata_i        =       2'h10 ;    // 8a
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #4;
        
                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =       8'b00000000 ;    // to reg_transmit
                pwdata_i        =       8'b0010_1011 ;    // 2b
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #4;
        
                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =       8'b00000000 ;    // to reg_transmit
                pwdata_i        =       8'b1100_0011 ;    // c3
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #4;
                
                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =       8'b00000000 ;    // to reg_transmit
                pwdata_i        =       8'b0100_0011 ;    // 43
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #4;
                
                                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =       8'b00000000 ;    // to reg_transmit
                pwdata_i        =       8'b0100_0011 ;    // 43
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #4;
                
                                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =       8'b00000000 ;    // to reg_transmit
                pwdata_i        =       8'b0100_0011 ;    // 43
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #4;
                
        
        
                // Step 2 : write slave's address
        
                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =       8'b0000_0011 ;    // addr [5:0] = 3 , slave's address
                pwdata_i        =       8'b0010_0000 ;    // addr = 0100_101 and RW = 0 => WRITE
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #15;
        
                // Step 3 : write prescale to generate to scl
                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =       8'b0000_0101 ;    // addr [5:0] = 5 , prescale_reg
                pwdata_i        =       8             ;    // 6
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #15;
        
                // Step 4 : Write command to start i2c
        
        
                psel_i          =       1           ;
                penable_i       =       0           ;
                pwrite_i        =        1            ;
                paddr_i         =   8'b0000_0100     ;   // addr [5:0] = 4 , command_reg
                pwdata_i        =   8'b110_00000     ;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = read-only
                                                        // cmd[3] = read-only ; cmd[2] = read-only ; cmd[1] = read-only ; cmd[0] = read-only
                #10;
                #4;
                penable_i        =        1            ;
                #4;
                psel_i            =        0            ;    // done write 1 byte data
                penable_i       =       0           ;
                pwrite_i        =        0            ;
                #15;

                #10000;
                
                //------------------------Test read------------------------------
                        //Step 1 : reset APB -> reset i2c core
                        preset_ni    =    0    ;
                        #50;
                        preset_ni    =    1    ;
                        #5;
                
                        // Step 2 : write slave's address
                        psel_i          =       1           ;
                        penable_i       =       0           ;
                        pwrite_i        =        1            ;
                        paddr_i         =       8'b0000_0011 ;    // addr [5:0] = 3 , slave's address
                        pwdata_i        =       8'b0010_0001 ;    // addr = 0110_100 and RW = 1 => READ
                        #4;
                        penable_i        =        1            ;
                        #4;
                        psel_i            =        0            ;    // done write 1 byte data
                        penable_i       =       0           ;
                        pwrite_i        =        0            ;
                        #15;
                
                        // Step 3 : write prescale to generate to scl
                        psel_i          =       1           ;
                        penable_i       =       0           ;
                        pwrite_i        =        1            ;
                        paddr_i         =       8'b0000_0101 ;    // addr [5:0] = 5 , prescale_reg
                        pwdata_i        =       6             ;    // 6
                        #4;
                        penable_i        =        1            ;
                        #4;
                        psel_i            =        0            ;    // done write 1 byte data
                        penable_i       =       0           ;
                        pwrite_i        =        0            ;
                        #15;
                
                        // Step 4 : Write command to start i2c
                        psel_i          =       1           ;
                        penable_i       =       0           ;
                        pwrite_i        =        1            ;
                        paddr_i         =   8'b0000_0100     ;   // addr [5:0] = 4 , command_reg
                        pwdata_i        =   8'b110_00000     ;   // cmd[7] = rst_n ; cmd[6] = enable ; cmd[5] = reapt_start ; cmd[4] = read-only
                                                                // cmd[3] = read-only ; cmd[2] = read-only ; cmd[1] = read-only ; cmd[0] = read-only
                        #10;
                        #4;
                        penable_i        =        1            ;
                        #4;
                        psel_i            =        0            ;    // done write 1 byte data
                        penable_i       =       0           ;
                        pwrite_i        =        0            ;
                        #15;
                        
                        #30000;
                        $stop;
    end
    
endmodule
