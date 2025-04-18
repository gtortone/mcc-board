
`timescale 1 ns / 1 ps

`include "axis_txc_generator_v1_0_tb_include.vh"

// lite_response Type Defines
`define RESPONSE_OKAY 2'b00
`define RESPONSE_EXOKAY 2'b01
`define RESP_BUS_WIDTH 2
`define BURST_TYPE_INCR  2'b01
`define BURST_TYPE_WRAP  2'b10

// AMBA AXI4 Lite Range Constants
`define S_AXI_MAX_BURST_LENGTH 1
`define S_AXI_DATA_BUS_WIDTH 32
`define S_AXI_ADDRESS_BUS_WIDTH 32
`define S_AXI_MAX_DATA_SIZE (`S_AXI_DATA_BUS_WIDTH*`S_AXI_MAX_BURST_LENGTH)/8

	// Streaming defines
`define MAX_BURST_LENGTH 1
`define DESTVALID_FALSE 1'b0
`define DESTVALID_TRUE  1'b1
`define IDVALID_TRUE  1'b1
`define IDVALID_FALSE 1'b0
`define DATA_BUS_WIDTH 32
`define ID_BUS_WIDTH    8
`define DEST_BUS_WIDTH  4
`define USER_BUS_WIDTH  8
`define MAX_PACKET_SIZE 10
`define MAX_OUTSTANDING_TRANSACTIONS 8
`define STROBE_NOT_USED  0
`define KEEP_NOT_USED  0

module axis_txc_generator_v1_0_tb;
	reg tb_ACLK;
	reg tb_ARESETn;

	// Create an instance of the example tb
	`BD_WRAPPER dut (.ACLK(tb_ACLK),
				.ARESETN(tb_ARESETn));

	// Local Variables

	// AMBA S_AXI AXI4 Lite Local Reg
	reg [`S_AXI_DATA_BUS_WIDTH-1:0] S_AXI_rd_data_lite;
	reg [`S_AXI_DATA_BUS_WIDTH-1:0] S_AXI_test_data_lite [3:0];
	reg [`RESP_BUS_WIDTH-1:0] S_AXI_lite_response;
	reg [`S_AXI_ADDRESS_BUS_WIDTH-1:0] S_AXI_mtestAddress;
	reg [3-1:0]   S_AXI_mtestProtection_lite;
	integer S_AXI_mtestvectorlite; // Master side testvector
	integer S_AXI_mtestdatasizelite;
	integer result_slave_lite;


	reg [`ID_BUS_WIDTH-1:0]       mteststreamID;  
	reg [`DEST_BUS_WIDTH-1:0]     mtestDEST;
	reg [`DATA_BUS_WIDTH-1:0]     mtestDATA [7:0];
	reg [(`DATA_BUS_WIDTH/8)-1:0] mtestSTRB;
	reg [(`DATA_BUS_WIDTH/8)-1:0] mtestKEEP;
	reg                          mtestLAST;
	reg [`USER_BUS_WIDTH-1:0]     mtestUSER;
	integer                      mtestDATASIZE;
	reg [(`DATA_BUS_WIDTH*(`MAX_PACKET_SIZE))-1:0] v_mtestDATA;
	reg [(`USER_BUS_WIDTH*(`MAX_PACKET_SIZE))-1:0] v_mtestUSER;

	reg [`ID_BUS_WIDTH-1:0]       steststreamID;  
	reg [`DEST_BUS_WIDTH-1:0]     stestDEST;
	reg [`DATA_BUS_WIDTH-1:0]     stestDATA [7:0];
	reg [(`DATA_BUS_WIDTH/8)-1:0] stestSTRB;
	reg [(`DATA_BUS_WIDTH/8)-1:0] stestKEEP;
	reg                          stestLAST;
	reg [`USER_BUS_WIDTH-1:0]     stestUSER;
	integer                      stestDATASIZE;
	reg [(`DATA_BUS_WIDTH/8)-1:0] all_valid_strobe;
	reg [(`DATA_BUS_WIDTH/8)-1:0] all_valid_keep;

	integer                     i; // Simple loop integ
	integer                     j; // Simple loop integer. ;

	// Simple Reset Generator and test
	initial begin
		tb_ARESETn = 1'b0;
	  #500;
		// Release the reset on the posedge of the clk.
		@(posedge tb_ACLK);
	  tb_ARESETn = 1'b1;
		@(posedge tb_ACLK);
	end

	// Simple Clock Generator
	initial tb_ACLK = 1'b0;
	always #10 tb_ACLK = !tb_ACLK;

	//------------------------------------------------------------------------
	// TEST LEVEL API: CHECK_RESPONSE_OKAY
	//------------------------------------------------------------------------
	// Description:
	// CHECK_RESPONSE_OKAY(lite_response)
	// This task checks if the return lite_response is equal to OKAY
	//------------------------------------------------------------------------
	task automatic CHECK_RESPONSE_OKAY;
		input [`RESP_BUS_WIDTH-1:0] response;
		begin
		  if (response !== `RESPONSE_OKAY) begin
			  $display("TESTBENCH ERROR! lite_response is not OKAY",
				         "\n expected = 0x%h",`RESPONSE_OKAY,
				         "\n actual   = 0x%h",response);
		    $stop;
		  end
		end
	endtask

	//------------------------------------------------------------------------
	// TEST LEVEL API: COMPARE_LITE_DATA
	//------------------------------------------------------------------------
	// Description:
	// COMPARE_LITE_DATA(expected,actual)
	// This task checks if the actual data is equal to the expected data.
	// X is used as don't care but it is not permitted for the full vector
	// to be don't care.
	//------------------------------------------------------------------------
	`define S_AXI_DATA_BUS_WIDTH 32 
	task automatic COMPARE_LITE_DATA;
		input [`S_AXI_DATA_BUS_WIDTH-1:0]expected;
		input [`S_AXI_DATA_BUS_WIDTH-1:0]actual;
		begin
			if (expected === 'hx || actual === 'hx) begin
				$display("TESTBENCH ERROR! COMPARE_LITE_DATA cannot be performed with an expected or actual vector that is all 'x'!");
		    result_slave_lite = 0;
		    $stop;
		  end

			if (actual != expected) begin
				$display("TESTBENCH ERROR! Data expected is not equal to actual.",
				         "\nexpected = 0x%h",expected,
				         "\nactual   = 0x%h",actual);
		    result_slave_lite = 0;
		    $stop;
		  end
			else 
			begin
			   $display("TESTBENCH Passed! Data expected is equal to actual.",
			            "\n expected = 0x%h",expected,
			            "\n actual   = 0x%h",actual);
			end
		end
	endtask

	//------------------------------------------------------------------------
	// TEST LEVEL API: COMPARE_DATA_STREAM
	//------------------------------------------------------------------------
	// Description:
	// COMPARE_DATA_STREAM(expected,actual)
	// This task checks if the actual data is equal to the expected data.
	// X is used as don't care but it is not permitted for the full vector
	// to be don't care.
	//------------------------------------------------------------------------
	task automatic COMPARE_DATA_STREAM;
	input [(`DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] expected;
	input [(`DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] actual;
		begin
			if (expected === 'hx || actual === 'hx) begin
			    $display("TESTBENCH ERROR! COMPARE_DATA_STREAM cannot be performed with an expected or actual vector that is all 'x'!");
			    $stop;
			end

			if (actual != expected) begin
			   $display("TESTBENCH ERROR! Data expected is not equal to actual.",
			            "\n expected = 0x%h",expected,
			            "\n actual   = 0x%h",actual);
			   $stop;
			end
			else 
			begin
			   $display("TESTBENCH Passed! Data expected is equal to actual.",
			            "\n expected = 0x%h",expected,
			            "\n actual   = 0x%h",actual);
			end
		end
	endtask

	task automatic S_AXI_TEST;
		begin
			$display("---------------------------------------------------------");
			$display("EXAMPLE TEST : S_AXI");
			$display("Simple register write and read example");
			$display("---------------------------------------------------------");

			S_AXI_mtestvectorlite = 0;
			S_AXI_mtestAddress = `S_AXI_SLAVE_ADDRESS;
			S_AXI_mtestProtection_lite = 0;
			S_AXI_mtestdatasizelite = `S_AXI_MAX_DATA_SIZE;

			 result_slave_lite = 1;

			for (S_AXI_mtestvectorlite = 0; S_AXI_mtestvectorlite <= 3; S_AXI_mtestvectorlite = S_AXI_mtestvectorlite + 1)
			begin
			  dut.`BD_INST_NAME.master_0.cdn_axi4_lite_master_bfm_inst.WRITE_BURST_CONCURRENT( S_AXI_mtestAddress,
				                     S_AXI_mtestProtection_lite,
				                     S_AXI_test_data_lite[S_AXI_mtestvectorlite],
				                     S_AXI_mtestdatasizelite,
				                     S_AXI_lite_response);
			  $display("EXAMPLE TEST %d write : DATA = 0x%h, lite_response = 0x%h",S_AXI_mtestvectorlite,S_AXI_test_data_lite[S_AXI_mtestvectorlite],S_AXI_lite_response);
			  CHECK_RESPONSE_OKAY(S_AXI_lite_response);
			  dut.`BD_INST_NAME.master_0.cdn_axi4_lite_master_bfm_inst.READ_BURST(S_AXI_mtestAddress,
				                     S_AXI_mtestProtection_lite,
				                     S_AXI_rd_data_lite,
				                     S_AXI_lite_response);
			  $display("EXAMPLE TEST %d read : DATA = 0x%h, lite_response = 0x%h",S_AXI_mtestvectorlite,S_AXI_rd_data_lite,S_AXI_lite_response);
			  CHECK_RESPONSE_OKAY(S_AXI_lite_response);
			  COMPARE_LITE_DATA(S_AXI_test_data_lite[S_AXI_mtestvectorlite],S_AXI_rd_data_lite);
			  $display("EXAMPLE TEST %d : Sequential write and read burst transfers complete from the master side. %d",S_AXI_mtestvectorlite,S_AXI_mtestvectorlite);
			  S_AXI_mtestAddress = S_AXI_mtestAddress + 32'h00000004;
			end

			$display("---------------------------------------------------------");
			$display("EXAMPLE TEST S_AXI: PTGEN_TEST_FINISHED!");
				if ( result_slave_lite ) begin                                        
					$display("PTGEN_TEST: PASSED!");                 
				end	else begin                                         
					$display("PTGEN_TEST: FAILED!");                 
				end							   
			$display("---------------------------------------------------------");
		end
	endtask

	// Create the test vectors
	initial begin
		// When performing debug enable all levels of INFO messages.
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);  

		dut.`BD_INST_NAME.master_0.cdn_axi4_lite_master_bfm_inst.set_channel_level_info(1);

		// Create test data vectors
		S_AXI_test_data_lite[0] = 32'h0101FFFF;
		S_AXI_test_data_lite[1] = 32'habcd0001;
		S_AXI_test_data_lite[2] = 32'hdead0011;
		S_AXI_test_data_lite[3] = 32'hbeef0011;

		dut.`BD_INST_NAME.slave_0.cdn_axi4_streaming_slave_bfm_inst.set_channel_level_info(1);
		mtestDATA[0] = 8'h01;
		mtestDATA[1] = 8'h02;
		mtestDATA[2] = 8'h03;
		mtestDATA[3] = 8'h04;
		mtestDATA[4] = 8'h05;
		mtestDATA[5] = 8'h06;
		mtestDATA[6] = 8'h07;
		mtestDATA[7] = 8'h08;
	end

	// Drive the BFM
	initial begin
		// Wait for end of reset
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     

		S_AXI_TEST();

	end

	// Drive the BFM
	initial begin
		// Wait for end of reset
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     

		for (j = 0; j < 8; j=j+1) begin
			steststreamID = j;
			stestDEST = j;
			stestSTRB = 4'b1111;
			stestKEEP = 4'b1111;
			dut.`BD_INST_NAME.slave_0.cdn_axi4_streaming_slave_bfm_inst.RECEIVE_TRANSFER(steststreamID,
			                          `IDVALID_FALSE,
			                          stestDEST,
			                          `DESTVALID_FALSE,
			                          steststreamID,
			                          stestDEST,
			                          stestDATA[j],
			                          stestSTRB,
			                          stestKEEP,
			                          stestLAST,
			                          stestUSER);

			COMPARE_DATA_STREAM(mtestDATA[j],stestDATA[j]);
		end

	end

endmodule
