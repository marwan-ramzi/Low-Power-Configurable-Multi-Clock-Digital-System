module sys_ctrl_send #(parameter DATA_WIDTH = 8)
(
    input  wire                     CLK,
    input  wire                     RST,
    input  wire [DATA_WIDTH*2-1:0]  ALU_OUT,
    input  wire                     OUT_Valid,
    input  wire [DATA_WIDTH-1:0]    RdData,
    input  wire                     RdData_Valid,
    input  wire                     Busy,
    input  wire                     sys_ctrl_send_en,
    output reg  [DATA_WIDTH-1:0]    TX_P_DATA,
    output wire /*reg*/             TX_D_VLD,
    output reg                      alu_out_done
);

// int sig to read the data from regfile the signal'll come form sys_ctrl_rec

reg [1:0] next_state, current_state;

reg [5:0]  count ;
reg        cnt_en ;
reg        VLD ;
reg [15:0] out_hold ;
reg        hold ;

parameter [1:0] idle    = 2'b00 ;
parameter [1:0] rd_cmd  = 2'b01 ;
parameter [1:0] alu_res = 2'b10 ;
parameter [1:0] send    = 2'b11 ;

always @(posedge CLK or negedge RST)
begin
    if(!RST)
    current_state <= idle ;
    else
    current_state <= next_state ;
end

always @(*)
begin
    case(current_state)
    idle:
    begin
        if(sys_ctrl_send_en)
        next_state = rd_cmd ;
        else
        next_state = idle ;
    end
    rd_cmd:
    begin
        if(RdData_Valid && !Busy)     //if(RdData_Valid && !Busy)
        next_state = send ;           //next_state = send ;
        else if (Busy)                //else if (OUT_Valid && !Busy) //else if (OUT_Valid && !Busy)
        next_state = alu_res ;        //next_state = alu_res ;
        else                          //else                        //else if (Busy)
        next_state = rd_cmd ;         //next_state = rd_cmd ;
    end
    alu_res:
    begin
        if (!Busy && (count == 6'b100100) ) //if (!Busy)
        next_state = idle ;
        else
        next_state = alu_res ;
    end
    send:
    begin
        if(Busy)
        next_state = idle ;
        else
        next_state = send ;
    end
    //default:
    //begin
    //    next_state = idle ;
    //end
    endcase
end
   
always @(*)
begin
    hold = 'b0 ;
    case(current_state)
    idle:
    begin
        TX_P_DATA    = 'b0 ;
        //TX_D_VLD     = 'b0 ;
        VLD     = 'b0 ;
        alu_out_done = 'b0 ;
    end
    rd_cmd:
    begin
        if(RdData_Valid && !Busy)
        begin
        TX_P_DATA    = RdData ;
        //TX_D_VLD     = 'b1 ;
        VLD     = 'b1 ;
        alu_out_done = 'b0 ;
        end
        else if (OUT_Valid && !Busy)
        begin
        TX_P_DATA    = ALU_OUT[7:0] ;
        //TX_D_VLD     = 'b1 ;
        VLD     = 'b1 ;
        alu_out_done = 'b0 ; //alu_out_done = 'b1 ;
        end
        else
        begin
        TX_P_DATA    = out_hold[7:0] ;
        //TX_D_VLD     = 'b0 ;
        VLD     = 'b0 ;
        alu_out_done = 'b0 ;
        end
    end
    alu_res:
    begin
        if (!Busy) //if (!Busy && (count == 6'b100100) )
        begin
        TX_P_DATA    = out_hold[15:8] ;
        //TX_D_VLD     = 'b1 ;
        VLD     = 'b1 ;
        alu_out_done = 'b1 ;
        end
        else
        begin
        TX_P_DATA    = out_hold[15:8] ;
        //TX_D_VLD     = 'b0 ;
        VLD     = 'b0 ;
        alu_out_done = 'b0 ;
        end
    end
    send:
    begin
        TX_P_DATA    = RdData ;
        //TX_D_VLD     = 'b1 ;
        VLD     = 'b1 ;
        hold = 'b1 ;
        alu_out_done = 'b0 ;
    end
    /*
    default:
    begin
        TX_P_DATA    = 'b0 ;
        //TX_D_VLD     = 'b0 ;
        VLD     = 'b0 ;
        alu_out_done = 'b0 ;
    end*/
    endcase
end
/*
always @ (posedge CLK or negedge RST)
begin
    if (!RST)
    begin
    cnt_en <= 'b0 ;
    count <= 'b0 ;
    end
    else if (VLD)
    cnt_en <= 1'b1 ;
end
*/
always @ (posedge CLK or negedge RST)
begin
    if (!RST)
    begin
    cnt_en <= 'b0 ;
    count <= 'b0 ;
    end
    else if (VLD)
    cnt_en <= 1'b1 ;
    else if (cnt_en && !Busy) //if (cnt_en)
    count <= count + 1'b1 ;
    else if( (count == 6'b100100) && !Busy ) //if (count == 6'b100100)
    begin
    count <= 'b0 ;
    cnt_en <= 'b0 ;
    end
end
/*
always @ (posedge CLK or negedge RST)
begin
    if (!RST)
    begin
    count <= 'b0 ;
    cnt_en <= 'b0 ;
    end
    else if( (count == 6'b100100) && !Busy ) //if (count == 6'b100100)
    begin
    count <= 'b0 ;
    cnt_en <= 'b0 ;
    end

end
*/
always @(posedge CLK or negedge RST)
begin
    if (!RST)
    out_hold <= 'b0;
    else if (OUT_Valid)
    out_hold <= ALU_OUT ;
end

assign TX_D_VLD = (VLD) ? hold : cnt_en ; //cnt_en ; (VLD) ? VLD : cnt_en ;

endmodule
