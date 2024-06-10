`ifndef  APB_SCOREBOARD
`define APB_SCOREBOARD

class apb_socreboard extends uvm_scoreboard;

    `uvm_component_utils(apb_socreboard)
    uvm_analysis_imp#(apb_transaction, apb_socreboard)  scoreboard_port ;
    virtual intf intf   ;

    //  Queue
    apb_transaction transactions[$];
    logic   [7:0]   data_sda[$];

    integer i = 0;
    apb_transaction curr_trans;
    logic   [7:0]   data;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "Build Phase", UVM_MEDIUM)
        if(!uvm_config_db#(virtual intf)::get(this,"","intf",intf)) begin
            `uvm_error("Build_phase","driver virtual interface failed")
        end

        scoreboard_port = new("scoreboard_port", this);
        data_sda.push_back(0);                                          //  data_sda[0] = 0 . this is slave's base addr mem
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), "Connect Phase", UVM_MEDIUM)
    endfunction

    //  Compare
    virtual function void check_phase (uvm_phase phase);
        super.check_phase(phase);
        `uvm_info(get_name(), "Check Phase!---------------------------------------------", UVM_MEDIUM)
        
        // foreach(transactions[i])
        //     $display("transactions[%0d] = %h", i, transactions[i].pwdata);

        if (this.data_sda.size() > 1) begin
            foreach(data_sda[i]) begin
                //$display("data_sda[%0d] = %h", i, data_sda[i]);
                if (data_sda[i] == transactions[i].pwdata) 
                    $display("PASS: Actual %h = Expected %h at time %d", data_sda[i], transactions[i].pwdata, $time);
                else   
                    $error("FAIL: Actual %h != Expected %h at time %d", data_sda[i], transactions[i].pwdata, $time);
            end
        end
    endfunction

    function void write (apb_transaction item);
        if (item.paddr == 8'h04)                                   //  receive reg
            transactions.push_back(item);                           //  adding element to array
    endfunction

    task compare (apb_transaction curr_trans, logic [7:0] data_on_sda);
        logic   [7:0]   expected    ;
        logic   [7:0]   actual      ;

        //  Check data on sda with data that apb read
        case (curr_trans.pwrite)
            1       :   begin                                   //  i2c master write
                expected    =   curr_trans.pwdata   ;
                actual      =   data_on_sda         ;
            end

            0       :   begin                                   //  apb read data that i2c master read from slave
                expected    =   data_on_sda         ;
                actual      =   curr_trans.prdata   ;
            end
        endcase
        
        if (expected == actual) 
            `uvm_info(get_name(), "PASSSSSSSSSSS99-----------------------------------------------", UVM_LOW)
        else   $error("Expected %h not equals actual %h", expected, actual);
    endtask

endclass

`endif 
