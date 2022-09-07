module DATA_SYNC #( parameter NUM_STAGES = 2, BUS_WIDTH = 8)

(unsync_bus, bus_enable, CLK, RST, sync_bus, enable_pulse);

input [BUS_WIDTH-1:0] unsync_bus;
input CLK, RST, bus_enable;      // REMINDER: Destination CLK domain
output reg [BUS_WIDTH-1:0] sync_bus;
output reg enable_pulse;

integer i;
//reg [NUM_STAGES-1:0] ff [BUS_WIDTH-1:0];
reg [NUM_STAGES-1:0] ff;
reg bus_enable_out, q;
wire pulse_gen;

always@(posedge CLK or negedge RST)
begin
    if(!RST)
    begin
    ff <= 'b0;
    bus_enable_out <= 'b0;
    end
    else
    begin
        ff [0] <= bus_enable;
        ff [1] <= ff[0];
        for(i=1 ; i<(NUM_STAGES-1) ; i=i+1)
        ff[i+1] <= ff[i];
        bus_enable_out <= ff[NUM_STAGES-1];
        q <= bus_enable_out;
        enable_pulse <= pulse_gen;
    end
end

/*always@(posedge CLK or negedge RST)
begin
    if(!RST)
    begin
    q <= 1'b0;
    enable_pulse = 1'b0;
    end
    else
    begin
        q <= bus_enable_out;
        pulse_gen <= !q && bus_enable_out;
        enable_pulse <= pulse_gen;
    end
end*/

assign pulse_gen = !q && bus_enable_out;

always@(posedge CLK or negedge RST)
begin
    if(!RST)
    sync_bus <= 'b0;
    else
    begin
        if(pulse_gen)
        sync_bus <= unsync_bus;
    end
end

endmodule