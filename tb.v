	`timescale 1ns / 1ps

module tb;


//wire a,b,c,d,e,f,g,dp,CLKDV;

//FourDigitLEDdriver sys0(
//	.reset(reset),
//	.clk(clk),

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

reg reset,clk,BTN2;
wire [7:0] Rx_DATA; //

systemUART sys0(
	.reset(reset),
	.clk(clk),
	.BTN2(BTN2),
	.Rx_DATA(Rx_DATA),
	.Rx_FERROR(Rx_FERROR), 
	.Rx_PERROR(Rx_PERROR),
	.Rx_VALID(Rx_VALID),
	.Tx_BUSY(Tx_BUSY),
	.an3(an3),
	.an2(an2),
	.an1(an1),
	.an0(an0),
	.a(a), 
	.b(b), 
	.c(c), 
	.d(d),
	.e(e), 
	.f(f), 
	.g(g),
	.dp(dp)
);
	
	
	
initial begin

	BTN2=0;
	clk=0;////
	reset = 1;////
	
	#10000 reset = 0;
	#30000000 BTN2=1;	
	#10000 BTN2=0;
	#30000000 BTN2=1;
	#10000 BTN2=0;
	#30000000 BTN2=1;
	#10000 BTN2=0;
//	#1000000 BTN2 = 1;
//	
//	#100000 BTN2 = 0;
//
//	#1000000 BTN2 = 1;
//	
//	#100000 BTN2 = 0;
//	
//	#1000000 BTN2 = 1;
//	
//	#10000 BTN2 = 0;

	#200000000 $stop;	

end
	
always #10 clk = ~ clk;

endmodule
