module apb_slave_interface_tb ();

    localparam ADDR_WIDTH = 8   ;
    localparam DATA_WIDTH = 8   ;

    reg                               pclk_i              ;     //  clock
    reg                               preset_ni           ;     //  reset signal is active-LOW
    reg   [ADDR_WIDTH - 1 : 0]        paddr_i             ;     //  address of APB slave and register map
    reg                               pwrite_i            ;     //  HIGH is write, LOW is read
    reg                               psel_i              ;     //  select slave interface
    reg                               penable_i           ;     //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    reg   [DATA_WIDTH - 1 : 0]        pwdata_i            ;     //  data write
    wire  [DATA_WIDTH - 1 : 0]        prdata_o            ;     //  data read
    wire                              pready_o            ;     //  ready to receive data

    //uut
    apb_slave_interface #(ADDR_WIDTH, DATA_WIDTH)   apb_slave_interface(
    .pclk_i     (pclk_i     )         ,   //  clock
    .preset_ni  (preset_ni  )         ,   //  reset signal is active-LOW
    .paddr_i    (paddr_i    )         ,   //  address of APB slave and register map
    .pwrite_i   (pwrite_i   )         ,   //  HIGH is write, LOW is read
    .psel_i     (psel_i     )         ,   //  select slave interface
    .penable_i  (penable_i  )         ,   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    .pwdata_i   (pwdata_i   )         ,   //  data write
    .prdata_o   (prdata_o   )         ,   //  data read
    .pready_o   (pready_o   )             //  ready to receive data
    );

    always  #5  pclk_i  =   ~pclk_i     ;

    initial begin
        pclk_i          =       1       ;
        prescale_i      =       0       ;
        paddr_i         
    end

endmodule