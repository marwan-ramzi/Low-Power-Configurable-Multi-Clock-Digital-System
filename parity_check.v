module parity_check (clk, rst, par_chk_en, sampled_bit, par_typ, par_err);

input clk, rst, par_chk_en, sampled_bit, par_typ;
output reg par_err;

reg [8:0] ff;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    ff <= 'b0;
    else if (par_chk_en)
    {ff[8:0]} <= { ff[7:0] , sampled_bit};
end

always@(*)
begin
    if(par_typ)
    par_err = ~^ff;
    else
    par_err = ^ff;
end

endmodule