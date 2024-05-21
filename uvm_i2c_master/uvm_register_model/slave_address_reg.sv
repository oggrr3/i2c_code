`include "uvm_macros.svh"                                                       // will give an access to uvm macros
import uvm_pkg::*;                                                              // will give an access to uvm pkg(to all uvm classes)

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