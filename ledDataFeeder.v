`timescale 1ns / 1ps

module ledDataFeeder(
	input clk,
	input reset,
	input [7:0] Rx_DATA,
	input Rx_VALID,
	output reg [3:0] loadCharLED,
	output reg an0,an1,an2,an3
	
);

reg [3:0] SystemCounter=4'b0;  
reg [3:0] message1;
reg [3:0] message2;
reg [3:0] message3;
reg [3:0] message4;
reg [2:0] MemoryCounter=3'b0;  //sketopou@inf.uth.gr


reg [21:0] signal_every_second; ////Depending on the FPGA system used. Normally for 50mhz clock divided by 16 on the dcm(period=(2e-8)/16) and for a 1340ms distance between posedges we need 2^22cycles
always @(posedge Rx_VALID, posedge reset)	
	begin 
		if (reset) 
			begin
				message1 = 4'b0001;
				message2 = 4'b0100;
				message3 = 4'b0011;
				message4 = 4'b0101;
			end
		else
			begin
				message1 = message3;
				message2 = message4;
				message3 = Rx_DATA[7:4];
				message4 = Rx_DATA[3:0];
			end
			////////signal_every_second<=signal_every_second+ 1'b1;
	end


///used for controlling the states where segments and anodes are assigned
always @(posedge clk, posedge reset)
	begin
		if (reset) begin
		  SystemCounter <= 4'b0 ;
		end
		else begin
		  SystemCounter <= SystemCounter + 4'b0001;
		end
	end
	


///feeding data from memory to segments to be activated
always @(posedge clk)
	begin 
				case(SystemCounter) 
				  0: 		begin 
								loadCharLED = message1; 
								//loadCharLED= 4'b0001;
							end  
				  4: 		begin 
								loadCharLED = message2; 
								//loadCharLED= 4'b0100;
						  end
				  8: 		begin 
								loadCharLED = message3; 
								//loadCharLED= 4'b0011;
						  end
				  12: 	begin
								loadCharLED = message4; 
								//loadCharLED= 4'b0101;
						  end
				endcase
//			end
		end


///Activating the corresponding anode and its segments that are initialized above
always @(posedge clk,posedge reset)
	begin 
		if (reset)
			begin
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
			end
		else
			begin
				case(SystemCounter) 
				  0: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  1: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  2: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b0;
							end  
				  3: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  4: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  5: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  6: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b0;
								an3 =1'b1;
							end  
				  7: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  8: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
						  end
				  9: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  10: 		begin 
								an0 =1'b1;
								an1 =1'b0;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  11: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  12: 	begin
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
					13: 	begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  14: 	begin 
								an0 =1'b0;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				  15: 		begin 
								an0 =1'b1;
								an1 =1'b1;
								an2 =1'b1;
								an3 =1'b1;
							end  
				endcase
			end
		end
endmodule
