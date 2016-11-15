`timescale 1ns / 1ps
module uart_transmitter(
input reset,   			//if its 0 the module is not working SAME AS ~Tx_EN
input clk,
input [7:0] Tx_DATA,		//contains the Bits that are set by the system to be transmitted
input [2:0] baud_select,//assigns the width of the timeslots bits use to be transmitted
input Tx_EN,   			//if its 0 the module is not working SAME AS ~RESET
input Tx_WR,				//It becomes 1 for one cycle to signal that data is ready to be transmitted
output reg TxD,					//Output bit
output reg Tx_BUSY);			//Signals 1 if the module is actively transmitting a bitstream

baud_rate_sampler_transmitter baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

wire Offstate= reset | (~Tx_EN); //Reset has the same exact use as ~Tx_EN in the current implementation

reg myNextBitstreamISready=0;  //needs to be a register because Tx_WR is a 1cycle signal that informs 
//next bitstream is ready for processing. Memory loading can initiate before the transmition is finished


///////////////////////////////////////////////////////////////////////bit_slot
reg [3:0] bit_slot;
always @(posedge Tx_sample_ENABLE, posedge Offstate) 
		if (Offstate) 
			bit_slot<=10;
		else if (Tx_BUSY==1'b1 | myNextBitstreamISready)  ///if the bitstream finished i am no longer Busy, so i stay in the same slot
																		  ///it needs myNextBitstreamISready knowledge beforehand if there is another bitsream to be transmitted
																			//so that it can proceed to the next bit_slot without delay.
			begin
				if (bit_slot==10)   //cycling on the 11th state
					bit_slot<=0;
				else
					bit_slot<=bit_slot+1'b1; 
			end
///////////////////////////////////////////////////bit_slot

always @(posedge Tx_sample_ENABLE, posedge Tx_WR)  
	begin
		if (Tx_WR)    								//System WILL ONLY signal through Tx_WR if Tx_BUSY is 0
			myNextBitstreamISready<=1'b1;    //Tx_WR is validly activated by the system during the transmition of the parity bit as well (bit_slot 9)
		else if (myNextBitstreamISready & (bit_slot==9 | bit_slot==10))//bitslot is 9 when bitstreams are assigned contineusly
			myNextBitstreamISready<=1'b0; 									//bitslot is 10 if there is a pause between transfers
//In current implementation: Its not possible for myNextBitstreamISready posedge to happen
//before systems gets a module not busy signal, Tx_BUSY=0.
	end

//Highly unlikely bug, if systems signals Tx_WR in sync with Tx_sample_ENABLE, the transmition will be delayed by 1 slot 
always @(posedge Tx_sample_ENABLE, posedge Offstate)  
	begin
		if (Offstate)
			Tx_BUSY<=1'b0;	
		else 
			if (myNextBitstreamISready & (bit_slot==9 | bit_slot==10)) 	
				Tx_BUSY<=1'b1;			
			else if (bit_slot==9)
				Tx_BUSY<=1'b0;		
	end

always @(*)
	case(bit_slot)
		0: TxD= 0;             //start bit
		1: TxD= Tx_DATA[0];    //0
		2: TxD= Tx_DATA[1];    //1
		3: TxD= Tx_DATA[2];    //2
		4: TxD= Tx_DATA[3];    //3
		5: TxD= Tx_DATA[4];    //4
		6: TxD= Tx_DATA[5];    //5
		7: TxD= Tx_DATA[6];    //6
		8: TxD= Tx_DATA[7];    //7
		9: TxD= ^Tx_DATA;      //parity_bit
		10: TxD= 1;            //stop_bit
		default: TxD= 1; //NEVER ACCESSED:Necessary for compiler not to make a latch
	endcase
endmodule
