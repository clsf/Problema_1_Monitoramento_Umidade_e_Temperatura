#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>
#include <termios.h>

// Funcao pra teste de validade do binario
void printBinary(unsigned char byte) {
    for (int i = 7; i >= 0; i--) {
        printf("%d", (byte >> i) & 1);
    }
}

int main(){
	
    	int numBytes = 3;
	int fd, len;
	char text[numBytes];// só salvo dois bytes(char) por vez
	int reading = 1;
	struct termios options; /* Serial ports setting */
	// Informando a porta, que é de leitura e escrita, sem delay
	fd = open("/dev/ttyS0", O_RDONLY);
	if (fd < 0) {
		perror("Error opening serial port");
		return -1;
	}

    /* Read current serial port settings */
	// tcgetattr(fd, &options);
	
	/* Set up serial port */
	/*A sigla "c_cflag" significa "control flag" ou "conjunto de flags de controle".
      B9600 ? velocidade?
      CS8 - usa 8 bits
    */
	options.c_cflag = B9600 | CS8 | CLOCAL | CREAD;
	//input flags
	options.c_iflag = IGNPAR;
	options.c_oflag = 0;
	options.c_lflag = 0;

	//limpa a entrada do buffer
	tcflush(fd, TCIFLUSH);
	//Aplica as configurações
	tcsetattr(fd, TCSANOW, &options);
    
	while(reading){
		/** ######### TRECHO PARA LEITURA ######### */

		// Read from serial port 
		memset(text, 0, numBytes);
		len = read(fd, text, numBytes);

		// Saídas baseadas no comando recebido
		switch(text[1]){
			case 1:
				printf("Código %d: Sensor %c com problema\n", text[1], text[2]);
				break;
			case 2:
				printf("Código %d: Sensor %c funcionando normalmente\n", text[1], text[2]);
				break;
			case 3:
				printf("Código %d: Medida de umidade do sensor %c: %d\n", text[1], text[2], text[0]); 
				break;
			case 4:
				printf("Código %d: Medida de temperatura do sensor %c: %d\n", text[1], text[2], text[0]); 
				break;
			case 5:
				printf("Código %d: Desativado monitoramento continuo de temperatura do sensor: %c\n", text[1], text[2]); 
				break;
			case 6:
				printf("Código %d: Desativado monitoramento continuo de umidade do sensor: %c\n", text[1], text[2]); 
				break;
		}
		
		sleep(1);

		/** ######### FIM TRECHO PARA LEITURA ######### */
	}

	close(fd);// Fecha a porta
    return 0;
}
