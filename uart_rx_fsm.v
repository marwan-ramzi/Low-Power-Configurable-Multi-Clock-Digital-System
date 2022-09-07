module uart_rx_fsm (clk, rst, rx_in, par_en, prescale, edge_cnt, bit_cnt, stp_err, strt_glitch, par_err, dat_samp_en, edge_en, bit_en, deser_en, data_valid, stp_chk_en, strt_chk_en, par_chk_en);

input clk, rst, rx_in, par_en;
input [4:0] edge_cnt, prescale;
input [2:0] bit_cnt; 
input stp_err, strt_glitch, par_err; 
output reg dat_samp_en, edge_en, bit_en, deser_en;
output reg data_valid;
output reg stp_chk_en, strt_chk_en, par_chk_en;

reg [2:0] current_state, next_state;

parameter [2:0] idle   = 3'b000 ;
parameter [2:0] start  = 3'b001 ;
parameter [2:0] data   = 3'b010 ;
parameter [2:0] parity = 3'b011 ;
parameter [2:0] stop   = 3'b100 ;
parameter [2:0] check  = 3'b101 ;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    current_state <= idle ;
    else
    current_state <= next_state ;
end

always@(*)
begin
    case(current_state)
    idle:
    begin
        if(rx_in)
        next_state = idle;
        else
        next_state = start;
    end
    start:
    begin
        if (edge_cnt == prescale)
        begin
        if(strt_glitch)
        next_state = idle;
        else
        next_state = data;
        end
        else
        next_state = start;
    end
    data:
    begin
        if( (bit_cnt == 3'b111) && (edge_cnt == prescale) ) //( (bit_cnt == 3'b111) && (edge_cnt == prescale))
        begin
        if(par_en)
        next_state = parity;
        else
        next_state = stop;
        end
        else
        next_state = data;
    end
    parity:
    begin
        if (edge_cnt == prescale) 
        next_state = stop;   // uart_rx notes
        else
        next_state = parity;
    end
    stop:
    begin
        if (edge_cnt == prescale)
        begin
        if(rx_in)
        next_state = idle;
        else
        next_state = start;       //idle
        end
        else
        next_state = stop;
    end
    /*
    check:
    begin
        if(rx_in)
        next_state = idle;
        else
        next_state = start;
    end
    */
    default:
    begin
        next_state = idle;
    end
    endcase
end

always@(*)
begin
    case(current_state)
    idle:
    begin
        dat_samp_en = 1'b0 ;
        edge_en     = 1'b0 ;
        bit_en      = 1'b0 ;
        deser_en    = 1'b0 ;
        data_valid  = 1'b0 ;
        stp_chk_en  = 1'b0 ;
        strt_chk_en = 1'b0 ;
        par_chk_en  = 1'b0 ;
    end
    start:
    begin
        dat_samp_en = 1'b1 ;
        edge_en     = 1'b1 ;
        bit_en      = 1'b0 ;
        deser_en    = 1'b0 ;
        data_valid  = 1'b0 ;
        stp_chk_en  = 1'b0 ;
        strt_chk_en = 1'b1 ;
        par_chk_en  = 1'b0 ;
    end
    data:
    begin
        dat_samp_en = 1'b1 ;
        edge_en     = 1'b1 ;
        bit_en      = 1'b1 ;
        if (edge_cnt == prescale)
        deser_en    = 1'b1 ;
        else
        deser_en    = 1'b0 ;
        data_valid  = 1'b0 ;
        stp_chk_en  = 1'b0 ;
        strt_chk_en = 1'b0 ;
        if (edge_cnt == prescale) //((edge_cnt == prescale) && par_en)
        par_chk_en  = 1'b1 ;
        else
        par_chk_en  = 1'b0 ;
    end
    parity:
    begin
        dat_samp_en = 1'b1 ;
        edge_en     = 1'b1 ;
        bit_en      = 1'b0 ;
        deser_en    = 1'b0 ;
        data_valid  = 1'b0 ;
        stp_chk_en  = 1'b0 ;
        strt_chk_en = 1'b0 ;
        if (edge_cnt == prescale)
        par_chk_en  = 1'b1 ; // if (edg cnt == prescale)
        else
        par_chk_en  = 1'b0 ;
    end
    stop:
    begin
        dat_samp_en = 1'b1 ;
        edge_en     = 1'b1 ;
        bit_en      = 1'b0 ;
        deser_en    = 1'b0 ;
        if(par_en)
        begin
        if(stp_err || par_err)
        data_valid  = 1'b0 ;
        else
        data_valid  = 1'b1 ;
        end
        else
        begin
        if(stp_err)
        data_valid  = 1'b0 ;
        else
        data_valid  = 1'b1 ;
        end
        if (edge_cnt == prescale)
        stp_chk_en  = 1'b1 ;
        else
        stp_chk_en  = 1'b0 ;
        strt_chk_en = 1'b0 ;
        par_chk_en  = 1'b0 ;
    end
    /*check:
    begin
        dat_samp_en = 1'b0 ;
        edge_en     = 1'b0 ;
        bit_en      = 1'b0 ;
        deser_en    = 1'b0 ;
        if (par_err || stp_err)
        data_valid  = 1'b0 ;
        else
        data_valid  = 1'b1 ;
        stp_chk_en  = 1'b0 ;
        strt_chk_en = 1'b0 ;
        par_chk_en  = 1'b0 ;
    end*/
    default:
    begin
        dat_samp_en = 1'b0 ;
        edge_en     = 1'b0 ;
        bit_en      = 1'b0 ;
        deser_en    = 1'b0 ;
        data_valid  = 1'b0 ;
        stp_chk_en  = 1'b0 ;
        strt_chk_en = 1'b0 ;
        par_chk_en  = 1'b0 ;
    end
    endcase
end

endmodule