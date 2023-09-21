module transmitter3b(baud_rate, out, data, start, data_transmitted, state_out, wait_transmittion);

input baud_rate, start;
input [0:23]data;
output out;
output data_transmitted;
output [1:0]state_out;
output wait_transmittion;

reg transmitted = 1'b0;
reg data_state;
reg r_wait_transmittion = 1'b0;
reg out = 1'b1;
reg [1:0]state;

assign data_transmitted = transmitted;
assign state_out = state; 
assign wait_transmittion = r_wait_transmittion;

parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;
integer counter = 23;

always @ (posedge baud_rate) begin
	case(state)
		IDLE:
			begin
				transmitted = 1'b0;
				if(start) begin
					state <= START;
				end
			end
		START:
			begin
				r_wait_transmittion = 1'b1;
				out = 1'b0; 
				state <= DATA;
			end
		DATA:
			begin
				out = data[counter];
				r_wait_transmittion = 1'b0;
				counter = counter - 1;
				if (counter == 15 | counter == 7 | counter == -1) begin 
					state <= STOP;
				end
			end
		STOP:     
			begin	
				state <= START; 
				out = 1'b1;
				if (counter == -1) begin
					counter = 23;
					transmitted = 1'b1;	
					state <= IDLE;
				end   	
			end
	endcase
end

endmodule 