
module plot_distributer(
	input wire clk,
	input wire [1:0] START,
	input wire [1:0] END,
	input wire [5:0] INTERVAL,
	input wire data_arrived,
	output reg [6:0] Addr = 0,
	output wire Memory_add
);

reg [2:0] data_arrived_r;  always @(posedge clk) data_arrived_r <= { data_arrived_r[1:0], data_arrived };
wire data_arrived_rising  = ( data_arrived_r[2:1] == 2'b01 );
parameter address_0 = 64;
reg [3:0] count = 0;

reg add_internal = 0;

assign Memory_add = data_arrived_rising;

always @(posedge clk) begin

	if(data_arrived_rising) begin
		if(START == 2'b00 && END == 2'b11) begin
			Addr <= address_0 ;
			count<=0;
		end
		else if((START == 2'b11 || START == 2'b01) && END == 2'b10) begin
			Addr <= address_0 - INTERVAL;
			count<=0;
		end
		else if((START == 2'b11 || START == 2'b10) && END == 2'b01) begin
			Addr <= address_0 + INTERVAL;
			count<=0;
		end
	end
end
endmodule
