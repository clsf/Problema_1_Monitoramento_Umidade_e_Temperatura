module testDeco(
	clk,
	dht_data,
	in_rx,
	out_tx,
);

input clk, in_rx;
inout [7:0] dht_data;
output out_tx;

wire baud_rate, data_received, en_decoder, done_decoder, start_transmitter, data_transmitted;
wire [15:0] data_rx;
wire [5:0] response;
wire [7:0] address, data_sensor;
wire [23:0] data_tx;

baudrate_gen baudrate_gen_0(
.clk(clk), 
.tick(baud_rate));

receiver2b receiver2b_0(
	.baud_rate(baud_rate),
	.in(in_rx),
	.data(data_rx),
	.data_recived(data_received),
	.state_out());
	module main(
	clk,
	dht_data,
	in_rx,
	out_tx,
);

input clk, in_rx;
inout [7:0] dht_data;
output out_tx;

wire baud_rate, data_received, en_decoder, done_decoder, start_transmitter, data_transmitted;
wire [15:0] data_rx;
wire [5:0] response;
wire [7:0] address, data_sensor;
wire [23:0] data_tx;

baudrate_gen baudrate_gen_0(
.clk(clk), 
.tick(baud_rate));

receiver2b receiver2b_0(
	.baud_rate(baud_rate),
	.in(in_rx),
	.data(data_rx),
	.data_recived(data_received),
	.state_out());
	
	
escalonador escalonador_0(
.clk(clk),
.data_received(data_received),
.data(data_rx),
.done_decoder(done_decoder),
.response_sensor_o(response),
.data_sensor_o(data_sensor),
.address_sensor_o(address),
.en_decoder_o(en_decoder),
.dht_data_int(dht_data),
.state_o()
);

decodificador decodificador_0(
.clk(clk),
.comandos(response), 
.endereco(address),
.data_sensor(data_sensor), 
.data_transmitted(data_transmitted),
.En(en_decoder),
.start_transmitter(start_transmitter), 
.d_done(done_decoder), 
.data_transmitter(data_tx), 
); 

transmitter3b transmitter3b_0(
.baud_rate(baud_rate), 
.out(out_tx), 
.data(data_tx), 
.start(start_transmitter), 
.data_transmitted(data_transmitted), 
.state_out());

endmodule
	
escalonador escalonador_0(
.clk(clk),
.data_received(data_received),
.data(data_rx),
.done_decoder(done_decoder),
.response_sensor_o(response),
.data_sensor_o(data_sensor),
.address_sensor_o(address),
.en_decoder_o(en_decoder),
.dht_data_int(dht_data),
.state_o()
);

decodificador decodificador_0(
.clk(clk),
.comandos(response), 
.endereco(address),
.data_sensor(data_sensor), 
.data_transmitted(data_transmitted),
.En(en_decoder),
.start_transmitter(start_transmitter), 
.d_done(done_decoder), 
.data_transmitter(data_tx), 
); 

transmitter3b transmitter3b_0(
.baud_rate(baud_rate), 
.out(out_tx), 
.data(data_tx), 
.start(start_transmitter), 
.data_transmitted(data_transmitted), 
.state_out());

endmodule