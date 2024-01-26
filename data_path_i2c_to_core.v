module data_path_i2c_to_core    # ( parameter     DATA_SIZE   =   8 , 
                                    parameter     ADDR_SIZE   =   7 )    
(
    input   [DATA_SIZE - 1 : 0]         data_i          ,   // data from fifo buffer
    input   [ADDR_SIZE - 1 : 0]         addr_i          ,   // address of slave
    input                               sda_i           ,   // sda input
    input                               i2c_core_clk_i  ,   // i2c core clock

    input                               sda_low_i       ,   // control sda signal from FSM, when 1 sda = 0
    input                               write_data_en_i ,   // enable write data signal from FSM
    input                               write_addr_en_i ,   // enable write slave's signal to sda 
    input                             receive_data_en_i ,   // enable receive data from sda

    output  [DATA_SIZE - 1 : 0]     data_from_sda_o     ,   // data from sda to write to FIFO buffer
    output  reg                     i2c_sda_o               // i2c sda output                              
);
    

    //localparam      count_data_bit      =       DATA_SIZE - 1       ;
    //localparam      count_addr_bit      =       ADDR_SIZE - 1       ;

    // read-write data to sda
    always @(posedge    i2c_core_clk_i  ) begin
        if (sda_low_i) begin
            i2c_sda_o   <=  0       ;
        end 
        else begin
            
            if (write_addr_en_i) begin
                i2c_sda_o      <=      addr_i[count_addr_bit]       ;
            end

        end 
    end     






    


    


endmodule