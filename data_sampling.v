module data_sampling (clk, rst, rx_in, prescale, dat_samp_en, edge_cnt, sampled_bit);

input [4:0] prescale;
input [4:0] edge_cnt;
input clk, rst, dat_samp_en, rx_in;
output reg sampled_bit;

reg [2:0] ff;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        ff <= 'b0;
        //sampled_bit <= 1'b0;
    end
    else if (dat_samp_en)
    begin
        if ( (edge_cnt == (prescale/2)) || (edge_cnt == ((prescale/2)+1)) || (edge_cnt == ((prescale/2)+2)) )
        ff <= {ff[1:0], rx_in};        
    end
end

always@(*)
begin
    if(edge_cnt == prescale)
    sampled_bit = (ff[0] & ff[1]) | (ff[0] & ff[2]) | (ff[2] & ff[1]);
    else
    sampled_bit = 'b0;
end

endmodule
