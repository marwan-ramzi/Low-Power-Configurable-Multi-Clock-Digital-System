module ClkDiv #(parameter width = 4)
(i_ref_clk, i_rst_n, i_clk_en, i_div_ratio, o_div_clk);

input i_ref_clk, i_rst_n, i_clk_en;
input [width-1:0] i_div_ratio;
//output reg o_div_clk;
output wire o_div_clk;

reg [width-1:0] counter;
reg out;

always @(posedge i_ref_clk or negedge i_rst_n) 
begin
    if (!i_rst_n)
    begin
    out <= 'b0;
    counter <= 'b0;
    end
    else if (!i_clk_en || (i_div_ratio<'b10))
    begin
    counter <= 'b0;
    end
    else
    begin
        counter <= counter + 1'b1;
        if(counter == ((i_div_ratio-1) / 2))
        out <= 1'b1;
        else if (counter == (i_div_ratio-1))
        begin
        out <= 1'b0;
        counter <= 'b0;
        end
    end
end

assign o_div_clk = (!i_clk_en || (i_div_ratio < 'b10)) ? i_ref_clk : out;
endmodule