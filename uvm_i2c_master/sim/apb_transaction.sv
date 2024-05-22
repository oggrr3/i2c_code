`ifndef APB_TRANSACTION
`define APB_TRANSACTION

class apb_transaction extends uvm_sequence_item;
  
  `uvm_object_utils(apb_transaction)
  
  //typedef for READ/Write transaction type
  //typedef enum {READ, WRITE} kind_e;
  rand bit   [7:0] paddr;      //Address
  rand bit  pwrite;       //command type
         bit                  preset_n         ;   //  reset signal is active-LOW
         bit                  psel             ;   //  select slave interface
         bit                  penable          ;   //  Enable. PENABLE indicates the second and subsequent cycles of an APB transfer.
    rand bit   [7 : 0]        pwdata           ;   //  data write
         bit   [7 : 0]        prdata           ;   //  data read
         bit                  pready           ;   //  ready to receive data
  
  //constraint c1{addr[31:0]>=32'd0; addr[31:0] <32'd256;};
  //constraint c2{data[31:0]>=32'd0; data[31:0] <32'd256;};
  
  function new (string name = "apb_transaction");
    super.new(name);
  endfunction
  
  // function string convert2string();
  //   return $psprintf("pwrite=%s paddr=%0h data=%0h",pwrite,addr,data);
  // endfunction
  
endclass

`endif 