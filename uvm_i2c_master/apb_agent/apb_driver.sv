class apb_driver extends uvm_driver#(apb_transaction);
  
  `uvm_component_utils(apb_driver)
  
  virtual intf vif;
  apb_transaction item;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_MEDIUM)
    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif)) begin
      `uvm_error("build_phase","driver virtual interface failed")
    end
  endfunction

  function void connect_phase(uvm_phase);
    super.connect_phase(phase);
    `uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_MEDIUM)
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    `uvm_info(get_name(), "DRIVER RUN PHASE", UVM_MEDIUM)

    intf.pwdata <= 0;
    intf.pwrite <= 0;
    intf.paddr <= 0;
    intf.psel <= 0;
    intf.penable <= 0;
    reset();
    forever begin
      logic [7:0] prdata;
      item = apb_transaction::type_id::create("item"); 
      seq_item_port.get_next_item(item);
      if (item.pwrite == 1)
        write(item.paddr, item.pwdata);
      else
      begin
        read(item.paddr, prdata);
        item.prdata = prdata;
      end
      //Handshake DONE back to sequencer
      seq_item_port.item_done();
    end
  endtask
  
    task apb_reset();   // apb reset method
        intf.preset_n   <=  0                           ;
        repeat(2)   @(negedge   intf.apb_clk)           ;
        intf.preset_n   <=  1                           ;
    endtask 

    task Apb_Write(bit [7:0] addr, bit [7:0] data);
        @(posedge   intf.apb_clk)                       ;
        intf.paddr      <=  addr                        ;
        intf.pwrite     <=  1                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        intf.pwdata     <=  data                        ;
        @(posedge   intf.apb_clk);
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk)                       ;
        //$display("APB write data = %h into register = %h  at time = %t", data, addr, $time);
        //cov.sample()                                    ;   //  sample covergroup
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        @(negedge intf.apb_clk)                         ;
    endtask

    task Apb_Read (bit [7:0] addr);
    
        @(posedge   intf.apb_clk)                       ;
        intf.paddr      <=  addr                        ;
        intf.pwrite     <=  0                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        @(posedge   intf.apb_clk)                       ;
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk)                       ;
        prdata          <=  intf.prdata                 ;
        //$display("APB read  data = %h from register = %h  at time = %t", intf.prdata, addr, $time);
        //cov.sample()                                    ;   //  sample covergroup
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        @(negedge intf.apb_clk)                         ;
    endtask

endclass