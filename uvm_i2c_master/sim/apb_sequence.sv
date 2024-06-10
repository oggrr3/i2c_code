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
    this.reg_model.command.write(status, 8'h80);
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
            else
                start_done = 0 ;
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
            else
                stop_done = 0 ;
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

    //  penable = 0 -> run code coverage
        @(posedge   intf.apb_clk)                       ;
        intf.paddr      <=  8'h00                       ;
        intf.pwrite     <=  1                           ;
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        intf.pwdata     <=  8'h00                       ;
        @(posedge   intf.apb_clk);
        intf.penable    <=  1                           ;
        intf.psel       <=  0                           ;

        //  run code coverage paddr = 3
        @(posedge   intf.apb_clk)                       ;
        intf.paddr      <=  8'h05                       ;
        intf.pwrite     <=  1                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        intf.pwdata     <=  8'h00                       ;
        @(posedge   intf.apb_clk);
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk);
        intf.paddr      <=  8'h03                       ;
        intf.pwrite     <=  1                           ;
        @(posedge   intf.apb_clk);
        `uvm_delay(50)

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
    `uvm_delay(50)
  endtask 
    
endclass 


class TEST3 extends apb_sequence;

  `uvm_object_utils(TEST3)

  function new(string name = "TEST3");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST3 : I2C read 1 byte -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    this.reg_model.transmit.write(status, 8'h06);
    this.reg_model.command.write(status, 8'h90);
    
    //  run i2c
    this.Check_Stop_condition(stop_done);
    stop_done = 0;

    //  config to read
    this.reg_model.slave_address.write(status, 8'h21);
    this.reg_model.command.write(status, 8'h90);

    this.Check_Start_condition(start_done);
    repeat(2) begin
      this.Get1Byte_From_Sda(data);
      this.Check_ACK();
    end

    //  read value
    this.reg_model.receive.read(status, value);

  endtask 
    
endclass 


class TEST4 extends apb_sequence;

  `uvm_object_utils(TEST4)

  function new(string name = "TEST4");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST4 : I2C write 1 byte -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h5c);
    this.reg_model.command.write(status, 8'h90);
    
    //  run i2c
    this.Check_Start_condition(start_done);
    repeat(2) begin
      this.Get1Byte_From_Sda(data);
      this.Check_ACK();
    end
    this.Check_Stop_condition(stop_done);

  endtask 
    
endclass 


class TEST5 extends apb_sequence;

  `uvm_object_utils(TEST5)

  function new(string name = "TEST5");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST5 : I2C read n byte > FIFO Size -------------------------------\n", UVM_MEDIUM)
  
    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(8) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90);
    
    //  run i2c
    this.Check_Stop_condition(stop_done);
    stop_done = 0;

    //  config to read
    this.reg_model.slave_address.write(status, 8'h21);
    this.reg_model.command.write(status, 8'h90);

    this.Check_Start_condition(start_done);

    fork
      this.Check_Stop_condition(stop_done)    ;
      while (!stop_done) begin
        this.Get1Byte_From_Sda(data);
        this.Check_ACK();
      end
    join_any

    //  read value
    repeat(20) begin
      this.reg_model.receive.read(status, value);
    end
    
    `uvm_delay(500)
  endtask 
    
endclass


class TEST6 extends apb_sequence;

  `uvm_object_utils(TEST6)

  function new(string name = "TEST6");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST6 : I2C write n byte > FIFO Size -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(20) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90);
    
    stop_done = 0;
    //  run i2c
    fork
      this.Check_Stop_condition(stop_done)    ;
      while (!stop_done) begin
        this.Get1Byte_From_Sda(data);
        this.Check_ACK();
      end
    join_any

    `uvm_delay(500)
    //$finish;
  endtask 
    
endclass 


class TEST7 extends apb_sequence;

  `uvm_object_utils(TEST7)

  function new(string name = "TEST7");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST7 : I2C write address wrong -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h30);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(2) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90);
    
    stop_done = 0;
    //  run i2c
    fork
      this.Check_Stop_condition(stop_done)    ;
      while (!stop_done) begin
        this.Get1Byte_From_Sda(data);
        this.Check_ACK();
      end
    join_any

    `uvm_delay(500)
    //$finish;
  endtask 
    
endclass 


class TEST8 extends apb_sequence;

  `uvm_object_utils(TEST8)

  function new(string name = "TEST8");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST8 : W -> SR -> R -> SR -> W -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(6) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90); 

    //  run i2c
    repeat(30) begin
      @(posedge this.intf.scl);
    end
    this.reg_model.command.write(status, 8'h98);  // enable with repeat start

    //  config to read
    this.reg_model.slave_address.write(status, 8'h21);
    this.reg_model.command.write(status, 8'h98);            // enable with repeat start

    //  run i2c
    repeat(30) begin
      @(posedge this.intf.scl);
    end

    //  config to write
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(3) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h98);  // enable with repeat start

    `uvm_delay(4000)
    //$finish;
  endtask 
    
endclass 


class TEST9 extends apb_sequence;

  `uvm_object_utils(TEST9)

  function new(string name = "TEST9");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST9 : W -> RST -> R -> RST -> W -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(4) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90);
    
    //  run i2c
    this.Check_Start_condition(start_done);
    repeat (6) begin
      this.Get1Byte_From_Sda(data);
      this.Check_ACK();
    end
    
    //  reset_n
    this.reset_core();
    `uvm_delay(100)

    //  i2c read
    this.reg_model.slave_address.write(status, 8'h21);
    this.reg_model.command.write(status, 8'h90);

    //  run i2c
    this.Check_Start_condition(start_done);
    repeat (2) begin
      this.Get1Byte_From_Sda(data);
      this.Check_ACK();
    end
    
    //  reset_n
    this.reset_core();
    `uvm_delay(100)
    
    //  write value
    this.reg_model.slave_address.write(status, 8'h20);
    //this.reg_model.transmit.write(status, 8'h00);
    this.reg_model.transmit.write(status, 8'h00);
    this.reg_model.command.write(status, 8'h90);
    
    //  run i2c
    this.Check_Start_condition(start_done);
    repeat (2) begin
      this.Get1Byte_From_Sda(data);
      this.Check_ACK();
    end

    `uvm_delay(500)
    //$finish;
  endtask 
    
endclass 



class TEST10 extends apb_sequence;

  `uvm_object_utils(TEST10)

  function new(string name = "TEST10");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST10 : 3th-Byte slave send NACK -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(4) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90);
   
    //  run i2c until 3th-Byte and then stop
    fork
      this.Check_Stop_condition(stop_done)    ;
      while (!stop_done) begin
        this.Get1Byte_From_Sda(data);
        this.Check_ACK();
      end
    join_any

    `uvm_delay(500)
    //$finish;
  endtask 
    
endclass 


class TEST11 extends apb_sequence;

  `uvm_object_utils(TEST11)

  function new(string name = "TEST11");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST11 : R -> RST -> R -> SR -> R -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(6) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90);
    
    //  run i2c
    fork
      this.Check_Stop_condition(stop_done)    ;
      while (!stop_done) begin
        this.Get1Byte_From_Sda(data);
        this.Check_ACK();
      end
    join_any

    //  i2c read
    this.reg_model.slave_address.write(status, 8'h21);
    this.reg_model.command.write(status, 8'h90);

    //  run i2c
    this.Check_Start_condition(start_done);
    repeat(20) begin
      @(posedge this.intf.scl);
    end
    
    //  reset_n
    this.reset_core();
    `uvm_delay(100)
    
    //  i2c read
    this.reg_model.command.write(status, 8'h90);
    repeat(20) begin
      @(posedge this.intf.scl);
    end
    this.reg_model.command.write(status, 8'h98);
    this.Check_Start_condition(start_done);             //  Run until repeat start
    this.reg_model.command.write(status, 8'h90);
    this.Check_Stop_condition(stop_done);               //  Run until RX-FIFO full -> Stop

    `uvm_delay(500)
    //$finish;
  endtask 
    
endclass 


class TEST12 extends apb_sequence;

  `uvm_object_utils(TEST12)

  function new(string name = "TEST12");
    super.new(name);
  endfunction 

  task body();

    `uvm_info(get_name(), "\n\n------------------------ TEST12 : W -> RST -> W -> SR -> W -------------------------------\n", UVM_MEDIUM)

    //  write value
    this.reg_model.prescale.write(status, 8'h06);
    this.reg_model.slave_address.write(status, 8'h20);
    this.reg_model.transmit.write(status, 8'h00);
    repeat(4) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90);
    
    repeat(20) begin
      @(posedge this.intf.scl);
    end
    //  reset_n
    this.reset_core();
    `uvm_delay(100)
    
    //  i2c write
    repeat(4) begin
      this.reg_model.transmit.write(status, $urandom_range(0, 255));
    end
    this.reg_model.command.write(status, 8'h90);
    repeat(20) begin
      @(posedge this.intf.scl);
    end
    this.reg_model.command.write(status, 8'h98);
    this.Check_Start_condition(start_done);             //  Run until repeat start
    this.reg_model.command.write(status, 8'h90);
    this.Check_Stop_condition(stop_done);               //  Run until RX-FIFO full -> Stop

    `uvm_delay(500)
    //$finish;
  endtask 
    
endclass 


`endif 