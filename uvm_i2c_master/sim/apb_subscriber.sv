`ifndef APB_SUBSCRIBER
`define APB_SUBSCRIBER


class   apb_subscriber extends uvm_subscriber #(apb_transaction);

    `uvm_component_utils(apb_subscriber)
    uvm_analysis_imp #(apb_transaction, apb_subscriber) apb_subscriber_port ;

    apb_transaction item    ;

    reg [7:0]    ADDR_SLAVE;
    reg [7:0]    PADDR;

    covergroup cg;
        addr_slave:   coverpoint  ADDR_SLAVE  {
            bins address_of_slave_to_read   =   {8'b0010_000_1}     ;
            bins address_of_slave_to_write  =   {8'b0010_000_0}     ;
        }

        reg_addr: coverpoint PADDR   {
            bins    apb_read_status_reg         =   {3}     ;
            bins    apb_read_receive_reg        =   {5}     ;

            bins    apb_write_prescale_reg      =   {1}     ;
            bins    apb_write_slave_addr_reg    =   {2}     ;
            bins    apb_write_transmit_reg      =   {4}     ;
            bins    apb_write_cmd_reg           =   {6}     ;
        }

        //cov_apb: cross addr_slave, reg_addr ;

    endgroup

    function  new(string name = "apb_subscriber", uvm_component parent);
        super.new(name, parent);
        apb_subscriber_port = new("apb_subscriber_port", this);
        item = apb_transaction::type_id::create("item");
        cg = new();
    endfunction

    //  Sample
    virtual function void write(apb_transaction t);
        `uvm_info(get_name(), "Sample", UVM_LOW)
        PADDR = t.paddr;
        ADDR_SLAVE = t.pwdata;
        cg.sample();
        //`uvm_info(get_type_name(), $sformatf(" ---- cvg is %0f", cg.get_coverage()), UVM_NONE)  // %f -> real number in decimal format
    endfunction

endclass

`endif 