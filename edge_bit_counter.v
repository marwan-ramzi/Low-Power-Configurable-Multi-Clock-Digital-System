module edge_bit_counter (clk, rst, prescale, bit_en, edge_en, bit_cnt, edge_cnt);

input [4:0] prescale;
input clk, rst, bit_en, edge_en;
output reg [2:0] bit_cnt;
output reg [4:0] edge_cnt;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    edge_cnt <= 'b0;
    else if( (edge_en == 1) && (edge_cnt < prescale) ) // (edge <= prescale)
    edge_cnt <= edge_cnt + 1'b1;
    else
    edge_cnt <= 'b0;
end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    bit_cnt <= 'b0;
    else if ( (bit_en == 1) && (edge_cnt == prescale) )
    bit_cnt <= bit_cnt + 1'b1;
end

endmodule