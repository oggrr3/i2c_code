class apb_sequence extends uvm_sequence#(apb_transaction);
  
  `uvm_object_utils(apb_sequence)
  
  i2c_reg_block   reg_block ;
  rand bit [7:0]  data      ;
  uvm_status_e    status    ;
  uvm_reg_data_t  value     ;

  function new (string name = "apb_sequence");
    super.new(name);
  endfunction
  
  virtual task reset_core();
    this.reg_block.command.write(status, 8'h00);
  endtask

endclass
