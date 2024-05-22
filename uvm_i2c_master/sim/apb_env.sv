`ifndef APB_ENV
`define APB_ENV

`include "apb_agent.sv"

class apb_env extends uvm_env;

    `uvm_component_utils(apb_env)

    apb_agent   agnt    ;

    i2c_reg_block   reg_model   ;
    uvm_reg_predictor #(apb_transaction) predictor  ;
    reg_to_apb_adapter  adapter     ;

    function new(string name = "env", uvm_component parent);
        super.new(name, parent); 
    endfunction

    //  Build Phase
    function void build_phase (uvm_phase phase);

        super.build_phase(phase);
        `uvm_info("APB_ENV CLASS", "Build Phase", UVM_MEDIUM)

        agnt = apb_agent::type_id::create("agnt", this);

        reg_model = i2c_reg_block::type_id::create("reg_model", this);
        predictor = uvm_reg_predictor #(apb_transaction)::type_id::create("predictor", this);
        adapter = reg_to_apb_adapter::type_id::create("adapter", this);

        reg_model.build();
        reg_model.lock_model();

    endfunction

    //  Connect Phase
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("APB_ENV CLASS", "Build Phase", UVM_MEDIUM)

        //  connect monitor to scoreboard
        
        //  set default reg map
        reg_model.default_map.set_base_addr(0);
        reg_model.default_map.set_sequencer((agnt.seqr), (adapter));

        //  predictor
        predictor.map = reg_model.default_map;
        predictor.adapter = adapter;

        //  connect predictor with monitor
        agnt.mon.monitor_port.connect(predictor.bus_in);
        uvm_config_db #(i2c_reg_block)::set (null, "", "reg_model", reg_model);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask //run_phases

endclass

`endif //   APB_ENV 