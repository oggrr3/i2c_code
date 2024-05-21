
class i2c_reg_block extends uvm_reg_block;

    `uvm_object_utils(i2c_reg_block)

    //  instances for all registers here
    //  --------------------------------
    rand    transmit_reg        transmit        ;
    rand    receive_reg         receive         ;
    rand    status_reg          status          ;
    rand    slave_address_reg   slave_address   ;
    rand    command_reg         command         ;
    rand    prescale_reg        prescale        ;
    //  --------------------------------

    function new(string name = "i2c_reg_block");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    //  Creating, building and configuring the register instances
    transmit        =   transmit_reg::type_id::create("transmit") ;
    transmit.build();
    transmit.configure(this);

    receive         =   receive_reg::type_id::create("receive")  ;
    receive.build();
    receive.configure(this);

    status          =   status_reg::type_id::create("status")   ;
    status.build();
    status.configure(this);

    slave_address   =   slave_address_reg::type_id::create("slave_address") ;
    slave_address.build();
    slave_address.configure(this);

    command         =   command_reg::type_id::create("command") ;
    command.build();
    command.configure(this);

    prescale        =   prescale_reg::type_id::create("prescale") ;
    prescale.build();
    prescale.configure(this);

    //  Creating the memory map
    // instance, base_address, size in byte(i.e 1*8 = 8), endian
	// UVM_LITTLE_ENDIAN -> Least-significant bytes first in consecutive addresses
    default_map = create_map("default_map",0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(transmit, 'h0, "RW");
    default_map.add_reg(receive, 'h1, "RO");
    default_map.add_reg(status, 'h2, "RO");
    default_map.add_reg(slave_address, 'h3, "RW");
    default_map.add_reg(command, 'h4, "RW");
    default_map.add_reg(prescale, 'h5, "RW");

    /*
    // mandatory to lock the model
	// Lock a model and build the address map.(it will build the map)
    // Once locked, no further structural changes, such as adding registers or memories, can be made.
	// It is not possible to unlock a model.
    */
    lock_model();

endclass //i2c_reg_block extends uvm_reg_block
