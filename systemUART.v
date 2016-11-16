`timescale 1ns / 1ps
module systemUART(
	input reset,
	input clk,
	input clk2,
///input [2:0] baud_select,
	//input [7:0] Tx_DATA,
	input Tx_EN,
//	input Tx_WR,
	input Rx_EN,
	output [7:0] Rx_DATA,
	output Rx_FERROR,
	output Rx_PERROR,
	output Rx_VALID,
	output Tx_BUSY,
//	input BTN2,
	output an3,
	output an2,
	output an1,
	output an0,
	output a,
	output b,
	output c,
	output d,
	output e,
	output f,
	output g,
	output dp
);


wire TxD;
wire RxD=TxD;
////////////////////////////////////////
reg [7:0] message [3:0];

always @(posedge reset) 
	begin 
		message[0] <= 8'b10101010;   //AA//
		message[1] <= 8'b01010101;   //55//
		message[2] <= 8'b11001100;   //CC//
		message[3] <= 8'b10001001;   //89//
	end

reg [1:0] CurrentSymbol=2'b0;
reg Tx_WR=0;
reg [7:0] Tx_DATA;
always @(posedge clk, posedge reset)
	if (reset)
		CurrentSymbol=2'b0;
	else if (Tx_BUSY==0)
		begin
			Tx_DATA=message[CurrentSymbol];
			CurrentSymbol=CurrentSymbol+1'b1;
			Tx_WR=1;
		end
	else 
			Tx_WR=0;
///////////////////////////////////////			
reg [2:0] baud_select=3'b110;
			
//always @(posedge stabilizedButton, posedge stabilizedRESET, posedge clk)
//	if (stabilizedRESET)
//		begin
//			stabilizedRESET_2=1;
//			baud_select=2'b0;
//		end
//	else if (stabilizedButton)
//		begin
//			stabilizedRESET_2=1;
//			baud_select=baud_select+1'b1;
//		end
//	else 
//			stabilizedRESET_2=0;			
			
			
	
anti_bounce_reset kmd2(clk, reset, stabilizedRESET);
anti_bounce kmd3(clk, reset , BTN2, stabilizedButton);

uart_transmitter kmd2_1(stabilizedRESET_2,clk,Tx_DATA,baud_select,Tx_EN,Tx_WR,TxD,Tx_BUSY,Tx_sample_ENABLE);
uart_receiver kmd2_2(stabilizedRESET_2,clk,baud_select,stabilizedButton,Rx_EN,RxD,Rx_DATA,Rx_FERROR,Rx_PERROR, Rx_VALID, an3, an2, an1, an0, a,b,c,d,e,f,g,dp);  //carefull


endmodule
