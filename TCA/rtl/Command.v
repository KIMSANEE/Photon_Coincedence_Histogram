module Command(
	input wire clk,
	input wire [31:0] rx,
	output reg [1:0] Command,
	input wire rxValid
);

reg [31:0] rx_buffer = 32'bxxxxxxx;

always@ (posedge clk) begin
	if (rxValid) begin
		rx_buffer <= rx;
	end
end

/* 
 xx 11 11 xx
 xx 00 00 xx
 xx 11 00 xx
 xx 00 11 xx 
 */
 

 
always@ (posedge clk) begin
	case (rx_buffer)
		32'hFFFF_FFFF: Command <= 2'b01;
		32'hAAAA_AAAA: Command <= 2'b11;
		default: Command <= 2'b00;
	endcase

end

endmodule