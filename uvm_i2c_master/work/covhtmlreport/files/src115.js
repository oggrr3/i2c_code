var g_data = {"name":"../sim/tb_top.sv","src":"`ifndef TB_TOP\r\n`define TB_TOP\r\nimport uvm_pkg::*;\r\n`include \"uvm_macros.svh\"\r\n\r\n\r\n\r\n`include \"intf.sv\"\r\n`include \"apb_transaction.sv\"\r\n`include \"apb_driver.sv\"\r\n`include \"apb_monitor.sv\"\r\n`include \"apb_sequencer.sv\"\r\n`include \"apb_agent.sv\"\r\n`include \"apb_scoreboard.sv\"\r\n`include \"i2c_reg_block.sv\"\r\n`include \"reg_to_apb_adapter.sv\"\r\n`include \"apb_sequence.sv\"\r\n`include \"apb_subscriber.sv\"\r\n`include \"apb_env.sv\"\r\n`include \"testcase.sv\"\r\n\r\n\r\n//\r\n//\r\n\r\n\r\n\r\nmodule tb_top ();\r\n\r\n    //  Clock generator\r\n    reg     i2c_clk     =   0   ;\r\n    reg     apb_clk     =   0   ;\r\n\r\n    always  #10    i2c_clk     =   ~i2c_clk    ;\r\n    always  #5     apb_clk     =   ~apb_clk    ;\r\n\r\n    intf  intf(i2c_clk, apb_clk)    ;\r\n\r\n    top_level     dut (\r\n        .PCLK       (apb_clk),\r\n        .PRESETn    (intf.preset_n),\r\n        .PSELx      (intf.psel),\r\n        .PWRITE     (intf.pwrite),\r\n        .PENABLE    (intf.penable),\r\n        .PADDR      (intf.paddr),\r\n        .PWDATA     (intf.pwdata),\r\n        .core_clk   (i2c_clk),\r\n\r\n        .PREADY     (intf.pready),\r\n        .PRDATA     (intf.prdata),\r\n        .sda        (intf.sda),\r\n        .scl        (intf.scl)\r\n    );\r\n\r\n    i2c_slave_model  i2c_slave_model (\r\n        .sda  (intf.sda)  ,\r\n        .scl  (intf.scl)  ,\r\n        .start(intf.start),\r\n        .stop   (intf.stop) ,\r\n        .data_slave_read    (intf.data_slave_read)  ,\r\n        .data_slave_read_valid  (intf.data_slave_read_valid)    ,\r\n        .reset  (intf.preset_n)\r\n    );\r\n\r\n    initial begin\r\n        uvm_config_db #(virtual intf)::set(null, \"*\", \"intf\", intf);\r\n        run_test(\"testcase\");\r\n    end\r\n\r\nendmodule\r\n\r\n`endif ","lang":"verilog"};
processSrcData(g_data);