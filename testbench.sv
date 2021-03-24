module tb;
  
  reg clk, rst;
  reg[7:0] addr;
  wire[7:0] out;
  
  cache c1(.addr(addr),
           .clk(clk),
           .rst(rst),
           .out(out)
          );
  
  always #5 clk=~clk;
  
  initial 
    begin
      clk = 1'b0;
      rst = 1'b0;
      #50
      
      rst=1'b1;
      addr = 8'd22;
      #20
      
      addr = 8'd24;
      #20
      
      addr = 8'd26;
      #20
      
      addr = 8'd22;
      #20
      
      addr = 8'd29;
      #20
      
      addr = 8'd30;
      #20
      
      addr = 8'd22;
      #20
        			
      $finish;
    end
endmodule