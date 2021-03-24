// Code your design here
module cache(
  input[7:0] addr,
  input clk, rst,
  output[7:0] out
);
  
  reg[7:0] data_mem[0:7];	// Cache Memory
  reg[5:0] tag[0:7];		// 8-2 = 6 bit, No offset
  reg last_used[0:3];		// 4-sets, 0 if last used is 1
  reg[7:0] op;				// output register
  reg[0:7] valid;			// Valid bit
  reg[7:0] RAM[0:255];		// RAM
  
  integer i;
  
  assign out = op;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1, cache);
    end
  
  initial
    begin
      for(i=0;i<256;i=i+1)
        RAM[i] = i;
    end
  
  initial
    begin
      for(i=0;i<8;i=i+1)
        begin
          last_used[i/2] = 1;
          tag[i] = 0;
        end
      valid = 0;
      op = 0;      
    end
  
  always @(*)
    begin
      if (rst == 0)
        begin
          for(i=0;i<8;i=i+1)
            begin
              last_used[i/2] = 0;
              tag[i] = 0;
            end
          valid = 0;
          op = 0; 
        end
    end
  
  always @(posedge clk)
    begin
      // HIT
      if (tag[{addr[1:0],1'b0}] == addr[7:2] && valid[{addr[1:0],1'b0}] == 1'b1)
        begin
          op = data_mem[{addr[1:0],1'b0}];
          last_used[addr[1:0]] = 1'b1;
        end
      
      else if(tag[{addr[1:0],1'b1}] == addr[7:2] && valid[{addr[1:0],1'b1}] == 1'b1)
        begin
          op = data_mem[{addr[1:0],1'b1}];
          last_used[addr[1:0]] = 1'b0;
        end
      
      // MISS
      else
        begin
          data_mem[{addr[1:0], last_used[addr[1:0]]}] = RAM[addr];
          op = RAM[addr];
          tag[{addr[1:0], last_used[addr[1:0]]}] = addr[7:2];
          valid[{addr[1:0], last_used[addr[1:0]]}] = 1'b1;
          last_used[addr[1:0]] = ~last_used[addr[1:0]];          
        end
    end
  
endmodule