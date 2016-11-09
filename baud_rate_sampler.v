module baud_rate_sampler(  ///have to implement different for reciever and transmitter, with different adders and clocks.
		input reset,
		input clk,
		input [2:0] baud_select,
		output reg sample_ENABLE
    );
	 

	 
		//We assume assume that a maximum possible FPGA clock used is 1ghz.(30bits)
//		parameter systemclockfrequency= 50000000;  //must be changed according to the FPGA system used.
//		parameter Clocks_Baud_Rate_8= systemclockfrequency/115200; //The floating part of the division is lost, leading to an error in the calculation of the actual rate
//		parameter Clocks_Baud_Rate_7= systemclockfrequency/57600;  //The greater the bitrate, the bigger the error leading to an out of sync function
//		parameter Clocks_Baud_Rate_6= systemclockfrequency/38400;
//		parameter Clocks_Baud_Rate_5= systemclockfrequency/19200;
//		parameter Clocks_Baud_Rate_4= systemclockfrequency/9600;
//		parameter Clocks_Baud_Rate_3= systemclockfrequency/4800;
//		parameter Clocks_Baud_Rate_2= systemclockfrequency/1200;
//		parameter Clocks_Baud_Rate_1= systemclockfrequency/300; //The number generated here is the largest and judges the bit width of the counter needed to calculate clocks
//		reg counter[21:0];


//		parameter systemclockfrequency= 50000000;  //must be changed according to the FPGA system used.
//		parameter Clocks_Baud_Rate_8= 000000000110110010;   //434.027777778 clocks until enable signal sent
//		parameter Clocks_Baud_Rate_7= 000000001101100100;   //868.055555556
//		parameter Clocks_Baud_Rate_6= 000000010100010110;   //1302.08333333
//		parameter Clocks_Baud_Rate_5= 000000101000101100;   //2604.16666667
//		parameter Clocks_Baud_Rate_4= 000001010001011000;   //5208.33333333
//		parameter Clocks_Baud_Rate_3= 000010100010110001;   //10416.6666667
//		parameter Clocks_Baud_Rate_2= 001010001011000011;   //41666.6666667
//		parameter Clocks_Baud_Rate_1= 101000101100001011; 	 //166666.666667 
		reg [17:0] counter; // TOTAL OF 18 BINARY CHARACTERS TO represent integer part of Clocks_Baud_Rate_1
		//reg [17:0] baud_select_table [7:0];
		
		always @(posedge clk, posedge reset) 
			begin
				if (reset)
					counter<=0;	
				else if (sample_ENABLE)
					counter<=0;
				else 
					counter<=counter+ 1'b1;
			end
		
//		wire sample_Enable = & (counter ^~ baud_select_table[baud_select]) ;
	
		// why cant i assign memory using always @(*); 
		// because it referes to all possible left hand side changes, which i dont have any because they are constants, so which block is never accesed.
		
		// should baud_select_table be a register?
		// should be register, compiler will  make the correct choice and put it into blockrams
		
//		initial
//			begin
//				 baud_select_table[0]<= 18'b101000101100001011;
//				 baud_select_table[1]<= 18'b001010001011000011;
//				 baud_select_table[2]<= 18'b000010100010110001;
//				 baud_select_table[3]<= 18'b000001010001011000;
//				 baud_select_table[4]<= 18'b000000101000101100;
//				 baud_select_table[5]<= 18'b000000010100010110;
//				 baud_select_table[6]<= 18'b000000001101100100;
//				 baud_select_table[7]<= 18'b000000000110110010;
//			end
		
//It works but why does my sample_ENABLE have to be a register? 
		always @(*)
			case(baud_select)
				0: sample_ENABLE= &(counter^~18'b101000101100001011);
				1: sample_ENABLE= &(counter^~18'b001010001011000011);
				2: sample_ENABLE= &(counter^~18'b000010100010110001);
				3: sample_ENABLE= &(counter^~18'b000001010001011000);
				4: sample_ENABLE= &(counter^~18'b000000101000101100);
				5: sample_ENABLE= &(counter^~18'b000000010100010110);
				6: sample_ENABLE= &(counter^~18'b000000001101100100);
				7: sample_ENABLE= &(counter^~18'b000000000110110010);
				default sample_ENABLE=0;
			endcase
		
		
		
//Project has Baud_rate preconfigured before the transfer of the bits.
//In case i want Async Baud_rate change: (This is necessary for optional scaling of the baud_rate during the transfer of a bitstream)	
//		//Baud_select flip flop, (i am not sure if i should use clock or sample_ENABLE)
//		always @(posedge sample_ENABLE, posedge reset) 
//			begin
//				if (reset)
//					baud_select_prev_state<=0;	
//				else 
//					baud_select_prev_state<=baud_select;
//			end		
//		//if baud_select changes i will need to reset my counter in the next sampling cycle.
//		//assign reset_counter= baud_select^baud_select_prev_state;
//Smarter implementation more error.	Adding baudrate_subdivision instead of 1, 
//the residual number is  accumulating and increased the clocks necessary by 1 when its necessary to keep the division intact.
//		always @(posedge clk, posedge reset) 
//			begin
//				if (reset)
//					counter<=0;	
//				else if (reset_counter)
//					counter<=0;
//				else 
//					{sample_ENABLE,counter}<= counter+ baudrate_subdivision;
//			end
//	
//			
//			always @(posedge clk)
//				case(baud_select_prev_state)
//					0: baudrate_subdivision= 300*2^18/systemclockfrequency;
//					1: baudrate_subdivision= 1200*2^18/systemclockfrequency;
//					2: baudrate_subdivision= 4800*2^18/systemclockfrequency;
//					//
//					7: baudrate_subdivision= 115200*2^18/systemclockfrequency;
//				endcase

endmodule
