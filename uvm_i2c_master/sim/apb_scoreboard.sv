`ifndef  APB_SCOREBOARD
`define APB_SCOREBOARD

class apb_socreboard extends uvm_scoreboard;

    `uvm_component_utils(apb_socreboard)
    uvm_analysis_imp#(apb_transaction, apb_socreboard)  scoreboard_port ;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "Build Phase", UVM_MEDIUM)
        scoreboard_port = new("scoreboard_port", this);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase (uvm_phase phase)
        //  ------  Comparision logic here  ----------
    endtask

endclass

`endif 
