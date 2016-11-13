`timescale 1ns / 1ps

module tb;

reg reset,clk,BTN2;
reg [2:0] baud_select;
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



systemUART sys0(
	.reset(reset),
	.clk(clk),
	.baud_select(baud_select),
	.Tx_DATA(Tx_DATA)
	.Tx_EN(Tx_EN),
	.Tx_WR(Tx_WR),
	.sample_ENABLE(sample_ENABLE),
	.TxD(TxD),
	.Tx_BUSY(Tx_BUSY)
);
	
initial begin
	clk=0;
	reset = 1;
	baud_select=7;
	#100 reset = 0;
	
	#100000 reset = 1;
	baud_select=6;
	#100 reset = 0;
	
	#100000 reset = 1;
	baud_select=5;
	#100 reset = 0;
	
		
	#100000 reset = 1;
	baud_select=4;
	#100 reset = 0;
	
	#100000 reset = 1;
	baud_select=3;
	#100 reset = 0;
	
	#100000 reset = 1;
	baud_select=2;
	#100 reset = 0;
	
	#100000 reset = 1;
	baud_select=1;
	#100 reset = 0;
	
	#100000 reset = 1;
	baud_select=0;
	#100 reset = 0;
	
	#100000 $finish;	

end
	
always #10 clk = ~ clk;

endmodule
