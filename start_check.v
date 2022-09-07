module start_check (clk, rst, strt_chk_en, sampled_bit, strt_glitch);

input clk, rst, strt_chk_en, sampled_bit;
output strt_glitch;

reg ff;
/*
always@(posedge clk or negedge rst)
begin
    if(!rst)
    ff <= 1'b0;
    else if (strt_chk_en)
    ff <= sampled_bit;
end
*/
assign strt_glitch = sampled_bit;

endmodule