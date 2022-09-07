`timescale 1ns/1ps

module uart_tx_tb ();

parameter clock_period = 5 ;

reg clk_tb, rst_tb, par_typ_tb, par_en_tb, data_valid_tb;
reg [7:0] p_data_tb;
wire tx_out_tb, busy_tb;

uart_tx DUT (
    .clk(clk_tb),
    .rst(rst_tb),
    .par_typ(par_typ_tb),
    .par_en(par_en_tb),
    .data_valid(data_valid_tb),
    .p_data(p_data_tb),
    .tx_out(tx_out_tb),
    .busy(busy_tb)
);

always #(clock_period*0.5) clk_tb = ~clk_tb;

initial
begin
    clk_tb = 1'b0;
    rst_tb = 1'b1;
    p_data_tb = 'b0;
    par_typ_tb = 1'b0;
    par_en_tb = 1'b0;
    data_valid_tb = 1'b0;
    
    #1
    rst_tb = 1'b0;
    #2
    rst_tb = 1'b1;

    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);

    p_data_tb = 8'b10011011;
    data_valid_tb = 1'b1;
    par_en_tb = 1'b1;
    par_typ_tb = 1'b1;
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    
    p_data_tb = 8'b10011010;
    
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    
    data_valid_tb = 1'b0;

    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    
    p_data_tb = 8'b01101011;
    data_valid_tb = 1'b1;
    par_en_tb = 1'b1;
    par_typ_tb = 1'b0;

    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    p_data_tb = 8'b10101100;
    data_valid_tb = 1'b1;
    
    par_typ_tb = 1'b0;
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    data_valid_tb = 1'b0;
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    par_en_tb = 1'b0;
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);
    #(clock_period)
    $display("tx_out = %b , busy = %b , data valid = %b , p_data = %b , par_typ = %b , par_en = %b ", tx_out_tb, busy_tb, data_valid_tb, p_data_tb, par_typ_tb, par_en_tb);



end

endmodule