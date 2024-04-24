// Time to Digital Converter
// author: Gyeongjun Chae, San Kim
//
// clk : 500MHz
// Start[0]: pulse1 arrived at 0
// Start[1]: pulse2 arrived at 0
// End[0]: pulse1 arrived after INTERVAL
// End[1]: pulse2 arrived after INTERVAL
// data_arrived : 1 if data is arrived, it continues 2 clock cycles(4ns)
// INTERVAL : time between Start and End, 1 clock cycle is 2ns, at most 256ns(128 clock cycles)
//
// ex: pulse 1, 2 exactly arrived at 0ns, and after 10ns, pulse 1 arrived,
// at 0ns, data_arrived is 1, and 0 at 4ns
// at 0ns, INTERVAL is 0
// at 0ns, START_signal is 00, and END_signal is 11(if there was pulse short before, it will be neglected)
// then,
// at 14ns, data_arrived is 1 at 10ns, and 0,
// at 14ns, INTERVAL is 10 at 10ns
// at 14ns, START_signal is 11, and END_signal is 01, at 10ns
//
// after 128ns, counting will not be continued
module TDC(
	input wire clk,
	input wire pulse1,
	input wire pulse2,
	output reg [1:0] START_signal,
	output reg [1:0] END_signal,
	output reg [5:0] INTERVAL,
	output reg data_arrived
);

reg [2:0] pulse1_r;  always @(posedge clk) pulse1_r <= { pulse1_r[1:0], pulse1 };
wire pulse1_rising  = ( pulse1_r[2:1] == 2'b01 );
wire pulse1_falling = ( pulse1_r[2:1] == 2'b10 );

reg [2:0] pulse2_r;  always @(posedge clk) pulse2_r <= { pulse2_r[1:0], pulse2 };
wire pulse2_rising  = ( pulse2_r[2:1] == 2'b01 );
wire pulse2_falling = ( pulse2_r[2:1] == 2'b10 );

wire and_pulse_edge = pulse1_rising & pulse2_rising;
wire xor_pulse_edge = pulse1_rising ^ pulse2_rising;


reg [5:0] count;

initial
begin
	count <= 63;
	START_signal <= 2'b00;
	END_signal <= 2'b00;
	INTERVAL = 0;
	data_arrived = 0;
end


always @(posedge clk) begin
	
	if (count<63) begin
		count <= count + 1;
	end
	
	if (count>0) begin
		data_arrived<=0;
	end
	
	if (and_pulse_edge) begin
		INTERVAL <= 0;
		data_arrived <= 1;
		count<=0;
		START_signal <= 2'b00;
		END_signal <= 2'b11;
	end
	
	if (xor_pulse_edge) begin
		if(count == 6'd63) begin
			END_signal <= {pulse1_rising , pulse2_rising};
			count<=0;
		end else begin 
			INTERVAL <= count;
			data_arrived <= 1;
			count <= 0;
			START_signal <= END_signal;
			END_signal <= {pulse1_rising , pulse2_rising};
		end
	end 
	
end
	
endmodule

