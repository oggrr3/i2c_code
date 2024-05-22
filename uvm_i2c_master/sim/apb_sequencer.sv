`ifndef APB_SEQUENCER_SV
`define APB_SEQUENCER_SV

class apb_sequencer extends uvm_sequencer#(apb_transaction);
  
  `uvm_component_utils(apb_sequencer)
  
  function new ( string name = "apb_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQUENCER CLASS", "Build Phase!", UVM_MEDIUM)
  endfunction

  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SEQUENCER CLASS", "Connect Phase!", UVM_MEDIUM)
  endfunction
  
endclass

`endif 