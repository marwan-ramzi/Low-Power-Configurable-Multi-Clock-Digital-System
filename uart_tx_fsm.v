module uart_tx_fsm (clk, rst, data_valid, par_en, ser_done, load, ser_en, mux_sel, busy);

input data_valid, par_en, ser_done, clk, rst;
output reg [1:0] mux_sel;
output reg load, ser_en, busy;

reg [2:0] current_state, next_state;

parameter [2:0] s0 = 3'b000; //IDLE
parameter [2:0] s1 = 3'b001; //Start bit
parameter [2:0] s2 = 3'b010; //Ser data
parameter [2:0] s3 = 3'b011; //Party bit
parameter [2:0] s4 = 3'b100; //Stop bit

always@(posedge clk or negedge rst)
begin
    if(!rst)
    current_state <= s0;
    else
    current_state <= next_state;
end

always@(*)
begin
    case(current_state)
    s0:begin
        if(data_valid)
        next_state = s1;
        else
        next_state = s0;
    end
    s1:begin
        next_state = s2;
    end
    s2:begin
        if(ser_done)
        begin
            if(par_en)
            next_state = s3;
            else
            next_state = s4;
        end
        else
        next_state = s2;
    end
    s3:begin
        next_state = s4;
    end
    s4:begin
        next_state = s0;
    end
    default:begin
        next_state = s0;
    end
    endcase
end

always@(*)
begin
    case(current_state)
    s0:begin
        mux_sel = 2'b01 ; 
        load = 1'b1 ;
        ser_en = 1'b0 ;
        busy = 1'b0 ;
    end
    s1:begin
        mux_sel = 2'b00 ; 
        load = 1'b0 ;
        ser_en = 1'b0 ;
        busy = 1'b1 ;
    end
    s2:begin
        mux_sel = 2'b10 ; 
        load = 1'b0 ;
        ser_en = 1'b1 ;
        busy = 1'b1 ;
        if(ser_done)
        ser_en = 1'b0 ;
        else
        ser_en = 1'b1 ;
    end
    s3:begin
        mux_sel = 2'b11 ; 
        load = 1'b0 ;
        ser_en = 1'b0 ;
        busy = 1'b1 ;
    end
    s4:begin
        mux_sel = 2'b01 ; 
        load = 1'b0 ;
        ser_en = 1'b0 ;
        busy = 1'b1 ;
    end
    default:begin
        mux_sel = 2'b00 ; 
        load = 1'b1 ;
        ser_en = 1'b0 ;
        busy = 1'b0 ;
    end
    endcase
end

endmodule