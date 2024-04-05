`ifndef STI 
`define STI

class stimulus;
         bit                  preset_n         ;   //  reset signal is active-LOW
         bit   [7 : 0]        paddr            ;   //  address of APB slave and register map
         bit                  pwrite           ;   //  HIGH is write, LOW is read
         bit                  psel             ;   //  select slave interface
         bit                  penable          ;   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    rand bit   [7 : 0]        pwdata           ;   //  data write
         bit   [7 : 0]        prdata           ;   //  data read
         bit                  pready           ;   //  ready to receive data
         bit                  sda              ;   //  sda line
         bit                  scl              ;   //  scl line

    //  Constraint
 
endclass 

`endif