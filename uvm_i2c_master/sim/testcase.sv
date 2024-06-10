`ifndef TESTCASE
`define TESTCASE

`include "apb_env.sv"
`include "i2c_reg_block.sv"

class testcase extends uvm_test;

    `uvm_component_utils(testcase)

    //virtual intf    intf ;
    apb_env env;
    `SEQ seq    ;

    function new (string name = "testcase", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);

        super.build_phase(phase);
        `uvm_info(get_name(), "\n--------------------------------------------------------------------------------------------------------", UVM_MEDIUM)
        `uvm_info(get_name(), "TEST BUILD PHASE", UVM_MEDIUM)

        env = apb_env::type_id::create("env", this);
        seq = `SEQ::type_id::create("seq", this);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), "Connect Phase!", UVM_MEDIUM)
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Run Phase!", UVM_MEDIUM)

        phase.raise_objection(this);
        seq.intf = env.agnt.drv.intf ;
        seq.reg_model = env.reg_model   ;
        seq.start(env.agnt.seqr);
        phase.drop_objection(this);
    endtask

endclass

`endif