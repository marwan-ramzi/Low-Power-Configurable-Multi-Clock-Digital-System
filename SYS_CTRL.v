module SYS_CTRL #(parameter DATA_WIDTH = 8 , REGFILE_ADD = 4 )
(
    input  wire                     CLK,
    input  wire                     RST,
    input  wire [DATA_WIDTH*2-1:0]  ALU_OUT,
    input  wire                     OUT_Valid,
    output wire                     EN,
    output wire [3:0]               ALU_FUN,
    output wire                     CLK_EN,
    output wire [REGFILE_ADD-1:0]   Address,
    output wire                     WrEn,
    output wire                     RdEn,
    output wire [DATA_WIDTH-1:0]    WrData,
    input  wire [DATA_WIDTH-1:0]    RdData,
    input  wire                     RdData_Valid,
    input  wire [DATA_WIDTH-1:0]    RX_P_DATA,
    input  wire                     RX_D_VLD,
    output wire [DATA_WIDTH-1:0]    TX_P_DATA,
    output wire                     TX_D_VLD,
    input  wire                     Busy,
    output wire                     clk_div_en
);

wire alu_out_done_int;
wire sys_ctrl_send_en_int;

sys_ctrl_rec u0_sys_ctrl_rec (
    .CLK(CLK),
    .RST(RST),
    .RX_P_DATA(RX_P_DATA),
    .RX_D_VLD(RX_D_VLD),
    .alu_out_done(alu_out_done_int),
    .EN(EN),         //ALU enable signal
    .ALU_FUN(ALU_FUN),
    .CLK_EN(CLK_EN),     //Clk gate enable
    .Address(Address),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .WrData(WrData),
    .clk_div_en(clk_div_en),
    .sys_ctrl_send_en(sys_ctrl_send_en_int)
);

sys_ctrl_send u0_sys_ctrl_send (
    .CLK(CLK),
    .RST(RST),
    .ALU_OUT(ALU_OUT),
    .OUT_Valid(OUT_Valid),
    .RdData(RdData),
    .RdData_Valid(RdData_Valid),
    .Busy(Busy),
    .sys_ctrl_send_en(sys_ctrl_send_en_int),
    .TX_P_DATA(TX_P_DATA),
    .TX_D_VLD(TX_D_VLD),
    .alu_out_done(alu_out_done_int)
);

endmodule
