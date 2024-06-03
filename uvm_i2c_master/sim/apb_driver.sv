`ifndef APB_DRIVER 
`define APB_DRIVER

class apb_driver extends uvm_driver#(apb_transaction);
  
  `uvm_component_utils(apb_driver)
  
  virtual intf intf;
  apb_transaction item;
  
  reg start_done;
  reg stop_done;
  logic [7:0] data;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_MEDIUM)
    if(!uvm_config_db#(virtual intf)::get(this,"","intf",intf)) begin
      `uvm_error("build_phase","driver virtual interface failed")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_MEDIUM)
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    `uvm_info(get_name(), "DRIVER RUN PHASE", UVM_MEDIUM)
    `uvm_delay(10)
    intf.pwdata <= 0;
    intf.pwrite <= 0;
    intf.paddr <= 0;
    intf.psel <= 0;
    intf.penable <= 0;
    apb_reset();
    
    forever begin
      item = apb_transaction::type_id::create("item"); 
      seq_item_port.get_next_item(item);
      if (item.pwrite == 1)
        Apb_Write(item.paddr, item.pwdata);
      else
      begin
        Apb_Read(item.paddr, data);
        item.prdata = data;
      end
      //Handshake DONE back to sequencer
      seq_item_port.item_done();
    end

  endtask
  
    task apb_reset();   // apb reset method
        intf.preset_n   <=  0                           ;
        repeat(2)   @(negedge   intf.apb_clk)           ;
        intf.preset_n   <=  1                           ;
    endtask 

    task Apb_Write(input bit [7:0] addr, input bit [7:0] data);
        @(posedge   intf.apb_clk)                       ;
        intf.paddr      <=  addr                        ;
        intf.pwrite     <=  1                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        intf.pwdata     <=  data                        ;
        @(posedge   intf.apb_clk);
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk)                       ;
        //$display("APB write data = %h into register = %h  at time = %t", data, addr, $time);
        //cov.sample()                                    ;   //  sample covergroup
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        @(negedge intf.apb_clk)                         ;
    endtask

    task Apb_Read (input bit [7:0] addr, output logic [7:0] prdata);
        $display("---------------------------------------Ham read ---------------------------------\n\n");
        @(posedge   intf.apb_clk)                       ;
        intf.paddr      <=  addr                        ;
        intf.pwrite     <=  0                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        @(posedge   intf.apb_clk)                       ;
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk)                       ;
        prdata          =  intf.prdata                 ;
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        @(negedge intf.apb_clk)                         ;
    endtask

    task Check_Start_condition (output bit start_done);
        start_done = 0    ;
        while (!start_done) begin
            @(negedge   intf.sda);
            if(intf.scl) begin     
                $display("\tSTART condition found at %t", $time); 
                start_done      =   1   ;
            end
            else
                start_done = 0 ;
        end
    endtask

    task Check_Stop_condition (output bit stop_done);
        stop_done     =   0   ;
        while (!stop_done) begin
            @(posedge   intf.sda);
            if(intf.scl) begin     
                $display("\tSTOP condition found at %t", $time); 
                stop_done   =   1   ;
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

endclass // apb_driver

`endif 