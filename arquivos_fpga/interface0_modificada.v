// Autores: 
// Paulo Queiroz de Carvalho
// Rita Kassiane Santos
// Rodrigo Damasceno Sampai
// Código Original: https://github.com/ritakassiane/interface-entrada-saida/blob/main/FPGA/interface0.v.bak

// Modificado por: Antonio Nicassio, Cláudia Inês, Luis Fernando do Rosario Cintra e Nirvan Yang

/*
Este módulo tem como objetivo obter os dados de apenas um sensor dht11, através de seu módulo(dht), e 
partindo disso disso gerar respostas sendo essas o comando de resposta e o dado pego pelo sensor que 
será enviado para o módulo do decodificador, se fazendo necessário a criação de uma nova interface 
para cada novo sensor que for inserido

*/ 


module interface0_modificada(
	input i_Clock,
	input i_En, //bite para ligar a inerface
	input [7:0] i_request, // Byte de requisição do dados 
	inout	dht_data_int, // Entrada e saída do sensor DHT11
	output [7:0] o_data_int, // Saida do dado da interface
	output o_done_i1, // Bit para informar se o processo foi terminado
	output [5:0]comandos //bits para informar qual comando de resposta será enviado
);

	wire [7:0] 	w_Hum_Int, w_Hum_Float, w_Temp_Int, w_Temp_Float,w_Crc; //fios de resposta de dados de medidas do dht11
	wire        w_done11; // fio de resposta de conclusão de funcionamento do dht11
	
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
			  

dht dht_0(
	.clk(i_Clock), 							//clk de 1 microssegundo
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
			idle:  //estado de espera da interface em que se espera o recebimento do bit de start do módulo (i_En = 1)
				begin
					if (i_En == 1'b1) begin // Se o enable estiver ativado
						r_comandos <= 6'b000000;
						en_dht11 <= 1'b1; // Ativa o sensor
						state <= read; // Muda-se de estado
					end
				end
			read: //estado em que se espera o recebimento dos dados poelo sensor dht11 e a partir disso se obtém um comando de resposta e o valor pedido
				begin
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
			send: //estado que indica que o processo foi finalizado
				begin
					r_done <= 1'b1; // Informa que o processo foi finalizado
					state <= finish; 
				end
			finish://estado responsavel por zerar o done da interface, encerrar a comunicação com o dht11 e aguardar a máquina ser desligada para ir para o idle
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