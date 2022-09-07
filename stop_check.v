module stop_check (clk, rst, stp_chk_en, sampled_bit, stp_err);

input clk, rst, stp_chk_en, sampled_bit;
output stp_err;

reg ff;

/*
always@(posedge clk or negedge rst)
begin
    if(!rst)
    ff <= 1'b0;
    else if(stp_chk_en)
    ff <= sampled_bit;
end
*/
assign stp_err = ~sampled_bit;

endmodule