`ifdef PACKET 
`define PACKET

class packet;
         bit                  preset_n         ;   //  reset signal is active-LOW
    rand bit   [7 : 0]        paddr            ;   //  address of APB slave and register map
    rand bit                  pwrite           ;   //  HIGH is write, LOW is read
    rand bit                  psel             ;   //  select slave interface
    rand bit                  penable          ;   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    rand bit   [7 : 0]        pwdata           ;   //  data write
         bit   [7 : 0]        prdata           ;   //  data read
         bit                  pready           ;   //  ready to receive data
         bit                  sda              ;   //  sda line
         bit                  scl              ;   //  scl line

    //  Constraint
    constraint  paddr_constraint {
        if  (pwrite)
            paddr   inside  {1, 2, 4, 6}    ;
        else
            paddr   <   7                   ;
    }

    
endclass 

`endif
