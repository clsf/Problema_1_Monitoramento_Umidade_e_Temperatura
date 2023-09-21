/*
Modulo da interface do DHT11 e apenas desse sensor, caso seja inserido outros sensores seria necessário
implementar sua interface nos padrões do sistema para seu funcionamento, o sistema já está desenvolvido
para receber outras interfaces.
Esta interface instância o modulo do seu sensor (DHT11), pega suas saídas e a depender da requisição ou caso houver
algum erro ele retorna uma resposta equivalente (Um byte)

*/

module interface0_modificada(
	input i_Clock,
	input i_En,
	input [7:0] i_request, // Byte de requisição do dados 
	inout	dht_data_int, // Entrada e saída do sensor DHT11
	output [7:0] o_data_int, // Saida do dado da interface
	output o_done_i1, // Bit para informar se o processo foi terminado
	output [5:0]comandos //bits para informar qual comando de resposta será enviado
);

	wire [7:0] 	w_Hum_Int, w_Hum_Float, w_Temp_Int, w_Temp_Float,w_Crc;
	wire        w_done11;
	
	reg [7:0]r_data_int = 8'b0;
	reg r_done = 1'b0;
	reg r_Rst = 1'b0;
	reg [1:0] state = 2'b00;
	reg en_dht11;
	reg [5:0] r_comandos = 6'b000000;
	
	wire wait_int;
	wire error_int;
	wire debug_int;
	wire microssegundo;
	
	assign o_data_int = r_data_int;
	assign o_done_i1 = r_done; 
	assign comandos = r_comandos;
	
//Definindo casos da máquina de estados
localparam idle =  2'b00, 
			  read  =  2'b01, 
			  send  =  2'b10,
			  finish  =  2'b11;
			  
geradorMicrossegundo geradorMicrossegundo_0(
	.clk(i_Clock), 
	.microssegundo(microssegundo)
);

dht dht_0(
	.clk(microssegundo), 							//clk de 1 microssegundo
	.dht_data(dht_data_int), 			//pino de data do dht11
	.start_bit(en_dht11), 					//sinal de start para a máquina começar
	.errorSensor(error_int), 		//pino de identificação de erro
	.done(w_done11),                //reg de 1 bit para indicação de conclusão
	.hum_int(w_Hum_Int), 			//parte inteira da humidade
	.hum_float(w_Hum_Float), 			//parte float da humidade
	.temp_int(w_Temp_Int), 			//parte inteira da temperatura
	.temp_float(w_Temp_Float), 		//parte float da temperatura
	.check_sum(w_Crc) 			//8 bits de checagem
	);


always @(posedge i_Clock) begin
			case(state)
			idle:  
				begin
					if (i_En == 1'b1) begin // Se o enable estiver ativado
						r_comandos <= 6'b000000;
						en_dht11 <= 1'b1; // Ativa o sensor
						r_Rst <= 1'b1; // Dar-se um sinal de rst para iniciar a obtenção de dados
						state <= read; // Muda-se de estado
					end
				end
			read:
				begin
					r_Rst <= 1'b0; // O resete deve ficar somente uma subida de clock para que não fique sempre no IDLE do DHT11
					if(w_done11 == 1'b1) begin	 // Se o DHT11 estiver terminado o processo, leremos os dados
						if(i_request == 8'b00110010)begin // Se for pedido temperatura
							r_comandos = 6'b001000;
							r_data_int <= w_Temp_Int; 
						end
						else if (i_request == 8'b00110011)begin // Se for pedido umidade
							r_comandos = 6'b000100;
							r_data_int <= w_Hum_Int;
						end
						else if (i_request == 8'b00110001) begin// Se for estado do sensor
							if(error_int == 1'b0) begin
								r_comandos = 6'b000010;
								r_data_int <= 8'b00000000;
							end
						end
						else if (i_request == 8'b00110110)begin // Se for desativação de sensoriamento continuo de temperatura
						
							r_comandos = 6'b010000;
			
						end else if (i_request == 8'b00110111)begin // Se for desativação de sensoriamento continuo de umidade
						
							r_comandos = 6'b100000;
					
						end
						
						
						if(error_int == 1'b1) begin // Se houver error
							r_comandos = 6'b000001;
							r_data_int <= 8'b10000110;
						end
						
						state <= send;
					end
				end
			send:
				begin
					r_done <= 1'b1; // Informa que o processo foi finalizado
					state <= finish; 
				end
			finish:
				begin	
					r_done <= 1'b0; // Reseta os operadores
					en_dht11 <= 1'b0;
					if (i_En == 1'b0) begin
						state <= idle; // Retorna pro estado idle
					end
				end
			endcase
end
	


endmodule