module sys_ctrl_rec #(parameter DATA_WIDTH = 8, REGFILE_ADD = 4 )
(
    input  wire                     CLK,
    input  wire                     RST,
    input  wire [DATA_WIDTH-1:0]    RX_P_DATA,
    input  wire                     RX_D_VLD,
    input  wire                     alu_out_done,
    output reg                      EN,         //ALU enable signal
    output reg  [3:0]               ALU_FUN,
    output reg                      CLK_EN,     //Clk gate enable
    output reg  [REGFILE_ADD-1:0]   Address,
    output reg                      WrEn,
    output reg                      RdEn,
    output reg  [DATA_WIDTH-1:0]    WrData,
    output reg                      clk_div_en,
    output reg                      sys_ctrl_send_en
);
// int sig to read the data from regfile the signal'll come form sys_ctrl_rec

reg [2:0] next_state, current_state;
reg [1:0] final_frame;
reg [1:0] fin;
reg [1:0] count;
reg [3:0] add_regfile;

parameter [2:0] idle_state       = 3'b000 ;
parameter [2:0] cmd_rd     = 3'b001 ;
parameter [2:0] add_rd     = 3'b010 ;
parameter [2:0] data_rd    = 3'b011 ;
parameter [2:0] alu_fun_rd = 3'b100 ;

always @(posedge CLK or negedge RST)
begin
    if(!RST)
    current_state <= idle_state ;
    else
    current_state <= next_state ;
end

always @(*)
begin
    case(current_state)
    idle_state: 
    begin
        if(RX_D_VLD)
        next_state = cmd_rd ;
        else
        next_state = idle_state ;
    end
    cmd_rd: 
    begin
        //if(RX_D_VLD)
        //begin
        case(RX_P_DATA)
        'b1010_1010:
        begin
            next_state = add_rd ;
            //final_frame = 2'b10 ;
        end
        'b1011_1011:
        begin
            next_state = add_rd ;
            //final_frame = 2'b01 ;
        end
        'b1100_1100:
        begin
            next_state = data_rd ;
            //final_frame = 2'b11 ;
        end
        'b1101_1101:
        begin
            next_state = alu_fun_rd ;
            //final_frame = 2'b01 ;
        end
        default:
        begin
            next_state = cmd_rd ;
            //final_frame = 2'b01 ;
        end
        endcase
        //end
        //else
        //next_state = cmd_rd ;
    end
    add_rd: 
    begin
        if(RX_D_VLD)
        begin
        if(final_frame == 2'b10)
        next_state = data_rd ;
        else
        begin
            if(RX_D_VLD)
            next_state = cmd_rd ;
            else
            next_state = idle_state ;
        end
        end
        else
        next_state = add_rd ; 
    end
    data_rd: 
    begin
        if (RX_D_VLD)
        begin
            if (count == 2'b10)
            begin
                if (final_frame == 2'b11)
                next_state = alu_fun_rd ;
                else
                begin
                    if(RX_D_VLD)
                    next_state = cmd_rd ;
                    else
                    next_state = idle_state ;
                end
            end
            else
            begin
                if(count == 2'b00)          //next_state = data_rd ;
                next_state = cmd_rd ;
                else 
                next_state = data_rd ;       
            end
        end
        else
        next_state = data_rd ;  
    end
    alu_fun_rd: 
    begin
        if(alu_out_done)
        begin
            if(RX_D_VLD)
            next_state = cmd_rd ;
            else
            next_state = idle_state ;
        end
        else
        next_state = alu_fun_rd ;
    end
    default: 
    begin
        next_state = idle_state ;
    end
    endcase
end

always @(*)
begin
    EN         = 1'b0 ;   // ALU enable
    ALU_FUN    =  'b0 ;   // width = 4
    CLK_EN     = 1'b0 ;   // Clk gate enable
    Address    =  add_regfile ; // width = 4
    WrEn       = 1'b0 ;
    RdEn       = 1'b0 ;
    WrData     =  'b0 ;   // width = 8
    clk_div_en = 1'b1 ;
    final_frame = fin ;
    sys_ctrl_send_en = 'b1 ;
    case(current_state)
    idle_state: 
    begin
        if(RX_D_VLD)
        begin
        CLK_EN     = 1'b1 ;
        clk_div_en = 1'b1 ;
        end
        else
        begin
        CLK_EN     = 1'b0 ;
        clk_div_en = 1'b1 ;
        sys_ctrl_send_en = 'b0 ;
        end
    end
    cmd_rd: 
    begin
        case(RX_P_DATA)
        'b1010_1010:
        begin
            CLK_EN     = 1'b1 ;
            clk_div_en = 1'b1 ;
            final_frame = 2'b10 ;
        end
        'b1011_1011:
        begin
            CLK_EN     = 1'b1 ;
            clk_div_en = 1'b1 ;
            final_frame = 2'b01 ;
        end
        'b1100_1100:
        begin
            CLK_EN     = 1'b1 ;
            clk_div_en = 1'b1 ;
            final_frame = 2'b11 ;
        end
        'b1101_1101:
        begin
            CLK_EN     = 1'b1 ;
            clk_div_en = 1'b1 ;
            final_frame = 2'b01 ;
        end
        default:
        begin
            CLK_EN     = 1'b1 ;
            clk_div_en = 1'b1 ;
            final_frame = 2'b01 ;
        end
        endcase
    end
    add_rd: 
    begin
        if(RX_D_VLD)
        begin
        EN         = 1'b0 ;
        ALU_FUN    =  'b0 ; // width = 4
        CLK_EN     = 1'b1 ;
        Address    =  RX_P_DATA[3:0] ; // width = 4
        WrData     =  'b0 ; // width = 8
        clk_div_en = 1'b1 ;
        if(final_frame == 2'b10)
        begin
            WrEn       = 1'b1 ;
            RdEn       = 1'b0 ;
        end
        else
        begin
            WrEn       = 1'b0 ;
            RdEn       = 1'b1 ;
        end

        end
        else
        begin
            EN         = 1'b0 ;
            ALU_FUN    =  'b0 ; // width = 4
            CLK_EN     = 1'b1 ;
            Address    =  add_regfile ; // width = 4
            WrEn       = 1'b0 ;
            RdEn       = 1'b0 ;
            WrData     =  'b0 ; // width = 8
            clk_div_en = 1'b1 ;
        end
    end
    data_rd: 
    begin
        if (RX_D_VLD)
        begin
            if (final_frame == 2'b11)
            begin
            CLK_EN     = 1'b1 ;
            WrEn       = 1'b1 ;
            RdEn       = 1'b0 ;
            clk_div_en = 1'b1 ;
            
            if(count == 2'b01)
            begin
            Address    =  'b0000 ; // width = 4
            WrData     =  RX_P_DATA ; // width = 8
            end
            else
            begin
            Address    =  'b0001 ; // width = 4
            WrData     =  RX_P_DATA ; // width = 8
            end

            end
            else
            begin
            EN         = 1'b0 ;
            ALU_FUN    =  'b0 ; // width = 4
            CLK_EN     = 1'b1 ;
            Address    =  add_regfile ; // width = 4
            WrEn       = 1'b1 ;
            RdEn       = 1'b0 ;
            WrData     =  RX_P_DATA ; // width = 8
            clk_div_en = 1'b1 ;
            end
        end
        else
        begin
        CLK_EN     = 1'b1 ;
        WrEn       = 1'b0 ; //WrEn       = 1'b1 ;
        RdEn       = 1'b0 ;
        clk_div_en = 1'b1 ;
        end  
    end
    alu_fun_rd: 
    begin
        if (RX_D_VLD)
        begin
        EN         = 1'b1 ;
        ALU_FUN    =  RX_P_DATA[3:0] ; // width = 4
        CLK_EN     = 1'b1 ;
        Address    =  add_regfile ; // width = 4
        WrEn       = 1'b0 ;
        RdEn       = 1'b0 ;
        WrData     =  'b0 ; // width = 8
        clk_div_en = 1'b1 ;
        end
        else
        begin
        EN         = 1'b0 ; // EN         = 1'b1 ;
        ALU_FUN    =  'b0 ; // width = 4
        CLK_EN     = 1'b1 ;
        Address    =  add_regfile ; // width = 4
        WrEn       = 1'b0 ;
        RdEn       = 1'b0 ;
        WrData     =  'b0 ; // width = 8
        clk_div_en = 1'b1 ;
        end
    end
    default: 
    begin
        EN         = 1'b0 ;
        ALU_FUN    =  'b0 ; // width = 4
        CLK_EN     = 1'b1 ;
        Address    =  add_regfile ; // width = 4
        WrEn       = 1'b0 ;
        RdEn       = 1'b0 ;
        WrData     =  'b0 ; // width = 8
        clk_div_en = 1'b1 ;
    end
    endcase
end

always @(posedge CLK or negedge RST)
begin
    if(!RST)
    add_regfile <= 'b100;
    else if( (WrEn == 1) && (count == 'b01) )
    add_regfile <= Address;
end

always @(posedge CLK or negedge RST)
begin
    if(!RST)
    fin <= 'b0 ;
    else
    fin <= final_frame ;
end


/*
always @(posedge CLK or negedge RST)
begin
    if(!RST)
    alu_cmdreg <= 'b0;
    else if( EN == 1 )
    alu_cmdreg <= ALU_FUN;
end
*/

always @(posedge CLK or negedge RST)
begin
    if(!RST)
    count <= 'b0;
    else if(count == final_frame)
    count <= 'b0;
    else if (RX_D_VLD)
    count <= count + 'b1;
end

endmodule
