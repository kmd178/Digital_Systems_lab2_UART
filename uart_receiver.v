`timescale 1ns / 1ps
module uart_receiver(
	input reset,              //if its 0 the module is not working SAME AS ~RESET
	input clk,
	input [2:0] baud_select,  //assigns the width of the timeslots bits use to be transmitted
	input Rx_EN,      		  //if its 0 the module is not working SAME AS ~RESET
	input RxD,
	output reg [7:0] Rx_DATA,
	output reg Rx_FERROR, // Framing Error //
	output reg Rx_PERROR, // Parity Error //
	output reg Rx_VALID,
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
	
	); // Rx_DATA is Valid //

baud_rate_sampler_receiver baud_controller_rx_instance(reset, clk, baud_select, Rx_sample_ENABLE);

wire Offstate= reset | (~Rx_EN); //Reset has the same exact use as ~Rx_EN in the current implementation
reg [3:0] samples_counter=0;
reg [7:0] TMP_DATA;
reg TMP_PERROR; 
reg transmittionFirstSlot=1'b0; //Flags the state which the samples_counter is currently counting samples in the first Slot
reg [3:0] bit_slot=10;

always @(posedge Rx_sample_ENABLE)
	if ( bit_slot==10 & RxD==0 & transmittionFirstSlot==0 )
		samples_counter<=7;  //might need to be 6 instead
	else
		samples_counter<= samples_counter+1;

wire middleSlot_sample=& samples_counter;
	
always @(posedge Rx_sample_ENABLE)
	if ( bit_slot==10 & RxD==0 & transmittionFirstSlot==0 )
		transmittionFirstSlot=1'b1;
	else if (middleSlot_sample)
		transmittionFirstSlot=1'b0;
		
wire TMP_DATA_PARITY=^TMP_DATA;
///////////////////////////////////////////////////////////////////////bit_slot

always @(posedge middleSlot_sample, posedge Offstate) 
	begin
		if (Offstate)
			begin

				bit_slot<=10;
				TMP_DATA<=0;
				TMP_PERROR<=0;
				Rx_PERROR<=0;
				Rx_FERROR<=0;
				Rx_VALID<=0;
			end
		else if (bit_slot==10 & RxD==0) 
			begin

				bit_slot<=0;
				TMP_DATA<=0;
				TMP_PERROR<=0;
				Rx_VALID<=0;
			end
		else if (bit_slot==8)
			begin

				TMP_PERROR<= ~(RxD==TMP_DATA_PARITY); //XAND: If not similar -> 1
				bit_slot<=bit_slot+1'b1; 
			end
		else if (bit_slot==9)
			begin

				bit_slot<=bit_slot+1'b1;
				Rx_DATA<=TMP_DATA;				
				Rx_PERROR<=TMP_PERROR;
				Rx_FERROR<=~RxD;
				Rx_VALID<= ~(TMP_PERROR | ~RxD);
			end
		else if (~(bit_slot==10))
			begin
	
				TMP_DATA[bit_slot]<= RxD;
				bit_slot<=bit_slot+1'b1; 
			end
	end

wire [7:0] Led; //
wire [3:0] char;
wire CLK0;
assign {a,b,c,d,e,f,g,dp}=Led; //Dividing the 8 bit decoded output to the assigned segment registers that control the LED character displayed	


   DCM #(
      .SIM_MODE("SAFE"),  // Simulation: "SAFE" vs. "FAST", see "Synthesis and Simulation Design Guide" for details
      .CLKDV_DIVIDE(16.0), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                          //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      .CLKFX_DIVIDE(1),   // Can be any integer from 1 to 32
      .CLKFX_MULTIPLY(4), // Can be any integer from 2 to 32
      .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
      .CLKIN_PERIOD(0.0),  // Specify period of input clock
      .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift of NONE, FIXED or VARIABLE
      .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
      .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                            //   an integer from 0 to 15
      .DFS_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for frequency synthesis
      .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
      .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, TRUE or FALSE
      .FACTORY_JF(16'hC080),   // FACTORY JF values
      .PHASE_SHIFT(0),     // Amount of fixed phase shift from -255 to 255
      .STARTUP_WAIT("FALSE")   // Delay configuration DONE until DCM LOCK, TRUE/FALSE
   ) DCM_inst (
      .CLK0(CLK0),     // 0 degree DCM CLK output
      .CLKDV(CLKDV),   // Divided DCM CLK out (CLKDV_DIVIDE)
      .CLKFB(CLK0),   // DCM clock feedback
      .CLKIN(clk),   // Clock input (from IBUFG, BUFG or DCM)
      .RST(reset)        // DCM asynchronous reset input
   );

ledDataFeeder kmd1(CLKDV,reset,Rx_DATA,Rx_VALID,char,an0,an1,an2,an3);
LEDdecoder kmd(char,Led);
	
	
///////////////////////////////////////////////////bit_slot


//always @(*)
//	case(bit_slot)
//		//0:  				          //start bit
//		1:  TMP_DATA[0]=RxD;    //0
//		2:  TMP_DATA[1]=RxD;    //1
//		3:  TMP_DATA[2]=RxD;    //2
//		4:  TMP_DATA[3]=RxD;    //3
//		5:  TMP_DATA[4]=RxD;    //4
//		6:  TMP_DATA[5]=RxD;    //5
//		7:  TMP_DATA[6]=RxD;    //6
//		8:  TMP_DATA[7]=RxD;    //7
//		9:  TMP_PERROR= (RxD==^TMP_DATA);   //parity_bit
//		10: Rx_FERROR= ~RxD;            //stop_bit should be 1, if its 0 then there is an error
//		//default:  //NEVER ACCESSED:Necessary for compiler not to make a latch
//	endcase

endmodule