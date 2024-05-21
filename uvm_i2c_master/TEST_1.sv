class TEST_1 extends apb_sequence;

    `uvm_object_utils(TEST_1)

    function new(string name = "TEST_1");
        super.new(name);
    endfunction 

    task body();

        `uvm_info(get_name(), "TEST1: APB write to reg and then read out", UVM_MEDIUM)

        //  write value
        this.reg_block.transmit(status, 8'h34);
        this.reg_block.slave_address(status, 8'h20);
        this.reg_block.command(status, 8'h90);
        this.reg_block.prescale(status, 8'h06);

        //  read value
        this.reg_block.transmit.read(status, value);
        `uvm_info(get_name(), $sformat("READ : data %0h", value), UVM_MEDIUM)

        this.reg_block.receive.read(status, value);
        `uvm_info(get_name(), $sformat("READ : data %0h", value), UVM_MEDIUM)

        this.reg_block.status.read(status, value);
        `uvm_info(get_name(), $sformat("READ : data %0h", value), UVM_MEDIUM)

        this.reg_block.slave_address.read(status, value);
        `uvm_info(get_name(), $sformat("READ : data %0h", value), UVM_MEDIUM)

        this.reg_block.command.read(status, value);
        `uvm_info(get_name(), $sformat("READ : data %0h", value), UVM_MEDIUM)

        this.reg_block.prescale.read(status, value);
        `uvm_info(get_name(), $sformat("READ : data %0h", value), UVM_MEDIUM)

    endtask 
    
endclass 