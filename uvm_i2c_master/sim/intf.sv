`ifndef INTF 
`define INTF

interface intf   (input  i2c_clk, apb_clk) ;

    logic                  preset_n         ;   //  reset signal is active-LOW
    logic   [7 : 0]        paddr            ;   //  address of APB slave and register map
    logic                  pwrite           ;   //  HIGH is write, LOW is read
    logic                  psel             ;   //  select slave interface
    logic                  penable          ;   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    logic   [7 : 0]        pwdata           ;   //  data write
    logic   [7 : 0]        prdata           ;   //  data read
    logic                  pready           ;   //  ready to receive data
    wire                   sda              ;   //  sda line
    wire                   scl              ;   //  scl line


  logic start;
  logic stop;
  logic reset;
  logic [7:0] data_slave_read;
  logic data_slave_read_valid;

endinterface 

`endif 