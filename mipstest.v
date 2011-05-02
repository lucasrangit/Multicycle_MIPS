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
  reg         succeed;

  // instantiate device to be tested
  topmulti dut(clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 12; reset <= 0;
	 cycle <= 1;
	 succeed <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
	 cycle <= cycle + 1;
    end

  // check results
  always@(negedge clk)
    begin
      if(memwrite & dataadr == 108) begin
        if(writedata == 65035)
          $display("Simulation succeeded");
		  else begin
		    $display("Simulation failed");
		  end
        $stop;
      end
    end
endmodule




