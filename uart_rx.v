module uart_rx (clk, rst, par_typ, par_en, prescale, rx_in, p_data, data_valid);

input clk, rst, par_typ, par_en, rx_in;
input [4:0] prescale;
output [7:0] p_data;
output data_valid;

wire dat_samp_en_int, edge_en_int, bit_en_int;
wire deser_en_int, sampled_bit_int, stp_err_int;
wire stp_chk_en_int, strt_chk_en_int, strt_glitch_int;
wire par_err_int, par_chk_en_int;
wire [4:0] edge_cnt_int;
wire [2:0] bit_cnt_int;

start_check u0(
    .clk(clk),
    .rst(rst), 
    .strt_chk_en(strt_chk_en_int), 
    .sampled_bit(sampled_bit_int),
    .strt_glitch(strt_glitch_int)
);

stop_check u1(
    .clk(clk), 
    .rst(rst), 
    .stp_chk_en(stp_chk_en_int), 
    .sampled_bit(sampled_bit_int),
    .stp_err(stp_err_int)
);

parity_check u2(
    .clk(clk), 
    .rst(rst), 
    .par_chk_en(par_chk_en_int), 
    .sampled_bit(sampled_bit_int), 
    .par_typ(par_typ),
    .par_err(par_err_int)
);

deserializer u3(
    .clk(clk), 
    .rst(rst), 
    .deser_en(deser_en_int), 
    .sampled_bit(sampled_bit_int), 
    .data_valid(data_valid),
    .p_data(p_data)
);

edge_bit_counter u4(
    .prescale(prescale),
    .clk(clk), 
    .rst(rst), 
    .bit_en(bit_en_int), 
    .edge_en(edge_en_int),
    .bit_cnt(bit_cnt_int),
    .edge_cnt(edge_cnt_int)
);

data_sampling u5(
    .prescale(prescale),
    .edge_cnt(edge_cnt_int),
    .clk(clk), 
    .rst(rst), 
    .dat_samp_en(dat_samp_en_int), 
    .rx_in(rx_in),
    .sampled_bit(sampled_bit_int)
);

uart_rx_fsm u6(
    .clk(clk), 
    .rst(rst), 
    .rx_in(rx_in), 
    .par_en(par_en),
    .edge_cnt(edge_cnt_int), 
    .prescale(prescale),
    .bit_cnt(bit_cnt_int),
    .stp_err(stp_err_int), 
    .strt_glitch(strt_glitch_int), 
    .par_err(par_err_int), 
    .dat_samp_en(dat_samp_en_int), 
    .edge_en(edge_en_int), 
    .bit_en(bit_en_int), 
    .deser_en(deser_en_int),
    .data_valid(data_valid),
    .stp_chk_en(stp_chk_en_int), 
    .strt_chk_en(strt_chk_en_int), 
    .par_chk_en(par_chk_en_int)
);

endmodule