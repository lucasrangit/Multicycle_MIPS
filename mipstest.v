// mipstest.v
// HDL Example 7.12 MIPS TESTBENCH
// Test bench for MIPS processor

module testbench();

  reg         clk;
  reg         reset;
  
  wire [31:0] writedata, dataadr;
  wire memwrite;

  // keep track of execution status
  reg  [31:0] cycle;

  // instantiate device to be tested
  topmulti dut(clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 12; reset <= 0;
	 cycle <= 1;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
	 cycle <= cycle + 1;
    end

  // check results
  // If successful, it should write the value 7 to address 84
  always@(negedge clk)
    begin
      if (memwrite) begin
        if (dataadr === 84 & writedata == 7) begin
          $display("Simulation succeeded");
			 $stop;
		  end else if (dataadr !== 80) begin
		    $display("Simulation failed");
			 $stop;
		  end
      end
    end
endmodule




