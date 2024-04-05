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

    endgroup
    
    function new(virtual intf_i2c intf) ;   //  Constuctor

        this.intf        =   intf                        ;
     
    endfunction 

    task drive(input integer iteration = 1);
        repeat(iteration)
        begin
            sti = new();
            //@ (negedge intf.apb_clk);
            if(sti.randomize()) begin                             // Generate stimulus
                //intf.pwdata =   sti.pwdata                   ;   // Drive to DUT
                //intf.paddr  =   sti.paddr                   ;
                $display("Randomization succefully at time = %t", $time);
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
        $display("APB write data = %d into register = %d  at time = %t", data, addr, $time);
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
        $display("APB read  data = %d from register = %d  at time = %t", intf.prdata, addr, $time);
        intf.psel       <=  0                           ;
        intf.penable    <=  0                           ;
        @(negedge intf.apb_clk)                         ;
    endtask

    task Apb_Write_n_byte_random (input integer quantityOfRepeat = 1);

        bit [7:0]   data    ;

        apb_reset();
        Apb_Write(1, 8)                    ;   //  Prescale
        Apb_Write(2, 8'b001_0000_0)        ;   //  Address of slave and R/W bit
        Apb_Write(4, 0)                    ;

        for (int i = 0 ; i < quantityOfRepeat ; i = i + 1 ) begin
            drive(1);
            data = sti.pwdata  ;
            Apb_Write(4, data)  ;
        end

        Apb_Write(6, 8'b1001_0000)         ;   //  cmd

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
        $display("--------Deteced 1 byte data = %d from SDA at time = %0t--------", one_byte_data, $time);
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
