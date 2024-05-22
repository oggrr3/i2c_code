`ifndef TB_TOP
`define TB_TOP
import uvm_pkg::*;
`include "uvm_macros.svh"



`include "intf.sv"
`include "apb_transaction.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_sequencer.sv"
`include "apb_agent.sv"
`include "i2c_reg_block.sv"
`include "reg_to_apb_adapter.sv"
`include "apb_sequence.sv"
`include "apb_env.sv"
`include "testcase.sv"


//
//



module tb_top ();

    //  Clock generator
    reg     i2c_clk     =   0   ;
    reg     apb_clk     =   0   ;

    always  #10    i2c_clk     =   ~i2c_clk    ;
    always  #5     apb_clk     =   ~apb_clk    ;

    intf  intf(i2c_clk, apb_clk)    ;

    top_level     dut (
        .PCLK       (apb_clk),
        .PRESETn    (intf.preset_n),
        .PSELx      (intf.psel),
        .PWRITE     (intf.pwrite),
        .PENABLE    (intf.penable),
        .PADDR      (intf.paddr),
        .PWDATA     (intf.pwdata),
        .core_clk   (i2c_clk),

        .PREADY     (intf.pready),
        .PRDATA     (intf.prdata),
        .sda        (intf.sda),
        .scl        (intf.scl)
    );

    i2c_slave_model  i2c_slave_model (
        .sda  (intf.sda)  ,
        .scl  (intf.scl)
    );

    initial begin
        uvm_config_db #(virtual intf)::set(null, "*", "intf", intf);
        run_test("testcase");
    end

endmodule

`endif 