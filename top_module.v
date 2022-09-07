module top_module #(parameter DATA_WIDTH = 8, REGFILE_ADD = 4)
(
    input  wire REF_CLK,
    input  wire RST,
    input  wire UART_CLK,
    input  wire RX_IN,
    output wire TX_OUT
);

wire                    SYNC_REF_RST_int;
wire                    SYNC_UART_RST_int;
wire [DATA_WIDTH-1:0]   rx_p_data_int;
wire                    rx_data_valid_int;
wire [DATA_WIDTH-1:0]   rx_p_data_int_sync;
wire                    rx_data_valid_int_sync;
wire [DATA_WIDTH-1:0]   tx_p_data_int;
wire                    tx_data_valid_int;
wire [DATA_WIDTH-1:0]   tx_p_data_int_sync;
wire                    tx_data_valid_int_sync;
wire                    tx_busy;
wire                    tx_busy_sync;
wire [DATA_WIDTH-1:0]   div_ratio;
wire                    tx_clk;
wire                    i_clk_en_int;
wire [DATA_WIDTH-1:0]   UART_Config;
wire [DATA_WIDTH*2-1:0] ALU_OUT_int;
wire                    ALU_OUT_VLD_int;
wire                    ALU_EN_int;
wire [3:0]              ALU_FUN_int;
wire [REGFILE_ADD-1:0]  Address_int;
wire                    WrEn_int;
wire                    RdEn_int;
wire [DATA_WIDTH-1:0]   WrData_int;
wire [DATA_WIDTH-1:0]   RdData_int;
wire                    RdData_Valid_int;
wire [DATA_WIDTH-1:0]   OP_A;
wire [DATA_WIDTH-1:0]   OP_B;
wire                    ALU_CLK;
wire                    gate_en;


///********************************************************///
//////////////////// Reset synchronizers /////////////////////
///********************************************************///

RST_SYNC u0_RST_SYNC (
    .CLK(REF_CLK),
    .RST(RST),
    .SYNC_RST(SYNC_REF_RST_int)
);

RST_SYNC u1_RST_SYNC (
    .CLK(UART_CLK),
    .RST(RST),
    .SYNC_RST(SYNC_UART_RST_int)
);

///********************************************************///
////////////////////// Data Synchronizer /////////////////////
///********************************************************///

DATA_SYNC u0_DATA_SYNC (
    .unsync_bus(rx_p_data_int),
    .CLK(REF_CLK), 
    .RST(SYNC_REF_RST_int), 
    .bus_enable(rx_data_valid_int),      // REMINDER: Destination CLK domain
    .sync_bus(rx_p_data_int_sync),
    .enable_pulse(rx_data_valid_int_sync)
);

DATA_SYNC u1_DATA_SYNC (
    .unsync_bus(tx_p_data_int),
    .CLK(tx_clk), 
    .RST(SYNC_UART_RST_int), 
    .bus_enable(tx_data_valid_int),      // REMINDER: Destination CLK domain
    .sync_bus(tx_p_data_int_sync),
    .enable_pulse(tx_data_valid_int_sync)
);

///********************************************************///
////////////////////// Bit Synchronizer /////////////////////
///********************************************************///

BIT_SYNC u0_BIT_SYNC (
    .ASYNC(tx_busy),
    .CLK(REF_CLK), 
    .RST(SYNC_REF_RST_int),
    .SYNC(tx_busy_sync)
);

///********************************************************///
//////////////////////// Clock Divider ///////////////////////
///********************************************************///

ClkDiv u0_ClkDiv (
    .i_ref_clk(UART_CLK), 
    .i_rst_n(SYNC_UART_RST_int), 
    .i_clk_en(i_clk_en_int),
    .i_div_ratio(div_ratio[3:0]),
    .o_div_clk(tx_clk)
);

///********************************************************///
/////////////////////////// UART /////////////////////////////
///********************************************************///

uart_top u0_uart_top (
    .tx_clk(tx_clk), 
    .rst(SYNC_UART_RST_int), 
    .par_typ(UART_Config[1]), 
    .par_en(UART_Config[0]), 
    .tx_data_valid(tx_data_valid_int_sync),
    .tx_p_data(tx_p_data_int_sync),
    .tx_out(TX_OUT), 
    .busy(tx_busy),
    .rx_clk(UART_CLK), 
    .rx_in(RX_IN), 
    //.rx_par_typ(), 
    //.rx_par_en(),
    .prescale(UART_Config[6:2]),
    .rx_p_data(rx_p_data_int),
    .rx_data_valid(rx_data_valid_int)
);

///********************************************************///
//////////////////// System Controller ///////////////////////
///********************************************************///

SYS_CTRL u0_SYS_CTRL (
    .CLK(REF_CLK),
    .RST(SYNC_REF_RST_int),
    .ALU_OUT(ALU_OUT_int),
    .OUT_Valid(ALU_OUT_VLD_int),
    .EN(ALU_EN_int),
    .ALU_FUN(ALU_FUN_int),
    .CLK_EN(gate_en),
    .Address(Address_int),
    .WrEn(WrEn_int),
    .RdEn(RdEn_int),
    .WrData(WrData_int),
    .RdData(RdData_int),
    .RdData_Valid(RdData_Valid_int),
    .RX_P_DATA(rx_p_data_int_sync),
    .RX_D_VLD(rx_data_valid_int_sync),
    .TX_P_DATA(tx_p_data_int),
    .TX_D_VLD(tx_data_valid_int),
    .Busy(tx_busy_sync),
    .clk_div_en(i_clk_en_int)
);

///********************************************************///
/////////////////////// Register File ////////////////////////
///********************************************************///

RegFile u0_RegFile (
    .CLK(REF_CLK),
    .RST(SYNC_REF_RST_int),
    .WrEn(WrEn_int),
    .RdEn(RdEn_int),
    .Address(Address_int),
    .WrData(WrData_int),
    .RdData(RdData_int),
    .RdData_VLD(RdData_Valid_int),
    .REG0(OP_A),
    .REG1(OP_B),
    .REG2(UART_Config),
    .REG3(div_ratio)
);

///********************************************************///
//////////////////////////// ALU /////////////////////////////
///********************************************************///
 
ALU u0_ALU (
    .A(OP_A), 
    .B(OP_B),
    .EN(ALU_EN_int),
    .ALU_FUN(ALU_FUN_int),
    .CLK(ALU_CLK),
    .RST(SYNC_REF_RST_int),  
    .ALU_OUT(ALU_OUT_int),
    .OUT_VALID(ALU_OUT_VLD_int)  
);

///********************************************************///
///////////////////////// Clock Gating ///////////////////////
///********************************************************///

CLK_GATE u0_CLK_GATE (
    .CLK_EN(gate_en),
    .CLK(REF_CLK),
    .GATED_CLK(ALU_CLK)
);

endmodule