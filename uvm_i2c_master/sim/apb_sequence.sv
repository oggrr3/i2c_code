`ifndef APB_SEQUENCE
`define APB_SEQUENCE

class apb_sequence extends uvm_sequence#(apb_transaction);
  
  `uvm_object_utils(apb_sequence)
  
  virtual intf intf ;
  i2c_reg_block   reg_model ;
  //rand bit [7:0]  data      ;
  uvm_status_e    status    ;
  uvm_reg_data_t  value     ;

  bit start_done = 0  ;
  bit stop_done = 0 ;
  bit [7:0] data  ;

  function new (string name = "apb_sequence");
    super.new(name);
  endfunction
  
  virtual task reset_core();
    this.reg_model.command.write(status, 8'h00);
  endtask

    task apb_reset();   // apb reset method
        intf.preset_n   <=  0                           ;
        repeat(2)   @(negedge   intf.apb_clk)           ;
        intf.preset_n   <=  1                           ;
    endtask 

    task Check_Start_condition (output bit start_done);
        bit detect_start = 0    ;
        while (!detect_start) begin
            @(negedge   intf.sda);
            if(intf.scl) begin     
                $display("\tSTART condition found at %t", $time); 
                start_done      =   1   ;
                detect_start    =   1   ;
            end
        end
    endtask

    task Check_Stop_condition (output bit stop_done);
        bit detect_stop     =   0   ;
        while (!detect_stop) begin
            @(posedge   intf.sda);
            if(intf.scl) begin     
                $display("\tSTOP condition found at %t", $time); 
                stop_done   =   1   ;
                detect_stop =   1   ;
            end
        end
    endtask

    task Get1Byte_From_Sda (output bit [7:0] data );

        bit [7:0] temp  =   0;
        for (int i = 0; i < 8 ; i = i + 1) begin
            @(posedge intf.scl) ;
            temp[7-i]     =    intf.sda   ;
        end

        data   =   temp            ;
        $display("--------Deteced 1 byte data = %h from SDA at time = %0t--------", data, $time);
    endtask 

    task Check_ACK();
        @(posedge intf.scl) ;
        if (!intf.sda)
            $display("---Detected  ACK at time = %0t", $time)    ;
        else    
            $display("---Detected NACK at time = %0t", $time)    ;
    endtask
endclass

class TEST1 extends apb_sequence;

  `uvm_object_utils(TEST1)

  function new(string name = "TEST1");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST1: APB write to reg and then read out -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h34);
    this.reg_model.command.write(status, 8'h90);
      
    //  read value
    this.reg_model.transmit.read(status, value);
    this.reg_model.receive.read(status, value);
    this.reg_model.status.read(status, value);
    this.reg_model.slave_address.read(status, value);
    this.reg_model.command.read(status, value);
    this.reg_model.prescale.read(status, value);
  endtask 
    
endclass 


class TEST2 extends apb_sequence;

  `uvm_object_utils(TEST2)

  function new(string name = "TEST2");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST2: APB reset and read out -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h21);
    this.reg_model.transmit.write(status, 8'hd4);
    this.reg_model.command.write(status, 8'h90);
    
    //  reset APB 
    this.apb_reset();

    //  read value
    this.reg_model.transmit.read(status, value);
    this.reg_model.receive.read(status, value);
    this.reg_model.status.read(status, value);
    this.reg_model.slave_address.read(status, value);
    this.reg_model.command.read(status, value);
    this.reg_model.prescale.read(status, value);
  endtask 
    
endclass 

`endif 