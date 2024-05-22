`ifndef APB_AGENT
`define APB_AGENT

class apb_agent extends uvm_agent;

   //Agent will have the sequencer, driver and monitor components for the APB interface
   apb_sequencer seqr;
   apb_driver drv;
   apb_monitor mon;

   virtual intf  intf;

   `uvm_component_utils_begin(apb_agent)
      `uvm_field_object(seqr, UVM_ALL_ON)
      `uvm_field_object(drv, UVM_ALL_ON)
      `uvm_field_object(mon, UVM_ALL_ON)
   `uvm_component_utils_end
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   //Build phase of agent - construct sequencer, driver and monitor
   //get handle to virtual interface from env (parent) config_db
   //and pass handle down to srq/driver/monitor
   virtual function void build_phase(uvm_phase phase);
      seqr = apb_sequencer::type_id::create("seqr", this);
      drv = apb_driver::type_id::create("drv", this);
      mon = apb_monitor::type_id::create("mon", this);
      
     if (!uvm_config_db#(virtual intf)::get(this, "", "intf", intf)) begin
       `uvm_fatal("build phase", "No virtual interface specified for this agent instance")
      end
     
   endfunction

   //Connect - driver and sequencer port to export
   virtual function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
     uvm_report_info("APB_AGENT", "connect_phase, Connected driver to sequencer");
   endfunction
endclass

`endif 