module uart_tx (clk, rst, par_typ, par_en, p_data, data_valid, tx_out, busy);

input clk, rst, par_typ, par_en, data_valid;
input [7:0] p_data;
output tx_out, busy;

wire ser_done_int, ser_en_int, ser_data_int, load_int, par_bit_int;
wire [1:0] mux_sel_int;

mux4 u0(
    .mux_sel(mux_sel_int),
    .ser_data(ser_data_int), 
    .par_bit(par_bit_int),
    .tx_out(tx_out)
);

parity_calc u1(
    .clk(clk),
    .rst(rst), 
    .data_valid(data_valid), 
    .par_typ(par_typ), 
    .load(load_int),
    .p_data(p_data),
    .par_bit(par_bit_int)
);

serializer u2(
    .clk(clk),
    .rst(rst),
    .ser_en(ser_en_int), 
    .load(load_int),
    .p_data(p_data),
    .ser_data(ser_data_int), 
    .ser_done(ser_done_int)
);

uart_tx_fsm u3(
    .clk(clk),
    .rst(rst),
    .data_valid(data_valid), 
    .par_en(par_en), 
    .ser_done(ser_done_int),
    .mux_sel(mux_sel_int),
    .load(load_int), 
    .ser_en(ser_en_int), 
    .busy(busy)
);

endmodule