module serializer (clk, rst, p_data, ser_en, load, ser_done, ser_data);

input ser_en, load, clk, rst;
input [7:0] p_data;
//output reg ser_data/*, ser_done*/;
output wire ser_data;
output wire ser_done;

reg [7:0] ff;
reg [2:0] count;
reg done, data;

integer i;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    ff <= 'b0;
    else if(load)
    ff <= p_data;
    else if (ser_en)
    begin
        for (i=7; i>0; i=i-1)
        ff[i-1] <= ff[i];
    end
    //data <= ff[0];
end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        count <= 'b0;
    end
    else
    begin
        if (ser_en)
        count <= count + 1'b1;
        else
        count <= 'b0;
    end
    //done <= (count == 3'b111) ? 1'b1 : 1'b0;
end

assign ser_data = ff[0];
assign ser_done = (count == 3'b111) ? 1'b1 : 1'b0; //done;

endmodule