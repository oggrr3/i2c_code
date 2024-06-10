`ifndef APB_ENV
`define APB_ENV

`include "apb_agent.sv"

class apb_env extends uvm_env;

    `uvm_component_utils(apb_env)

    virtual intf intf   ;
    apb_agent   agnt    ;
    apb_socreboard  scb ;
    apb_subscriber  subscriber;

    i2c_reg_block   reg_model   ;
    uvm_reg_predictor #(apb_transaction) predictor  ;
    reg_to_apb_adapter  adapter     ;

    logic   [7:0]   data    ;
    //integer         i   = 0 ;
    reg start_done;
    reg stop_done;

    function new(string name = "env", uvm_component parent);
        super.new(name, parent); 
    endfunction

    //  Build Phase
    function void build_phase (uvm_phase phase);

        super.build_phase(phase);
        `uvm_info("APB_ENV CLASS", "Build Phase", UVM_MEDIUM)
        if(!uvm_config_db#(virtual intf)::get(this,"","intf",intf)) begin
            `uvm_error("Build_phase","driver virtual interface failed")
        end

        agnt = apb_agent::type_id::create("agnt", this);
        scb  = apb_socreboard::type_id::create("scb", this);
        subscriber = apb_subscriber::type_id::create("subscriber", this);

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
        agnt.mon.monitor_port.connect(scb.scoreboard_port);

        //  set default reg map
        reg_model.default_map.set_base_addr(0);
        reg_model.default_map.set_sequencer((agnt.seqr), (adapter));

        //  predictor
        predictor.map = reg_model.default_map;
        predictor.adapter = adapter;

        //  connect predictor with monitor
        agnt.mon.monitor_port.connect(predictor.bus_in);
        agnt.mon.monitor_port.connect(subscriber.apb_subscriber_port);
        
        uvm_config_db #(i2c_reg_block)::set (null, "", "reg_model", reg_model);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            
            // @(posedge intf.scl);
            // data[7-i] = intf.sda;
            // if (i == 7) begin
            //     this.scb.data_sda.push_back(data);
            //     `uvm_info(get_name(), $sformatf("Data from Slvae %h", data ), UVM_LOW)
            //     i = 0;
            // end
            // i = i + 1   ;
            // @(posedge intf.scl);
            // this.agnt.drv.Get1Byte_From_Sda(data);
            // this.scb.data_sda.push_back(data);
            // `uvm_info(get_name(), $sformatf("Data from Slvae %h", data ), UVM_LOW)
            // this.agnt.drv.Check_ACK();

            wait(intf.data_slave_read_valid);

            this.scb.data_sda.push_back(intf.data_slave_read);
            `uvm_info(get_name(), $sformatf("Data from Slvae %h", intf.data_slave_read), UVM_LOW)

            wait(~intf.data_slave_read_valid);
         end
        
    endtask //run_phases

endclass

`endif //   APB_ENV 