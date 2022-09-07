module mux4 (mux_sel, ser_data, par_bit, tx_out);

input [1:0] mux_sel;
input ser_data, par_bit;
output reg tx_out;

parameter start_bit = 1'b0;
parameter stop_bit = 1'b1;

always@(*)
begin
    case(mux_sel)
    2'b00: tx_out = start_bit;
    2'b01: tx_out = stop_bit;
    2'b10: tx_out = ser_data;
    2'b11: tx_out = par_bit;
    endcase
end

endmodule