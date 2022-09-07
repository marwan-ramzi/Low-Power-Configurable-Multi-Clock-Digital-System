module serializer_tb ();

parameter clock_period = 100;

reg ser_en_tb, load_tb, clk_tb, rst_tb;
reg [7:0] p_data_tb;
wire ser_data_tb, ser_done_tb;

serializer DUT (
    .ser_en(ser_en_tb),
    .load(load_tb),
    .clk(clk_tb),
    .rst(rst_tb),
    .p_data(p_data_tb),
    .ser_data(ser_data_tb),
    .ser_done(ser_done_tb)
);

always #(clock_period/2) clk_tb = ~clk_tb;

initial 
begin
    clk_tb = 1'b0;
    rst_tb = 1'b1;
    p_data_tb = 'b0;
    ser_en_tb = 1'b0;
    load_tb = 1'b0;
    
    #30
    rst_tb = 1'b0;
    #60
    rst_tb = 1'b1;

    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);

    load_tb = 'b1;
    ser_en_tb = 'b1;
    p_data_tb = 8'b10011011;
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);

    load_tb = 'b0;

    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);
    #(clock_period)
    $display("ser data = %b , ser done = %b , p_data = %b , ser_en = %b , load = %b", ser_data_tb, ser_done_tb, p_data_tb, ser_en_tb, load_tb);

    $stop;
end

endmodule