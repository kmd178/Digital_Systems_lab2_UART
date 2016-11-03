`timescale 1ns / 1ps
module systemUART(
	input reset,
	input clk,
	input [2:0] baud_select,
	output sample_ENABLE
//	input BTN2,
//	output an3,
//	output an2,
//	output an1,
//	output an0,
//	output a,
//	output b,
//	output c,
//	output d,
//	output e,
//	output f,
//	output g,
//	output dp,
//	output CLKDV,
//	output stabilizedRESET,
//	output stabilizedButton
);


//wire [7:0] Led;
//wire [3:0] char;
//wire CLK0;
//assign {a,b,c,d,e,f,g,dp}=Led; //Dividing the 8 bit decoded output to the assigned segment registers that control the LED character displayed

baud_rate_sampler kmd2_1(reset,clk,baud_select,sample_ENABLE);
//anti_bounce_reset kmd2(clk, reset, stabilizedRESET);
//anti_bounce kmd3(clk, reset , BTN2, stabilizedButton);
//ledDataFeeder kmd1(CLKDV,stabilizedRESET,stabilizedButton,char,an0,an1,an2,an3);
//LEDdecoder kmd(char,Led);

//   DCM #(
//      .SIM_MODE("SAFE"),  // Simulation: "SAFE" vs. "FAST", see "Synthesis and Simulation Design Guide" for details
//      .CLKDV_DIVIDE(16.0), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
//                          //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
//      .CLKFX_DIVIDE(1),   // Can be any integer from 1 to 32
//      .CLKFX_MULTIPLY(4), // Can be any integer from 2 to 32
//      .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
//      .CLKIN_PERIOD(0.0),  // Specify period of input clock
//      .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift of NONE, FIXED or VARIABLE
//      .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
//      .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
//                                            //   an integer from 0 to 15
//      .DFS_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for frequency synthesis
//      .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
//      .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, TRUE or FALSE
//      .FACTORY_JF(16'hC080),   // FACTORY JF values
//      .PHASE_SHIFT(0),     // Amount of fixed phase shift from -255 to 255
//      .STARTUP_WAIT("FALSE")   // Delay configuration DONE until DCM LOCK, TRUE/FALSE
//   ) DCM_inst (
//      .CLK0(CLK0),     // 0 degree DCM CLK output
//      .CLKDV(CLKDV),   // Divided DCM CLK out (CLKDV_DIVIDE)
//      .CLKFB(CLK0),   // DCM clock feedback
//      .CLKIN(clk),   // Clock input (from IBUFG, BUFG or DCM)
//      .RST(reset)        // DCM asynchronous reset input
//   );

endmodule
