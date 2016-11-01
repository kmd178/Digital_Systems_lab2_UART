`timescale 1ns / 1ps

module ledDataFeeder(
	input clk,
	input reset,
	input button,
	output reg [3:0] loadCharLED,
	output reg an0,an1,an2,an3
);

reg [3:0] SystemCounter=4'b0;  
reg [3:0] message [7:0];
reg [2:0] MemoryCounter=3'b0;

always @(posedge reset) 
	begin 
		message[0] <= 4'b0001;   //1//
		message[1] <= 4'b0100;   //4//
		message[2] <= 4'b0011;   //3//
		message[3] <= 4'b0101;   //5//
		message[4] <= 4'b1010;   //a//
		message[5] <= 4'b1011;   //b//
		message[6] <= 4'b1100;   //C//
		message[7] <= 4'b1101;   //d//
	end

reg [21:0] signal_every_second; ////Depending on the FPGA system used. Normally for 50mhz clock divided by 16 on the dcm(period=(2e-8)/16) and for a 1340ms distance between posedges we need 2^22cycles
always @(posedge clk, posedge reset)	
	begin 
		if (reset) 
			signal_every_second <= 1'b0;
		else
			signal_every_second<=signal_every_second+ 1'b1;
	end
	
wire check_signal_every_second=	&signal_every_second;
	
//////////////"check_signal_every_second" for time triggering
always @(posedge button, posedge reset)  //Depending if i want button as a trigger or the 1second timer above, i can chance  "button" to "check_signal_every_second"
		if (reset) 
			MemoryCounter <= 3'b0 ;
		else
			MemoryCounter<= MemoryCounter+3'b001 ; 
//%%%%%%%%MemoryCounter= MemoryCounter+3'b100 ; //in case i would like the characters displayed sequencially (not rotationally)

wire [2:0]MemoryCounter1= MemoryCounter + 1;
wire [2:0]MemoryCounter2= MemoryCounter + 2;
wire [2:0]MemoryCounter3= MemoryCounter + 3;


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
								loadCharLED = message[MemoryCounter]; 
								//loadCharLED= 4'b0001;
							end  
				  4: 		begin 
								loadCharLED = message[MemoryCounter1]; 
								//loadCharLED= 4'b0100;
						  end
				  8: 		begin 
								loadCharLED = message[MemoryCounter2]; 
								//loadCharLED= 4'b0011;
						  end
				  12: 	begin
								loadCharLED = message[MemoryCounter3]; 
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
