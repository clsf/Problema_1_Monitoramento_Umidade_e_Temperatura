module receiver2b(baud_rate, in, data, data_recived, state_out);

input baud_rate, in; // in: Entrada serial		
output [15:0]data; 
output data_recived;	 
output [1:0]state_out; // Estado atual para debug
         
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
	START: // Espera o bit de start
		begin
			recived = 1'b0;	
			if(~in) begin // Vai para DATA quando indentifica o bit de start (0)	
				state <= DATA;
			end
		end
	DATA: // Lê cada um dos bits de dado e salva no buffer
		begin
			buffer[counter] = in;
			counter = counter + 1;
			if(counter == 8 | counter == 16) begin // Vai para STOP quando termina de armazenar no buffer os 8 bits de cada um dos 2 bytes recebidos
				state <= STOP;
			end	
		end
	STOP: // Manda o bit de stop
		begin
			if (counter == 16) begin // Apos o ultimo bit ser armazenado no buffer
				data[15:0] <= buffer [15:0]; // Passa os dados do buffer para a saida paralela
				counter <= 0; 			
				recived = 1'b1;
			end
			state <= START;
		end
endcase
end
endmodule