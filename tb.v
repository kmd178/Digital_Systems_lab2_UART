`timescale 1ns / 1ps

module tb;


//wire a,b,c,d,e,f,g,dp,CLKDV;

//FourDigitLEDdriver sys0(
//	.reset(reset),
//	.clk(clk),
//	.BTN2(BTN2),
//	.an3(an3),
//	.an2(an2),
//	.an1(an1),
//	.an0(an0),
//	.a(a),
//	.b(b),
//	.c(c),
//	.d(d),
//	.e(e),
//	.f(f),
//	.g(g),
//	.dp(dp),
//	.CLKDV(CLKDV),
//	.stabilizedRESET(stabilizedRESET),
//	.stabilizedButton(stabilizedButton)
//);//

reg reset,clk,BTN2,clk2;
reg [2:0] baud_select;
reg [7:0] Tx_DATA;
reg Tx_WR,Tx_EN,Rx_EN;


systemUART sys0(
	.reset(reset),
	.clk(clk),
	.clk2(clk2),
	.baud_select(baud_select),
	.Tx_DATA(Tx_DATA),
	.Tx_EN(Tx_EN),
	.Tx_WR(Tx_WR),
	.Rx_EN(Rx_EN),
	.Rx_DATA(Rx_DATA),
	.Rx_FERROR(Rx_FERROR), 
	.Rx_PERROR(Rx_PERROR),
	.Rx_VALID(Rx_VALID),
	.Tx_BUSY(Tx_BUSY)
);
	
	
	
initial begin
	clk=0;
	clk2=0;
	reset = 1;
	baud_select=7;
	Tx_EN=1;
	Rx_EN=1;
	
	
	Tx_DATA=8'b10110101;

	#100 reset = 0;
	Tx_WR=1;
	#10 Tx_WR=0;

	#99240
	//Tx_WR is validly activated by the system during the transmition of the parity bit as well (bit_slot 9) time=99240
	Tx_DATA=8'b11101110;
	Tx_WR=1;
	#10 Tx_WR=0;
	
	
	#100000 Tx_EN = 0;
	

	#10000 $finish;	

end
	
always #10 clk = ~ clk;

always #10 clk2 = ~ clk2;

endmodule
