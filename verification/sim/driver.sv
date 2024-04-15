//Driver class is responsible for,
//receive the stimulus generated from the generator and drive to DUT by assigning transaction class values to interface signals.

`ifndef DRIVER
`define DRIVER
`include "stimulus.sv"
`include "interface.sv"

class driver;
    stimulus            sti                             ;
    virtual intf_i2c    intf                             ;   // Creating virtrual interface handle                         

    covergroup cov;
        cov_pwdata  :   coverpoint      intf.pwdata  {
            bins address_of_slave_to_read   =   {8'b0010_000_1}     ;
            bins address_of_slave_to_write  =   {8'b0010_000_0}     ;
        }

        cov_paddr   :   coverpoint      intf.paddr   {
            bins    apb_read_status_reg         =   {3}     ;
            bins    apb_read_receive_reg        =   {5}     ;

            bins    apb_write_prescale_reg      =   {1}     ;
            bins    apb_write_slave_addr_reg    =   {2}     ;
            bins    apb_write_transmit_reg      =   {4}     ;
            bins    apb_write_cmd_reg           =   {6}     ;
        }
        cov_apb_rw  :   cross   cov_pwdata, cov_paddr {
            bins    cov_apb_write_slave_addr    =   binsof(cov_paddr.apb_write_slave_addr_reg) && binsof(cov_pwdata)    ;
            //bins    cov_apb_write               =   binsof(cov_paddr) intersect {3, 5}  ;
            //bins    cov_apb_read                =   binsof(cov_paddr) intersect {1, 2, 4, 6}    ;
        }
    endgroup
    
    function new(virtual intf_i2c intf) ;   //  Constuctor

        this.intf   =   intf    ;
        cov         =   new()   ;
    endfunction 

    task cov_sample();
        forever begin
            @(posedge intf.apb_clk) ;
            cov.sample();
        end
    endtask 

    task drive(input integer iteration = 1);
        repeat(iteration)
        begin
            sti = new();
            //@ (negedge intf.apb_clk);
            if(sti.randomize()) begin                             // Generate stimulus
                //cov.sample();
            end
            else 
                $fatal("ERROR :: Randomization fail! at time = %t", $time);
        end
    endtask

    task apb_reset();   // apb reset method
        intf.preset_n   <=  0                           ;
        intf.paddr      <=  0                           ;
        intf.pwrite     <=  0                           ;
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        intf.pwdata     <=  0                           ;
        repeat(2)   @(negedge   intf.apb_clk)           ;
        intf.preset_n   <=  1                           ;
        #1;
    endtask 

    task Apb_Write(bit [7:0] addr, bit [7:0] data);
        @(posedge   intf.apb_clk)                       ;
        intf.paddr      <=  addr                        ;
        intf.pwrite     <=  1                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        intf.pwdata     <=  data                        ;
        @(posedge   intf.apb_clk);
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk)                       ;
        $display("APB write data = %h into register = %h  at time = %t", data, addr, $time);
        cov.sample()                                    ;   //  sample covergroup
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        @(negedge intf.apb_clk)                         ;
    endtask

    task Apb_Read (bit [7:0] addr);
    
        @(posedge   intf.apb_clk)                       ;
        intf.paddr      <=  addr                        ;
        intf.pwrite     <=  0                           ;
        intf.psel       <=  1                           ;
        intf.penable    <=  0                           ;
        @(posedge   intf.apb_clk)                       ;
        intf.penable    <=  1                           ;
        @(posedge   intf.apb_clk)                       ;
        //prdata          <=  intf.prdata                 ;
        $display("APB read  data = %h from register = %h  at time = %t", intf.prdata, addr, $time);
        cov.sample()                                    ;   //  sample covergroup
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        @(negedge intf.apb_clk)                         ;
    endtask

    task Apb_Write_n_byte_random (input integer quantityOfRepeat = 1);

        bit [7:0]   data    ;

        for (int i = 0 ; i < quantityOfRepeat ; i = i + 1 ) begin
            drive(1);
            data = sti.pwdata  ;
            Apb_Write(4, data)  ;
        end

    endtask

    task Apb_Read_n_byte(bit [7:0] addr, int quantityOfRepeat);
    
        for (int i = 0 ; i < quantityOfRepeat ; i++ ) begin
            Apb_Read(addr)  ;
        end

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

    task Get1Byte_From_Sda (output bit [7:0] one_byte_data );

        bit [7:0] temp  =   0;
        for (int i = 0; i < 8 ; i = i + 1) begin
            @(posedge intf.scl) ;
            temp[7-i]     =    intf.sda   ;
        end

        one_byte_data   =   temp            ;
        $display("--------Deteced 1 byte data = %h from SDA at time = %0t--------", one_byte_data, $time);
    endtask 

    task Check_ACK();
        @(posedge intf.scl) ;
        if (!intf.sda)
            $display("---Detected  ACK at time = %0t", $time)    ;
        else    
            $display("---Detected NACK at time = %0t", $time)    ;
    endtask

endclass 

`endif 
