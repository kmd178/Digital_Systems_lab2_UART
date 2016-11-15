`timescale 1ns / 1ps
module uart_receiver(
	input reset,              //if its 0 the module is not working SAME AS ~RESET
	input clk,
	input [2:0] baud_select,  //assigns the width of the timeslots bits use to be transmitted
	input Rx_EN,      		  //if its 0 the module is not working SAME AS ~RESET
	input RxD,
	output [7:0] Rx_DATA,
	output Rx_FERROR, // Framing Error //
	output Rx_PERROR, // Parity Error //
	output Rx_VALID); // Rx_DATA is Valid //

baud_rate_sampler_transmitter baud_controller_rx_instance(reset, clk, baud_select, Rx_sample_ENABLE);

wire Offstate= reset | (~Rx_EN); //Reset has the same exact use as ~Rx_EN in the current implementation
reg [3:0] samples_counter;
reg [7:0] TMP_DATA;
reg TMP_PERROR; 
reg transmittionFirstSlot=1'b0; //Flags the state which the samples_counter is currently counting samples in the first Slot

always @(posedge Rx_sample_ENABLE)
	if ( (bit_slot==10 & RxD==0 & transmittionFirstSlot==0) | (bit_slot==11 & RxD==0 & transmittionFirstSlot==0) )
		samples_counter=7;  //might need to be 6 instead
	else
		samples_counter= samples_counter+1;

wire middleSlot_sample=& samples_counter;
	
always @(posedge Rx_sample_ENABLE)
	if ( (bit_slot==10 & RxD==0 & transmittionFirstSlot==0) | (bit_slot==11 & RxD==0 & transmittionFirstSlot==0) )
		transmittionFirstSlot=1'b1;
	else if (middleSlot_sample)
		transmittionFirstSlot=1'b0;

///////////////////////////////////////////////////////////////////////bit_slot
reg [3:0] bit_slot;
always @(posedge middleSlot_sample, posedge Offstate) 
	begin
		if (Offstate | (bit_slot==10 & RxD==0) | (bit_slot==11 & RxD==0)) 
			bit_slot<=0;
		else if (~(bit_slot==11))
			bit_slot<=bit_slot+1'b1; 
	end
///////////////////////////////////////////////////bit_slot

always @(posedge clk)
	begin
		if (bit_slot==10)
			begin
				RxD<=TMP_DATA;				
				Rx_PERROR<=TMP_PERROR;
				Rx_VALID<=(TMP_PERROR | TMP_FERROR);
			end
	end

always @(*)
	case(bit_slot)
		//0:  				          //start bit
		1:  TMP_DATA[0]=RxD;    //0
		2:  TMP_DATA[1]=RxD;    //1
		3:  TMP_DATA[2]=RxD;    //2
		4:  TMP_DATA[3]=RxD;    //3
		5:  TMP_DATA[4]=RxD;    //4
		6:  TMP_DATA[5]=RxD;    //5
		7:  TMP_DATA[6]=RxD;    //6
		8:  TMP_DATA[7]=RxD;    //7
		9:  TMP_PERROR= (RxD==^TMP_DATA);   //parity_bit
		10: Rx_FERROR= ~RxD;            //stop_bit should be 1, if its 0 then there is an error
		//default:  //NEVER ACCESSED:Necessary for compiler not to make a latch
	endcase

endmodule