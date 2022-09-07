module uart_top (rx_clk, rst, par_typ, par_en, /*rx_par_typ, rx_par_en,*/ prescale, rx_in, rx_p_data, rx_data_valid, tx_clk, tx_p_data, tx_data_valid, tx_out, busy);

input tx_clk, rst, par_typ, par_en, tx_data_valid;
input [7:0] tx_p_data;
output tx_out, busy;

input rx_clk, rx_in/*, rx_par_typ, rx_par_en*/;
input [4:0] prescale;
output [7:0] rx_p_data;
output rx_data_valid;

uart_tx u0(
    .clk(tx_clk),
    .rst(rst), 
    .par_typ(par_typ), 
    .par_en(par_en), 
    .data_valid(tx_data_valid),
    .p_data(tx_p_data),
    .tx_out(tx_out), 
    .busy(busy)
);

uart_rx u1(
    .clk(rx_clk),
    .rst(rst), 
    .rx_in(rx_in),
    .prescale(prescale),
    .p_data(rx_p_data),
    .data_valid(rx_data_valid),
    .par_typ(par_typ),
    .par_en(par_en)
);

endmodule
