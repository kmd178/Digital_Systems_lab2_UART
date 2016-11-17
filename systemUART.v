`timescale 1ns / 1ps
module systemUART(
	input reset,
	input clk,
	input BTN2,
	output [7:0] Rx_DATA,
	output Rx_FERROR,
	output Rx_PERROR,
	output Rx_VALID,
	output Tx_BUSY,
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


assign Tx_EN=1;
assign Rx_EN=1;
wire TxD;
wire RxD=TxD;	
reg [7:0] message [3:0];
reg [1:0] CurrentSymbol=2'b11;
reg Tx_WR=1;
reg [7:0] Tx_DATA=8'b10101010;
reg [2:0] baud_select=3'b000;	
	
	
anti_bounce_reset kmd2(clk, reset, stabilizedRESET);
anti_bounce_reset kmd3(clk, BTN2 , stabilizedButton);
wire stabilizedRESET_compination= stabilizedButton | stabilizedRESET;//
uart_transmitter kmd2_1(stabilizedRESET_compination,clk,Tx_DATA,baud_select,Tx_EN,Tx_WR,TxD,Tx_BUSY);
uart_receiver kmd2_2(stabilizedRESET_compination,clk,baud_select,Rx_EN,RxD,Rx_DATA,Rx_FERROR,Rx_PERROR, Rx_VALID, an3, an2, an1, an0, a,b,c,d,e,f,g,dp);


////////////////////////////////////////


always @(posedge stabilizedRESET) 
	begin 
		message[0] <= 8'b10101010;   //AA//
		message[1] <= 8'b01010101;   //55//
		message[2] <= 8'b11001100;   //CC//
		message[3] <= 8'b10001001;   //89//
	end

reg Tx_BUSY_prev_state=0;
reg change_symbol;
always @(posedge clk) 
		if (Tx_BUSY== ~Tx_BUSY_prev_state)
			begin 
				Tx_BUSY_prev_state=Tx_BUSY;
				change_symbol=~Tx_BUSY;
			end
		else
			change_symbol=0;

always @(posedge clk, posedge stabilizedRESET_compination)
	if (stabilizedRESET_compination)
		begin
			CurrentSymbol=2'b0;
			Tx_DATA=message[CurrentSymbol];
			Tx_WR=1;
		end
	else if (change_symbol==1)  ///change to Tx_BUSY AGAIN
		begin
			CurrentSymbol=CurrentSymbol+1'b1;
			Tx_DATA=message[CurrentSymbol];
			Tx_WR=1;
		end
	else 
			Tx_WR=0;


always @(posedge stabilizedButton, posedge stabilizedRESET)
	if (stabilizedRESET)
	else if (stabilizedButton)
			baud_select=baud_select+1'b1;
			


endmodule
