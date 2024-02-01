module clock_generator  #(parameter DIVIDE_BY = 8)
(
    input           i2c_core_clk_i          ,   // i2c core clock
    input           clk_en_i                ,   // enbale clock to scl
    input           reset_ni                ,   // negetive reset signal f
    output          i2c_scl_o                   // scl output
);

    reg             i2c_clk                 ;
    reg     [7:0]   counter                 ;

	assign	i2c_scl_o	=	i2c_clk		    ;	

    // divide i2c core clock to i2c scl output
    always @(posedge    i2c_core_clk_i,     negedge   reset_ni) begin

        if (~reset_ni) begin
            i2c_clk         <=      1       ;
            counter         <=      0       ;
        end

        else    begin
            if (clk_en_i) begin
                if ( counter == (DIVIDE_BY / 2) - 1 ) begin
                    i2c_clk     <=   ~i2c_clk    ;
                    counter     <=      0        ;
                end 
                else begin
                    counter     <=  counter + 1  ;   
                end
            end
            else begin
                i2c_clk         <=      1        ;
            end

        end

    end

endmodule
