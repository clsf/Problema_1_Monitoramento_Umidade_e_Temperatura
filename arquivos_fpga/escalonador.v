module escalonador (
clk,
data_received,
data,
done_decoder,
response_sensor_o,
data_sensor_o,
address_sensor_o,
en_decoder_o,
dht_data_int,
state_o,
debug_o
);

input clk;

inout	[7:0] dht_data_int;

// Output do Receiver
input data_received;
input [15:0] data;

// Output do Decodificador
input done_decoder;

// Inputs do Decodificador
output [7:0] response_sensor_o;
output [7:0] data_sensor_o;
output [7:0] address_sensor_o;
output en_decoder_o;

output [4:0] state_o;
output [3:0] debug_o;

reg [7:0] command;
reg [7:0] address;

reg en_decoder;
reg [4:0] state;
reg [3:0] debug;
reg [7:0] en_sensors; // Situação (ativadada/desativa) de cada uma das interfaces
reg [7:0] data_sensor;
reg [7:0] command_sensor;
reg [5:0] response_sensor; 
reg [7:0] address_sensor;
reg [7:0] temp_cont; // Situação do monitoramento continuo da temperatura de cada sensor
reg [7:0] umid_cont; // Situação do monitoramento continuo da umidade de cada sensor

wire [7:0] done_sensors;
wire [7:0] data_sensor1, data_sensor2, data_sensor3, data_sensor4, data_sensor5, data_sensor6, data_sensor7, data_sensor8;
wire [5:0] response_sensor1, response_sensor2, response_sensor3, response_sensor4, response_sensor5, response_sensor6, response_sensor7, response_sensor8;

integer counter = 0;

parameter COMMAND = 0, 
TEMP_CONT_S1 = 1, UMID_CONT_S1 = 2, 
TEMP_CONT_S2 = 3, UMID_CONT_S2 = 4, 
TEMP_CONT_S3 = 5, UMID_CONT_S3 = 6, 
TEMP_CONT_S4 = 7, UMID_CONT_S4 = 8, 
TEMP_CONT_S5 = 9, UMID_CONT_S5 = 10, 
TEMP_CONT_S6 = 11, UMID_CONT_S6 = 12, 
TEMP_CONT_S7 = 13, UMID_CONT_S7 = 14, 
TEMP_CONT_S8 = 15, UMID_CONT_S8 = 16;

assign response_sensor_o = response_sensor;
assign data_sensor_o = data_sensor;
assign address_sensor_o = address_sensor;
assign en_decoder_o = en_decoder;

assign state_o = state;
assign debug_o = debug;

// Instanciamento de cada umas das 8 interfaces

interface0_modificada interface_1(
.i_Clock(clk), // clk
.i_En(en_sensors[0]), // start
.i_request(command_sensor), // comando de requisição
.dht_data_int(dht_data_int[0]), // Inout dht data
.o_data_int(data_sensor1), // Valor da respota
.comandos(response_sensor1), // Comando de Resposta
.o_done_i1(done_sensors[0]) // Recebimento do dado
);

	
interface0_modificada interface_2(
.i_Clock(clk), 
.i_En(en_sensors[1]), 
.i_request(command_sensor), 
.dht_data_int(dht_data_int[1]), 
.o_data_int(data_sensor2), 
.comandos(response_sensor2), 
.o_done_i1(done_sensors[1]) 
);

interface0_modificada interface_3(
.i_Clock(clk), 
.i_En(en_sensors[2]), 
.i_request(command_sensor), 
.dht_data_int(dht_data_int[2]), 
.o_data_int(data_sensor3), 
.comandos(response_sensor3), 
.o_done_i1(done_sensors[2]) 
);

interface0_modificada interface_4(
.i_Clock(clk), 
.i_En(en_sensors[3]), 
.i_request(command_sensor), 
.dht_data_int(dht_data_int[3]), 
.o_data_int(data_sensor4), 
.comandos(response_sensor4), 
.o_done_i1(done_sensors[3]) 
);

interface0_modificada interface_5(
.i_Clock(clk), 
.i_En(en_sensors[4]), 
.i_request(command_sensor), 
.dht_data_int(dht_data_int[4]), 
.o_data_int(data_sensor5), 
.comandos(response_sensor5), 
.o_done_i1(done_sensors[4]) 
);

interface0_modificada interface_6(
.i_Clock(clk), 
.i_En(en_sensors[5]), 
.i_request(command_sensor), 
.dht_data_int(dht_data_int[5]), 
.o_data_int(data_sensor6), 
.comandos(response_sensor6), 
.o_done_i1(done_sensors[5]) 
);

interface0_modificada interface_7(
.i_Clock(clk), 
.i_En(en_sensors[6]), 
.i_request(command_sensor), 
.dht_data_int(dht_data_int[6]), 
.o_data_int(data_sensor7), 
.comandos(response_sensor7), 
.o_done_i1(done_sensors[6]) 
);

interface0_modificada interface_8(
.i_Clock(clk), 
.i_En(en_sensors[7]), 
.i_request(command_sensor), 
.dht_data_int(dht_data_int[7]), 
.o_data_int(data_sensor8), 
.comandos(response_sensor8), 
.o_done_i1(done_sensors[7]) 
);



always @ (posedge clk) begin
	if (data_received == 1) begin // Atualiza os buffers de comando e de endereço, sempre que recebe dados do receceiver
		command <= data[15:8];
		address <= data[7:0];
	end
	case (state)
		COMMAND: // Executa o comando no buffer
			begin
				debug <= 4'b0000;
				if (command == 8'b00110001 | command == 8'b00110010 | command == 8'b00110011 | command == 8'b00110110 | command == 8'b00110111) begin // Se não for nada relacionado a monitoramento continuo
					if (counter == 0) begin // Etapa 1: Inicia a comunicação com a interface do sensor no endereço passado
						debug <= 4'b0001;
						case (address)
							8'b00110001 : en_sensors[0] <= 1; // Inicia a comunicação com a interface 1
							8'b00110010 : en_sensors[1] <= 1; 
							8'b00110011 : en_sensors[2] <= 1;
							8'b00110100 : en_sensors[3] <= 1;
							8'b00110101 : en_sensors[4] <= 1; // [...]
							8'b00110110 : en_sensors[5] <= 1;
							8'b00110111 : en_sensors[6] <= 1;
							8'b00111000 : en_sensors[7] <= 1; // Inicia a comunicação com  interface 2
						endcase
						case (command)
							8'b00110110: // Desabilitar o monitorialmento continuo da temperatura
								begin
									case (address)
										8'b00110001 : temp_cont[0] <= 0; // Desabilita o monitorialmento continuo da temperatura do sensor 1
										8'b00110010 : temp_cont[1] <= 0;
										8'b00110011 : temp_cont[2] <= 0;
										8'b00110100 : temp_cont[3] <= 0;
										8'b00110101 : temp_cont[4] <= 0; // [...]
										8'b00110110 : temp_cont[5] <= 0;
										8'b00110111 : temp_cont[6] <= 0;
										8'b00111000 : temp_cont[7] <= 0; // Desabilita o monitorialmento continuo da temperatura do sensor 8
									endcase
								end
							8'b00110111: // Desabilitar o monitorialmento continuo da umidade
								begin
									case (address)
										8'b00110001 : umid_cont[0] <= 0; // Desabilita o monitorialmento continuo da umidade do sensor 1
										8'b00110010 : umid_cont[1] <= 0;
										8'b00110011 : umid_cont[2] <= 0;
										8'b00110100 : umid_cont[3] <= 0;
										8'b00110101 : umid_cont[4] <= 0; // [...]
										8'b00110110 : umid_cont[5] <= 0;
										8'b00110111 : umid_cont[6] <= 0;
										8'b00111000 : umid_cont[7] <= 0; // Desabilita o monitorialmento continuo da umidade do sensor 8
									endcase
								end
						endcase
						address_sensor <= address;
						command_sensor <= command;
						counter <= counter + 1;
					end 
					else if (counter == 1) begin // Etapa 2: Direciona quais dados vão para o decodifcador e habilita ele
						debug <= 4'b0010;
						en_sensors <= 8'b00000000;
						case (done_sensors) // Verifica se alguma das interfaces terminou de enviar os dados
							8'b00000001: 
								begin
									data_sensor <= data_sensor1; 
									response_sensor <= response_sensor1;
									en_decoder <= 1;
									counter <= counter + 1;
								end
							8'b00000010: 
								begin
									data_sensor <= data_sensor2;
									response_sensor <= response_sensor2;
									en_decoder <= 1;
									counter <= counter + 1;
								end
							8'b00000100: 
								begin
									data_sensor <= data_sensor3;
									response_sensor <= response_sensor3;
									en_decoder <= 1;
									counter <= counter + 1;
								end
							8'b00001000: 
								begin
									data_sensor <= data_sensor4;
									response_sensor <= response_sensor4;
									en_decoder <= 1;
									counter <= counter + 1;
								end
							8'b00010000: 
								begin
									data_sensor <= data_sensor5;
									response_sensor <= response_sensor5;
									en_decoder <= 1;
									counter <= counter + 1;
								end
							8'b00100000: 
								begin
									data_sensor <= data_sensor6;
									response_sensor <= response_sensor6;
									en_decoder <= 1;
									counter <= counter + 1;
								end
							8'b01000000:
								begin
									data_sensor <= data_sensor7;
									response_sensor <= response_sensor7;
									en_decoder <= 1;
									counter <= counter + 1;
								end
							8'b10000000: 
								begin
									data_sensor <= data_sensor8;
									response_sensor <= response_sensor8;
									en_decoder <= 1;
									counter <= counter + 1;
								end
						endcase
					end
					else if (counter == 2) begin // Etapa 3: Desabilita o decodificador e espera os dados serem transmitidos para ir pro proximo estado.
						debug <= 4'b0011;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							command <= 8'b00000000;
							counter <= 0;
							state <= TEMP_CONT_S1;
						end
					end
				end
				else if (command == 8'b00110100 | command == 8'b00110101) begin
					debug <= 4'b0100;
					case (command)
						8'b00110100: // Habilitar o monitorialmento continuo da temperatura
							begin
								case (address)
									8'b00110001 : temp_cont[0] <= 1; // Habilita o monitorialmento continuo da temperatura do sensor 1
									8'b00110010 : temp_cont[1] <= 1;
									8'b00110011 : temp_cont[2] <= 1;
									8'b00110100 : temp_cont[3] <= 1;
									8'b00110101 : temp_cont[4] <= 1; // [...]
									8'b00110110 : temp_cont[5] <= 1;
									8'b00110111 : temp_cont[6] <= 1;
									8'b00111000 : temp_cont[7] <= 1; // Habilita o monitorialmento continuo da temperatura do sensor 8
								endcase
							end
						8'b00110101: // Habilitar o monitorialmento continuo da umidade
							begin
								case (address)
									8'b00110001 : umid_cont[0] <= 1; // Habilita o monitorialmento continuo da umidade do sensor 1
									8'b00110010 : umid_cont[1] <= 1;
									8'b00110011 : umid_cont[2] <= 1;
									8'b00110100 : umid_cont[3] <= 1;
									8'b00110101 : umid_cont[4] <= 1; // [...]
									8'b00110110 : umid_cont[5] <= 1;
									8'b00110111 : umid_cont[6] <= 1;
									8'b00111000 : umid_cont[7] <= 1; // Habilita o monitorialmento continuo da umidade do sensor 8
								endcase
							end
					endcase
					command <= 8'b00000000;
					state <= TEMP_CONT_S1;
				end else begin
					command <= 8'b00000000;
					state <= TEMP_CONT_S1;
				end
			end
			
		TEMP_CONT_S1: // Monitoramento continuo da temperatura do Sensor 1
			begin
				if (temp_cont[0] == 1) begin // Verifica se o monitoramento esta ativo
					debug <= 4'b0101;
					if (counter == 0) begin // Etapa 1: Habilita a interface passando o comando de medidade de temperatura atual e o endereço do sensor 1
						address_sensor <= 8'b00110001;
						command_sensor <= 8'b00110010;
						en_sensors[0] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin // Etapa 2
						debug <= 4'b0110;
						en_sensors[0] <= 0; // Desabilita a interface
						if (done_sensors[0]) begin // Espera a interface mandar os dados
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1; // Habilita o decodificador
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin // Etapa 3
						debug <= 4'b0111;
						en_decoder <= 0; // Desabilita o decodificador
						if (done_decoder) begin // Espera o decodificador enviar os dados
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin // Etapa 4: Espera 1s para ir para o proximo estado
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= UMID_CONT_S1;
						end
					end
				end
				else begin
					counter <= 0;
					state <= UMID_CONT_S1;
				end
			end
		// Os proximo estados funcionam de maneira semelhante ao anterior	
		UMID_CONT_S1:
			begin
				if (umid_cont[0] == 1) begin
					debug <= 4'b1000;
					if (counter == 0) begin
						address_sensor <= 8'b00110001;
						command_sensor <= 8'b00110011; // Comando da madidade da umidade atual
						en_sensors[0] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b1001;
						en_sensors[0] <= 0;
						if (done_sensors[0]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b1010;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= TEMP_CONT_S2;
						end
					end
				end
				else begin
					debug <= 4'b1011;
					state <= TEMP_CONT_S2;
				end
			end
			
		TEMP_CONT_S2:
			begin
				if (temp_cont[1] == 1) begin
					debug <= 4'b0101;
					if (counter == 0) begin
						address_sensor <= 8'b00110010;
						command_sensor <= 8'b00110010;
						en_sensors[1] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b0110;
						en_sensors[1] <= 0;
						if (done_sensors[1]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b0111;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= UMID_CONT_S2;
						end
					end
				end
				else begin
					counter <= 0;
					state <= UMID_CONT_S2;
				end
			end
			
		UMID_CONT_S2:
			begin
				if (umid_cont[1] == 1) begin
					debug <= 4'b1000;
					if (counter == 0) begin
						address_sensor <= 8'b00110010;
						command_sensor <= 8'b00110011;
						en_sensors[1] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b1001;
						en_sensors[1] <= 0;
						if (done_sensors[1]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b1010;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= TEMP_CONT_S3;
						end
					end
				end
				else begin
					debug <= 4'b1011;
					state <= TEMP_CONT_S3;
				end
			end
			
		TEMP_CONT_S3:
			begin
				if (temp_cont[2] == 1) begin
					debug <= 4'b0101;
					if (counter == 0) begin
						address_sensor <= 8'b00110011;
						command_sensor <= 8'b00110010;
						en_sensors[2] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b0110;
						en_sensors[2] <= 0;
						if (done_sensors[2]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b0111;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= UMID_CONT_S3;
						end
					end
				end
				else begin
					counter <= 0;
					state <= UMID_CONT_S3;
				end
			end
			
		UMID_CONT_S3:
			begin
				if (umid_cont[2] == 1) begin
					debug <= 4'b1000;
					if (counter == 0) begin
						address_sensor <= 8'b00110011;
						command_sensor <= 8'b00110011;
						en_sensors[2] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b1001;
						en_sensors[2] <= 0;
						if (done_sensors[2]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b1010;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= TEMP_CONT_S4;
						end
					end
				end
				else begin
					debug <= 4'b1011;
					state <= TEMP_CONT_S4;
				end
			end
			
		TEMP_CONT_S4:
			begin
				if (temp_cont[3] == 1) begin
					debug <= 4'b0101;
					if (counter == 0) begin
						address_sensor <= 8'b00110100;
						command_sensor <= 8'b00110010;
						en_sensors[3] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b0110;
						en_sensors[3] <= 0;
						if (done_sensors[3]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b0111;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= UMID_CONT_S4;
						end
					end
				end
				else begin
					counter <= 0;
					state <= UMID_CONT_S4;
				end
			end
			
		UMID_CONT_S4:
			begin
				if (umid_cont[3] == 1) begin
					debug <= 4'b1000;
					if (counter == 0) begin
						address_sensor <= 8'b00110100;
						command_sensor <= 8'b00110011;
						en_sensors[3] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b1001;
						en_sensors[3] <= 0;
						if (done_sensors[3]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b1010;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= TEMP_CONT_S5;
						end
					end
				end
				else begin
					debug <= 4'b1011;
					state <= TEMP_CONT_S5;
				end
			end
			
		TEMP_CONT_S5:
			begin
				if (temp_cont[4] == 1) begin
					debug <= 4'b0101;
					if (counter == 0) begin
						address_sensor <= 8'b00110101;
						command_sensor <= 8'b00110010;
						en_sensors[4] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b0110;
						en_sensors[4] <= 0;
						if (done_sensors[4]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b0111;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= UMID_CONT_S5;
						end
					end
				end
				else begin
					counter <= 0;
					state <= UMID_CONT_S5;
				end
			end
			
		UMID_CONT_S5:
			begin
				if (umid_cont[4] == 1) begin
					debug <= 4'b1000;
					if (counter == 0) begin
						address_sensor <= 8'b00110101;
						command_sensor <= 8'b00110011;
						en_sensors[4] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b1001;
						en_sensors[4] <= 0;
						if (done_sensors[4]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b1010;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= TEMP_CONT_S6;
						end
					end
				end
				else begin
					debug <= 4'b1011;
					state <= TEMP_CONT_S6;
				end
			end
			
		TEMP_CONT_S6:
			begin
				if (temp_cont[5] == 1) begin
					debug <= 4'b0101;
					if (counter == 0) begin
						address_sensor <= 8'b00110110;
						command_sensor <= 8'b00110010;
						en_sensors[5] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b0110;
						en_sensors[5] <= 0;
						if (done_sensors[5]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b0111;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= UMID_CONT_S6;
						end
					end
				end
				else begin
					counter <= 0;
					state <= UMID_CONT_S6;
				end
			end
			
		UMID_CONT_S6:
			begin
				if (umid_cont[5] == 1) begin
					debug <= 4'b1000;
					if (counter == 0) begin
						address_sensor <= 8'b00110110;
						command_sensor <= 8'b00110011;
						en_sensors[5] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b1001;
						en_sensors[5] <= 0;
						if (done_sensors[5]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b1010;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= TEMP_CONT_S7;
						end
					end
				end
				else begin
					debug <= 4'b1011;
					state <= TEMP_CONT_S7;
				end
			end
			
		TEMP_CONT_S7:
			begin
				if (temp_cont[6] == 1) begin
					debug <= 4'b0101;
					if (counter == 0) begin
						address_sensor <= 8'b00110111;
						command_sensor <= 8'b00110010;
						en_sensors[6] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b0110;
						en_sensors[6] <= 0;
						if (done_sensors[6]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b0111;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= UMID_CONT_S7;
						end
					end
				end
				else begin
					counter <= 0;
					state <= UMID_CONT_S7;
				end
			end
			
		UMID_CONT_S7:
			begin
				if (umid_cont[6] == 1) begin
					debug <= 4'b1000;
					if (counter == 0) begin
						address_sensor <= 8'b00110111;
						command_sensor <= 8'b00110011;
						en_sensors[6] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b1001;
						en_sensors[6] <= 0;
						if (done_sensors[6]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b1010;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= TEMP_CONT_S8;
						end
					end
				end
				else begin
					debug <= 4'b1011;
					state <= TEMP_CONT_S8;
				end
			end
			
		TEMP_CONT_S8:
			begin
				if (temp_cont[7] == 1) begin
					debug <= 4'b0101;
					if (counter == 0) begin
						address_sensor <= 8'b00111000;
						command_sensor <= 8'b00110010;
						en_sensors[7] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b0110;
						en_sensors[7] <= 0;
						if (done_sensors[7]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b0111;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= UMID_CONT_S8;
						end
					end
				end
				else begin
					counter <= 0;
					state <= UMID_CONT_S8;
				end
			end
			
		UMID_CONT_S8:
			begin
				if (umid_cont[7] == 1) begin
					debug <= 4'b1000;
					if (counter == 0) begin
						address_sensor <= 8'b00111000;
						command_sensor <= 8'b00110011;
						en_sensors[7] <= 1;
						counter <= counter + 1;
					end
					else if (counter == 1) begin
						debug <= 4'b1001;
						en_sensors[7] <= 0;
						if (done_sensors[7]) begin
							data_sensor <= data_sensor1; 
							response_sensor <= response_sensor1;
							en_decoder <= 1;
							counter <= counter + 1;
						end
					end
					else if (counter == 2) begin
						debug <= 4'b1010;
						en_decoder <= 0;
						if (done_decoder) begin
							counter <= counter + 1;
						end
					end
					else if (counter > 2) begin
						debug <= 4'b1111;
						counter <= counter + 1;
						if (counter >= 50000000) begin
							counter <= 0;
							state <= COMMAND;
						end
					end
				end
				else begin
					debug <= 4'b1011;
					state <= COMMAND;
				end
			end
	endcase
end

endmodule