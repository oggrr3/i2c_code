module clock_generator (
    input           i2c_core_clk_i      ,   // i2c core clock
    input           scl_en_i            ,   // enbale clock to scl
    output          i2c_scl_o               // scl output
);

    localparam      DIVIDE_BY    =   4    ;
    reg             i2c_clk      =   1    ;
    reg     [7:0]   counter      =   0    ;

    // divide i2c core clock to i2c scl output
    always @(posedge    i2c_core_clk_i) begin
        if (scl_en_i) begin
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

endmodule