module receiver2b(baud_rate, in, data, data_recived, state_out);

input baud_rate, in;		
output [15:0]data; 
output data_recived;	 
output [1:0]state_out;
         
reg [15:0]data;	
reg [15:0]buffer;          
reg [1:0]state;	
reg recived = 1'b0;	

assign data_recived = recived;
assign state_out = state;

parameter START = 0, DATA = 1, STOP = 2;			 

integer counter = 0;		

always @ (posedge baud_rate) begin
	case (state)
	START:
		begin
			recived = 1'b0;	
			if(~in) begin	
				state <= DATA;
			end
		end
	DATA:
		begin
			buffer[counter] = in;
			counter = counter + 1;
			if(counter == 8 | counter == 16) begin
				state <= STOP;
			end	
		end
	STOP:
		begin
			if (counter == 16) begin
				data[15:0] <= buffer [15:0];  
				counter <= 0; 			
				recived = 1'b1;
			end
			state <= START;
		end
endcase
end
endmodule