`timescale 1ns / 1ps

module LEDdecoder(
	input [3:0] char,
	output reg [7:0] LED
);
always @(*)
	case(char)
	  0: LED = 8'b00000011; //0//
	  1: LED = 8'b10011111; //1//
	  2: LED = 8'b00100101; //2
	  3: LED = 8'b00001101; //3
	  4: LED = 8'b10011001; //4
	  5: LED = 8'b01001001; //5
	  6: LED = 8'b01000001; //6
	  7: LED = 8'b00011111; //7
	  8: LED = 8'b00000001; //8
	  9: LED = 8'b00001001; //9//
	  10: LED = 8'b00000101; //a//
	  11: LED = 8'b11000001; //b
	  12: LED = 8'b01100011; //C
	  13: LED = 8'b10000101; //d
	  14: LED = 8'b01100001; //E
	  15: LED = 8'b01110001; //F//
	  default: LED = 8'b0000000;
endcase
endmodule
