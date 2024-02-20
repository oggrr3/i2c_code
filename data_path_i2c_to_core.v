module data_path_i2c_to_core    # ( parameter     DATA_SIZE   =   8 , 
                                    parameter     ADDR_SIZE   =   8 )    
(
    input   [DATA_SIZE - 1 : 0]         data_i              ,   // data from fifo buffer
    input   [ADDR_SIZE - 1 : 0]         addr_i              ,   // address of slave
    input   [3 : 0]                     count_bit_i         ,   // sda input
    //input                               i2c_core_clk_i      ,   // i2c core clock
    //input                               reset_ni            ,   // reset negetive signal from MCU
    input                               i2c_sda_i           ,   // sda line

    input                               sda_low_en_i        ,   // control sda signal from FSM, when 1 sda = 0
    input                               write_data_en_i     ,   // enable write data signal from FSM
    input                               write_addr_en_i     ,   // enable write slave's signal to sda 
    input                               receive_data_en_i   ,   // enable receive data from sda

    output  [DATA_SIZE - 1 : 0]         data_from_sda_o     ,   // data from sda to write to FIFO buffer
    output                              i2c_sda_o              // i2c sda output   
                     
);
    
    reg     	[DATA_SIZE - 1 : 0]         data_from_sda       			;
	reg										i2c_sda			=	1 			;
	reg										data_done						;

	assign		i2c_sda_o			=		i2c_sda							;
    assign      data_from_sda_o	   	=   	data_from_sda       			;


    // // read-write data to sda
    // always @(posedge    i2c_core_clk_i,     negedge     reset_ni  ) begin

    //     if (reset_ni) begin
    //         data_from_sda   <=      0                           ;
    //     end

    //     else begin

    //     end

    // end     



    //  sda-data in out
    always @(*) begin

        if (sda_low_en_i) begin
            i2c_sda	       =       0                               ;
        end 

        else if (write_addr_en_i) begin
            i2c_sda	       =       addr_i[count_bit_i]             ;
        end

        else if (receive_data_en_i) begin
            data_from_sda[count_bit_i]   =       i2c_sda_i       ;  
        end

        else if (write_data_en_i) begin
            i2c_sda	       =      data_i[count_bit_i]              ;
        end

        else begin
            i2c_sda	       =      i2c_sda                                ;
        end

        // ko can do xu ly ben fsm roi
        // if (count_bit_i == 0) begin
        //     data_done	     =       1                               ;
        // end 
        // else begin
        //     data_done	     =       0                               ;
        // end
        
    end

endmodule