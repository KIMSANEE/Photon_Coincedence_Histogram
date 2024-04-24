module Memory (
   input wire clk,      // Clock signal
	 input wire [6:0] addr,
   output reg [31:0] data_out = 0, // Output data
	 input wire [1:0] Command,				
	 input wire Memory_add,
	 input wire rxValid
);



reg [31:0] memory [0:127];
//reg [12:0] mem_addr = 0;
integer i;

reg [7:0] r_addr = 0;
reg [7:0] num = 0;
reg read_data = 0;

/*initial begin
	for (i = 0; i < 128; i = i + 1) begin
        memory[i] <= 32'b0; // Assign 0 to each memory location
     end
end*/

always@ (posedge clk) begin
	case (Command)
		2'b00: begin // else
			if(Memory_add) begin
				r_addr <= addr;
				memory[r_addr] <= memory[r_addr] + 1'b1;
				num <= 0;
			end
		end 
		2'b11: begin //AA
			if(rxValid) begin
				if(read_data == 0 && num != 8'd127) begin
					data_out <= memory[num];
					num <= num + 1;
				end else begin
					data_out <= 0;
				end
			end
		end
		2'b01: begin //FF
			for (i = 0; i < 128; i = i + 1) begin
				memory[i] <= 32'b0; // Assign 0 to each memory location
         end
			num <= 0;
		end
	endcase
end
	/*if(Command == 2'b00) begin
		
		if(Memory_add) begin
			r_addr <= addr;
		   memory[r_addr] <= memory[r_addr] + 1'b1;
		end
	end
	
	if(Command == 2'b11) begin
		//if(rxValid) begin
		//	data_out <= memory[addr];
		//end
	end
	
	if(Command == 2'b01) begin
		//for (i = 0; i < 128; i = i + 1) begin
      //  memory[i] <= 32'b0; // Assign 0 to each memory location
      //end
	end*/
	



endmodule


