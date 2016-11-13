`timescale 1ns / 1ps
module uart_transmitter(
input reset,   			//if its 0 the module is not working SAME AS Tx_EN
input clk,
input [7:0] Tx_DATA,		//contains the Bits that are set by the system to be transmitted
input [2:0] baud_select,//assigns the width of the timeslots bits use to be transmitted
input Tx_EN,   			//if its 0 the module is not working SAME AS RESET
input Tx_WR,				//It becomes 1 for one cycle to signal that data is ready to be transmitted
output TxD,					//Output bit
output Tx_BUSY);			//Signals 1 if the module is actively transmitting a bitstream

baud_rate_sampler baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

wire Offstate= reset | Tx_EN; //Reset has the same exact use as Tx_EN in the current implementation

//////////////////////////////////////////////////////////////////
always @(posedge Tx_sample_ENABLE,posedge Offstate)
	begin 
		if (Offstate==0) 
			16_counter=0;
		else 
			16_counter=16_counter+1'b1;
	end

wire bit_slot_enable=&(~(16_counter));

always @(posedge bit_slot_enable,posedge Offstate) 
		if (Offstate==0) 
			bit_slot=11;
		else if (Tx_BUSY==1'b1)  ///if the bitstream finished i am no longer Busy, so i stay in the same slot
			begin
				if (bit_slot==11)
					bit_slot=0;
				else
					bit_slot=bit_slot+1'b1; ///needs to get 0 after the 12th state.
			end

/////////////////////////////////////////////////////////////////
reg myNextBitstreamISready=0;  //needs to be a register because Tx_WR is a 1cycle signal that informs 
//next bitstream is ready for processing. The loading of the memory can happen before the transmition is finished

//Highly unlikely bug, if systems signals Tx_WR in sync with bit_slot_enable, the transmition will be delayed by 1 slot 
always @(posedge bit_slot_enable, posedge Tx_WR)  
	begin
		if (Tx_WR==1)    								//System WILL ONLY signal through Tx_WR if Tx_BUSY is 0
			myNextBitstreamISready=1'b1;
		else if (myNextBitstreamISready==1'b1)  
		//Its not possible for myNextBitstreamISready to be 1 before systems gets a module not busy signal
			Tx_BUSY=1'b1;	
			myNextBitstreamISready==1'b0;
		else if (bit_slot==11)
			Tx_BUSY=1'b0;		
			
	end

always @(*)
	case(bit_slot)
		0: Tx_WR= 0;
		1: Tx_WR= Tx_DATA[0];
		2: Tx_WR= Tx_DATA[1];
		3: Tx_WR= Tx_DATA[2];
		4: Tx_WR= Tx_DATA[3];
		5: Tx_WR= Tx_DATA[4];
		6: Tx_WR= Tx_DATA[5];
		7: Tx_WR= Tx_DATA[6];
		8: Tx_WR= Tx_DATA[7];
		9: Tx_WR= ^Tx_DATA;
		10: Tx_WR= 1;
		11: Tx_WR= 1;
	endcase


endmodule
