`ifndef APB_ENV
`define APB_ENV

class apb_env extends uvm_env;

    `uvm_component_utils(env)

    apb_agent   agnt    ;

    i2c_reg_block   reg_model   ;
    uvm_reg_predictor #(apb_transaction) predictor  ;
    reg_to_apb_adapter  adapter     ;

    function new(string name = "env", uvm_component parent);
        super.new(name, parent); 
    endfunction

    //  Build Phase
    function void build_phase (uvm_phase phase)

        super.build_phase(phase);
        `uvm_info("APB_ENV CLASS", "Build Phase", UVM_MEDIUM)

        agnt = apb_agent::type_id::create("agnt", this);

        reg_model = i2c_reg_block::type_id::create("reg_model", this);
        predictor = uvm_reg_predictor #(apb_transaction)::type_id::create("predictor", this);
        adapter = reg_to_apb_adapter::type_id::create("adapter", this);

        reg_model.build();
        reg_model.lock_model();

    endfunction

endclass

`endif //   APB_ENV 