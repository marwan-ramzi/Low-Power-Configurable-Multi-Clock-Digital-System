module RST_SYNC # (parameter NUM_STAGES = 2)
(CLK, RST, SYNC_RST);

input CLK, RST;          // REMINDER: Destination CLK domain
output reg SYNC_RST;

integer i;

reg [NUM_STAGES-1:0] ff;

always@(posedge CLK or negedge RST)
begin
    if(!RST)
    begin
    ff <= 'b0;
    SYNC_RST <= 1'b0;
    end
    else
    begin
        ff [0] <= 1'b1;
        ff [1] <= ff[0];
        for(i=1 ; i<(NUM_STAGES-1) ; i=i+1)
        begin
        ff[i+1] <= ff[i];
        end
        SYNC_RST <= ff[NUM_STAGES-1];
    end
end

endmodule