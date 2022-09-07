module deserializer (clk, rst, deser_en, sampled_bit, data_valid, p_data);

input clk, rst, deser_en, sampled_bit, data_valid;
output [7:0] p_data;

reg [7:0] ff;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    ff <= 'b0;
    else if (deser_en)
    {ff[7:0]} <= { sampled_bit , ff[7:1] };
    /*
    ff[7] <= sampled_bit
    ff[6] <= ff[7]
    ff[5] <= ff[6]
    ff[4] <= ff[5]
    ff[3] <= ff[4]
    ff[2] <= ff[3]
    ff[1] <= ff[2]
    ff[0] <= ff[1]
    */
end

assign p_data = (data_valid == 1) ? ff : 'b0;

endmodule