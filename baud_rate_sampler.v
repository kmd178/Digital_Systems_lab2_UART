module baud_rate_sampler(
		input reset,
		input clk,
		input [2:0] baud_select,
		output sample_ENABLE
    );
		
		//parameter 
		parameter systemclockfrequency= 50000000;  //must be changed according to the FPGA system used.
		parameter Maximum_Baud_Rate= 115200;
		
		wire clk_count_rate_x1= counter[parameter[1]:0]
		wire clk_count_rate_x2= counter[parameter[2]:0]
		wire clk_count_rate_x3= counter[parameter[3]:0]
		//
		wire clk_count_rate_x16= counter[parameter[16]:0]
		
		reg counter[parameter[16]:0];
		wire reset_counter;
		reg baud_select_prev_state;
		
		//Baud_select flip flop, (i am not sure if i should use clock or sample_ENABLE)
		always @(posedge sample_ENABLE, posedge reset) 
			begin
				if (reset)
					baud_select_prev_state<=0;	
				else 
					baud_select_prev_state<=baud_select;
			end
			
		//if baud_select changes i will need to reset my counter in the next sampling cycle.
		assign reset_counter= baud_select^baud_select_prev_state; //assign reset_counter= (baud_select == ~baud_select_prev_state) ? 1b'1 : 1b'0;
		
		always @(posedge clk, posedge reset) 
			begin
				if (reset)
					counter<=0;	
				else if (reset_counter)
					counter<=0;
				else 
					counter<=counter+ 1'b1;
			end
			
	
			
			always @(posedge clk)
				case(counter)
					22: sample_ENABLE=&clk_count_rate_x1;
					20: sample_ENABLE=&clk_count_rate_x2;
					18: sample_ENABLE=&clk_count_rate_x3;
					//
					6: sample_ENABLE=&clk_count_rate_x16;
				endcase

endmodule
