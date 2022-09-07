module BIT_SYNC # (parameter NUM_STAGES = 2, BUS_WIDTH = 1)
(ASYNC, RST, CLK, SYNC);

input [BUS_WIDTH-1:0] ASYNC;
input CLK, RST;
output reg [BUS_WIDTH-1:0] SYNC;

integer i;
//reg [NUM_STAGES-1:0] ff [BUS_WIDTH-1:0];
reg [NUM_STAGES-1:0] ff;

always@(posedge CLK or negedge RST)
begin
    if(!RST)
    begin
    ff <= 'b0;
    SYNC <= 'b0;
    end
    else
    begin
        ff [0] <= ASYNC;
        ff [1] <= ff[0];
        for(i=1 ; i<(NUM_STAGES-1) ; i=i+1)
        ff[i+1] <= ff[i];
        SYNC <= ff[NUM_STAGES-1];
    end
end

endmodule