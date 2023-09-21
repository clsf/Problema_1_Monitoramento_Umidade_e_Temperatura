module decodificador(
clk,
comandos, 
endereco,
data_sensor, 
done_transmittion,
En,
wait_transmitter,
start_transmitter, 
d_done, 
data_transmitter, 
); 

input clk;

input [5:0] comandos; //bits correspondentes aos comandos de resposta: 
//[0]comandos:Sensor com problema
//[1]comandos:Sensor funcionado corretamente
//[2]comandos:Medida de umidade 
//[3]comandos:Medida de temperatura 
//[4]comandos:Confirmação de desativação do sensoriamento contínuo de temperatura 
//[5]comandos:Confirmação de desativação do sensoriamento contínuo de umidade

input [7:0] data_sensor; //Informação da medida de temperatura ou umidadade  
input En; //Confirmação de recebimento de dados do sensor pelo módulo da interface  
input done_transmittion; //Confirmação de envio de dados pelo transmissor 
input [7:0] endereco; // endereco do sensor em ascii 
input wait_transmitter; //Bit respons´avel por informar que o transmitter iniciou a transmissao dos dados


output [23:0] data_transmitter; //Saida dos dados do transmissor  
output d_done; //Bit de saída para indicar que o decodificador enviou os dados
output start_transmitter; //Bit de saída para ligar o transmitter

reg [23:0] reg_data_transmitter; //Registrador para controle de dados da saída do sensor 
reg [7:0] comando_resposta; //Comandos de respostas para serem enviados para o computador
reg [1:0] state = 1'b00;// registrador para controlar os estados 
reg reg_d_done = 1'b0; //registrador para estado do decodificador se terminou ou não de enviar os dados  
reg reg_start_transmitter = 1'b0;//bit responsável ligar a transmissão dos dados 


assign data_transmitter = reg_data_transmitter; 
assign reg_endereco = endereco;
assign start_transmitter = reg_start_transmitter;
assign d_done = reg_d_done;

localparam idle =  2'b00, 
			  decoding  =  2'b01, 
			  sending  =  2'b10;
			  

/* Tabela de comandos de resposta:
comandos = 000001 =>Sensor com problema: 00000001
comandos = 000010 =>Sensor funcionando normalmente: 00000010	  
comandos = 000100 =>Medida de umidade: 00000011
comandos = 001000 =>Medida de temperatura: 00000100 
comandos = 010000 =>Confirmação de desativação de sensoriamento contínuo de temperatura: 00000101
comandos = 100000 =>Confirmação de desativação de sensoriamento contínuo de umidade: 00000110  
*/
			  
			  		  
			  
always @(posedge clk) begin 
		case(state)
			idle: 
					begin
					
						if(En == 1'b1)begin 
							reg_d_done = 1'b0; 
							reg_data_transmitter = 24'b000000000000000000000000;
								state <= decoding;
							end
			
					end
			decoding://Estado responsável por decodificar os dados que irão ser enviados para o transmissor
					begin 
							 
							if(comandos == 6'b000001 )begin //Se o sensor estiver com problema
								
								reg_data_transmitter[23:16] = endereco; //atribuindo o primeiro byte do endereço do sensor
								reg_data_transmitter[15:8] = 8'b00000001; //Atribuindo o commando de resposta de sensor com problema
								reg_data_transmitter[7:0] = 8'b10000000; //Atribuindo um valor a quando o sensor estiver com problema
								reg_start_transmitter = 1'b1; //bit para ligar o transmitter para começar a transmitir os dados
		
								
							end else if( comandos == 6'b000010 )begin // Se o sensor estiver funcionando normalmente
				
								reg_data_transmitter[23:16] = endereco; //atribuindo o primeiro byte do endereço do sensor
								reg_data_transmitter[15:8] = 8'b00000010; //Atribuindo o commando de resposta de sensor funcioando normalmente
								reg_data_transmitter[7:0] = 8'b11000000; //Atribuindo um valor a quando o sensor estiver funcionando normalmente
								reg_start_transmitter = 1'b1; //bit para ligar o transmitter começar a transmitir os dados
								
								
							end else if( comandos == 6'b000100 )begin //Se foi solicitado a medida de umidadade
							
								reg_data_transmitter[23:16] = endereco; //atribuindo o primeiro byte do endereço do sensor
								reg_data_transmitter[15:8] = 8'b00000011; //Atribuindo o commando de resposta de medida de umidade
								reg_data_transmitter[7:0] = data_sensor; //Atribuindo o valor de medida de umidade inteira
								reg_start_transmitter = 1'b1; //bit para ligar o transmitter começar a transmitir os dados
								
							
							end else if( comandos == 6'b001000  )begin // Se foi solicitado a medida de temperatura
								
								reg_data_transmitter[23:16] = endereco; //atribuindo o primeiro byte do endereço do sensor
								reg_data_transmitter[15:8] = 8'b00000100; //Atribuindo o commando de resposta de medida de temperatura
								reg_data_transmitter[7:0] = data_sensor; //Atribuindo o valor de medida de temperatura inteira
								reg_start_transmitter = 1'b1; //bit para ligar o transmitter começar a transmitir os dados
								
								
							
							end else if( comandos == 6'b010000 )begin // Se foi solicitado a confirmação de desativação de sensoriamento contínuo de temperatura
								
								reg_data_transmitter[23:16] = endereco; //atribuindo o primeiro byte do endereço do sensor
								reg_data_transmitter[15:8] = 8'b00000101; //Atribuindo o commando de desativação de sensoriamento contínuo de temperatura
								reg_data_transmitter[7:0] = 8'b11100000; //Atribuindo um valor quando desativar o monitoramento contínuo de temperatura
								reg_start_transmitter = 1'b1; //bit para ligar o transmitter começar a transmitir os dados
								
								
							end else if( comandos == 6'b100000 )begin // Se foi solicitado a confirmação de desativação de sensoriamento contínuo de umidade
								
								reg_data_transmitter[23:16] = endereco; //atribuindo o primeiro byte do endereço do sensor
								reg_data_transmitter[15:8] = 8'b00000110; //Atribuindo o commando de desativação de sensoriamento contínuo de umidade
								reg_data_transmitter[7:0] = 8'b11110000; //Atribuindo um valor quando desativar o monitoramento contínuo de umidade
								reg_start_transmitter = 1'b1; //bit para ligar o transmitter começar a transmitir os dados
								
								
							end   
							
							state <= sending;
							
						end
				sending: //Estado para aguardar o final da transmissão de dados pelo transmitter
					begin
							if(wait_transmitter == 1'b1) begin //iniciou a transmissao de dados
								reg_start_transmitter = 1'b0;
							end
							if(done_transmittion== 1'b1)begin //Confirma a transmissão de dados
								state <= idle;
								reg_d_done <= 1'b1;
							end
			
					end		
					
			endcase



end 


endmodule