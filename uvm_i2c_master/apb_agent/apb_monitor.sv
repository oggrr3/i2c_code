class apb_monitor extends uvm_monitor;

  virtual intf vif;

  //Analysis port -parameterized to apb_rw transaction
  ///Monitor writes transaction objects to this port once detected on interface
  uvm_analysis_port#(apb_transaction) monitor_port;

  `uvm_component_utils(apb_monitor)

   function new(string name, uvm_component parent);
     super.new(name, parent);
     monitor_port = new("monitor_port", this);
   endfunction

   //Build Phase - Get handle to virtual if from agent/config_db
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
       `uvm_error("build_phase", "No virtual interface specified for this monitor instance")
       end
   endfunction

    // Connect Phase
    function  void connect_phase(uvm_phase phase);
      super.connect_phase(phase)  ;
      `uvm_info("APB_MONITOR_CLASS", "Connect Phase!", UVM_MEDIUM)
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
       @(posedge intf.apb_clk);
       if (intf.psel & intf.penable & intf.preset_n)
        begin
          item = apb_transaction::type_id::create("item");
          item.paddr = intf.paddr;
          item.pwdata = intf.pwdata;
          item.prdata = intf.prdata;
          item.pwrite = intf.pwrite;
          if (item.pwrite)
            `uvm_info("APB_MONITOR_CLASS", $sformatf("WRITE item addr %0h data %0h", item.paddr, item.pwdata), UVM_MEDIUM)
          monitor_port.write(item);
          // `uvm_info("MONITOR_CLASS", "write transaction!", UVM_MEDIUM)
        end
      end
   endtask

endclass
