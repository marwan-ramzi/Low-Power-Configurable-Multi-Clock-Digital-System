module parity_calc (clk, rst, p_data, data_valid, par_typ, load, par_bit);

input clk, rst, data_valid, par_typ, load;
input [7:0] p_data;
output reg par_bit;

reg [7:0] ff;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    ff  <= 'b0;
    else
    begin
    if(load && data_valid)
    ff <= p_data;
    end
end

always@(*)
begin
    if(par_typ)
    par_bit = ~^ff;
    else
    par_bit = ^ff;
end

endmodule