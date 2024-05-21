

class reg_to_apb_adapter extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter)

  function new(string name="reg_to_apb_adapter");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transaction transfer;
    transfer = apb_transaction::type_id::create("transfer");
    transfer.paddr = rw.addr;
    transfer.pwdata = rw.data;
    transfer.pwrite = (rw.kind == UVM_WRITE) ? WRITE : READ ;
    if (rw.kind == UVM_WRITE)
      `uvm_info(get_name(), $sformatf("Write %0d to register %0d", transfer.pwdata, transfer.paddr), UVM_LOW)
    return (transfer);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transaction transfer;
    if (!$cast(transfer, bus_item)) begin                                                     // The syntax for $cast is: $cast(target, source);
      `uvm_fatal("NOT_REG_TYPE",
       "Provided bus_item is not of the correct type. Expecting apb_transfer")
       return;
    end
    rw.kind =  (transfer.pwrite == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer.paddr;
    rw.data = transfer.pwdata;
    //rw.byte_en = 'h0;   // Set this to -1 or DO NOT SET IT AT ALL - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter
