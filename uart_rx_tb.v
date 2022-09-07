`timescale 1ns/1ps

module uart_rx_tb ();

parameter clock_period = 5 ; // CLOCK = 5

reg clk_tb, rst_tb, par_typ_tb, par_en_tb, rx_in_tb;
reg [4:0] prescale_tb;
wire [7:0] p_data_tb;
wire data_valid_tb;

uart_rx DUT (
    .clk(clk_tb),
    .rst(rst_tb),
    .par_typ(par_typ_tb),
    .par_en(par_en_tb),
    .rx_in(rx_in_tb),
    .prescale(prescale_tb),
    .p_data(p_data_tb),
    .data_valid(data_valid_tb)
);

always # (clock_period*0.5) clk_tb = ~clk_tb;

initial 
begin
    clk_tb      = 1'b0; 
    rst_tb      = 1'b1; 
    par_typ_tb  = 1'b0; 
    par_en_tb   = 1'b0; 
    rx_in_tb    = 1'b1;
    prescale_tb = 'b0;

    #1
    rst_tb = 1'b0;
    #2
    rst_tb = 1'b1;

    $monitor(" p_data = %b, data valid = %b , rx_in = %b , prescale = %b , par_typ = %b , par_en = %b", p_data_tb, data_valid_tb, rx_in_tb, prescale_tb, par_typ_tb, par_en_tb);
    
    #(clock_period)
    #(clock_period)

    par_typ_tb  = 1'b1; 
    par_en_tb   = 1'b1; 
    rx_in_tb    = 1'b0;
    prescale_tb = 5'b00111;

    //#(clock_period)

    #(clock_period*8)   //start bit
    rx_in_tb = 1'b1;    //data
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)

    rx_in_tb = 1'b0;    // parity bit

    #(clock_period*8)

    rx_in_tb = 1'b1;    //stop bit

    #(clock_period*8)

    //#(clock_period)
    //#(clock_period)

    par_typ_tb  = 1'b0; 
    par_en_tb   = 1'b1; 
    rx_in_tb    = 1'b0;
    prescale_tb = 5'b00111;

    //#(clock_period)

    #(clock_period*8)   //start bit
    rx_in_tb = 1'b1;    //data
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)

    rx_in_tb = 1'b1;    // parity bit

    #(clock_period*8)

    rx_in_tb = 1'b1;    //stop bit

    #(clock_period*8)

    //#(clock_period)
    //#(clock_period)

    par_typ_tb  = 1'b0; 
    par_en_tb   = 1'b0; 
    rx_in_tb    = 1'b0;
    prescale_tb = 5'b00111;

    //#(clock_period)

    #(clock_period*8)   //start bit
    rx_in_tb = 1'b0;    //data
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)
    rx_in_tb = 1'b1; 
    #(clock_period*8)
    rx_in_tb = 1'b0; 
    #(clock_period*8)

    rx_in_tb = 1'b1;    // parity bit

    #(clock_period*8)

    rx_in_tb = 1'b1;    //stop bit

    #(clock_period*8)
    
    $stop;

end

endmodule