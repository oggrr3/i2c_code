`ifndef I2C_REG_BLOCK 
`define I2C_REG_BLOCK


class transmit_reg extends uvm_reg;

    `uvm_object_utils(transmit_reg)

    rand    uvm_reg_field   data    ;

    function new(string name = "transmit_reg");
        super.new(name, 8, UVM_NO_COVERAGE) ;
    endfunction

    // build method for fields creation and configuration method for configuration information for register
    virtual function void build();

        data = uvm_reg_field::type_id::create("data");

        data.configure(
            .parent(this), 			        // current class	
        	.size(8), 				        // width
			.lsb_pos(0), 			        // lsb postion
			.access("RW"), 			        // type of an access	
			.volatile(0), 			        // volatile -> 1 means field can't change between consecutive access		
			.reset(0), 				        // reset value(power on reset value for field)
			.has_reset(1), 			        // field support reset
			.is_rand(1),			        // field can be randomize
			.individually_accessible(1)	    // field is individually accessible 
						                    // 9 arguments 
        );
    endfunction

endclass //transmit_reg extends uvm_reg

class receive_reg extends uvm_reg;

    `uvm_object_utils(receive_reg)

    rand    uvm_reg_field   data    ;

    function new(string name = "receive_reg");
        super.new(name, 8, UVM_NO_COVERAGE) ;
    endfunction

    // build method for fields creation and configuration method for configuration information for register
    virtual function void build();

        data = uvm_reg_field::type_id::create("data");

        data.configure(
            .parent(this), 			        // current class	
        	.size(8), 				        // width
			.lsb_pos(0), 			        // lsb postion
			.access("RO"), 			        // type of an access	
			.volatile(0), 			        // volatile -> 1 means field can't change between consecutive access		
			.reset(0), 				        // reset value(power on reset value for field)
			.has_reset(1), 			        // field support reset
			.is_rand(0),			        // field can be randomize
			.individually_accessible(1)	    // field is individually accessible 
						                    // 9 arguments 
        );
    endfunction
    
endclass 

class status_reg extends uvm_reg;

    `uvm_object_utils(status_reg)

    rand    uvm_reg_field   data    ;

    function new(string name = "status_reg");
        super.new(name, 8, UVM_NO_COVERAGE) ;
    endfunction

    // build method for fields creation and configuration method for configuration information for register
    virtual function void build();

        data = uvm_reg_field::type_id::create("data");

        data.configure(
            .parent(this), 			        // current class	
        	.size(8), 				        // width
			.lsb_pos(0), 			        // lsb postion
			.access("RO"), 			        // type of an access	
			.volatile(0), 			        // volatile -> 1 means field can't change between consecutive access		
			.reset(0), 				        // reset value(power on reset value for field)
			.has_reset(1), 			        // field support reset
			.is_rand(0),			        // field can be randomize
			.individually_accessible(1)	    // field is individually accessible 
						                    // 9 arguments 
        );
    endfunction
    
endclass 

class slave_address_reg extends uvm_reg;

    `uvm_object_utils(slave_address_reg)

    rand    uvm_reg_field   slave_addr          ;
    rand    uvm_reg_field   read_write_bit      ;

    function new(string name = "slave_address_reg");
        super.new(name, 8, UVM_NO_COVERAGE) ;
    endfunction

    // build method for fields creation and configuration method for configuration information for register
    virtual function void build();

        slave_addr = uvm_reg_field::type_id::create("slave_addr");

        slave_addr.configure(
            .parent(this), 			        // current class	
        	.size(7), 				        // width
			.lsb_pos(1), 			        // lsb postion
			.access("RW"), 			        // type of an access	
			.volatile(0), 			        // volatile -> 1 means field can't change between consecutive access		
			.reset(0), 				        // reset value(power on reset value for field)
			.has_reset(1), 			        // field support reset
			.is_rand(0),			        // field can be randomize
			.individually_accessible(1)	    // field is individually accessible 
						                    // 9 arguments 
        );

        read_write_bit = uvm_reg_field::type_id::create("read_write_bit");

        read_write_bit.configure(
            .parent(this), 			        // current class	
        	.size(1), 				        // width
			.lsb_pos(0), 			        // lsb postion
			.access("RW"), 			        // type of an access	
			.volatile(0), 			        // volatile -> 1 means field can't change between consecutive access		
			.reset(0), 				        // reset value(power on reset value for field)
			.has_reset(1), 			        // field support reset
			.is_rand(0),			        // field can be randomize
			.individually_accessible(1)	    // field is individually accessible 
						                    // 9 arguments 
        );
    endfunction
    
endclass 

class command_reg extends uvm_reg;

    `uvm_object_utils(command_reg)

    rand    uvm_reg_field   cmd    ;

    function new(string name = "command_reg");
        super.new(name, 8, UVM_NO_COVERAGE) ;
    endfunction

    // build method for fields creation and configuration method for configuration information for register
    virtual function void build();

        cmd = uvm_reg_field::type_id::create("cmd");

        cmd.configure(
            .parent(this), 			        // current class	
        	.size(8), 				        // width
			.lsb_pos(0), 			        // lsb postion
			.access("RW"), 			        // type of an access	
			.volatile(0), 			        // volatile -> 1 means field can't change between consecutive access		
			.reset(0), 				        // reset value(power on reset value for field)
			.has_reset(1), 			        // field support reset
			.is_rand(0),			        // field can be randomize
			.individually_accessible(1)	    // field is individually accessible 
						                    // 9 arguments 
        );
    endfunction

endclass 

class prescale_reg extends uvm_reg;

    `uvm_object_utils(prescale_reg)

    rand    uvm_reg_field   data    ;

    function new(string name = "prescale_reg");
        super.new(name, 8, UVM_NO_COVERAGE) ;
    endfunction

    // build method for fields creation and configuration method for configuration information for register
    virtual function void build();

        data = uvm_reg_field::type_id::create("data");

        data.configure(
            .parent(this), 			        // current class	
        	.size(8), 				        // width
			.lsb_pos(0), 			        // lsb postion
			.access("RW"), 			        // type of an access	
			.volatile(0), 			        // volatile -> 1 means field can't change between consecutive access		
			.reset(0), 				        // reset value(power on reset value for field)
			.has_reset(1), 			        // field support reset
			.is_rand(0),			        // field can be randomize
			.individually_accessible(1)	    // field is individually accessible 
						                    // 9 arguments 
        );
    endfunction

endclass 

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

    function void build ();
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
    default_map.add_reg(transmit, 'h4, "RW");
    default_map.add_reg(receive, 'h5, "RO");
    default_map.add_reg(status, 'h3, "RO");
    default_map.add_reg(slave_address, 'h2, "RW");
    default_map.add_reg(command, 'h6, "RW");
    default_map.add_reg(prescale, 'h1, "RW");

    /*
    // mandatory to lock the model
	// Lock a model and build the address map.(it will build the map)
    // Once locked, no further structural changes, such as adding registers or memories, can be made.
	// It is not possible to unlock a model.
    */
    lock_model();
    endfunction

endclass //i2c_reg_block extends uvm_reg_block

`endif 