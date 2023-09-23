# Problema 1 - Monitoramento Humidade e Temperatura
Problema 1 da disciplina de Sistemas Digitais - Monitoramento de Temperatura e Humidade 

## Introdução
<p align="justify"> O projeto consiste na implementação de um Sensor Digital na FPGA utilizando comunicação serial, no qual deve ser feita a medição de temperatura e umidade através do sensor DHT11. O protótipo desenvolvido implementa a comunicação serial entre dois dispositivos, um computador, responsável por enviar comandos e receber a resposta contendo as informações solicitadas, exibindo-as numa interface feita no terminal, e a FPGA Cyclone IV, responsável por receber as solicitações feitas pelo computador, recolher as informações pedidas do respectivo DHT11, tratá-las e enviá-las de volta ao solicitante.
</p>
O código desenvolvido consiste em três partes:

- A comunicação serial, UART, dividida em comunicação por parte do computador, feita na linguagem de programação C, e na comunicação por parte da FPGA, onde foi utilizado a linguagem de descrição de hardware verilog.
- O módulo do DHT11 que consiste na máquina de estados que controla o funcionamento do sensor para que a solicitação dos dados seja feita de forma correta.
- Os módulos de processamento das informações, responsáveis por decidir de acordo com o comando e o endereço do sensor recebidos, qual informação deve ser tratada para envio e de qual sensor deve ser retirada essa informação.

<div align="center">
  <img src="/img/general_diagram.png" alt="Diagrama Geral">
   <p>
      Diagrama Geral.
    </p>
</div>

<div align="center">
  <img src="/img/fpga_diagram.png" alt="Diagrama de Estados do Receiver">
   <p>
      Diagrama dos Modulos da FPGA.
    </p>
</div>

## :student: Equipe de desenvolvimento
- Antonio
- Cláudia
- Luis
- Nirvan

## :man_teacher: Tutor
- Thiago Jesus

## :page_facing_up: Sumário
- [Problema 1 - Monitoramento Humidade e Temperatura](#problema-1---monitoramento-humidade-e-temperatura)
  - [Introdução](#introdução)
  - [:student: Equipe de desenvolvimento](#student-equipe-de-desenvolvimento)
  - [:man\_teacher: Tutor](#man_teacher-tutor)
  - [:page\_facing\_up: Sumário](#page_facing_up-sumário)
  - [Recursos utilizados](#recursos-utilizados)
  - [Como executar](#como-executar)
    - [Em C](#em-c)
    - [Para programar na FPGA](#para-programar-na-fpga)
  - [Exemplo de montagem](#exemplo-de-montagem)
  - [UART](#uart)
    - [Escrita e Leitura em C](#escrita-e-leitura-em-c)
    - [Receiver e Transmitter](#receiver-e-transmitter)
    - [Baud Rate](#baud-rate)
  - [DHT11](#dht11)
  - [Gerenciamento e processamento da informação](#gerenciamento-e-processamento-da-informação)
    - [Interface](#interface)
    - [Escalonador](#escalonador)
    - [Decodificador](#decodificador)
  - [LEs, LABs e Pinos](#les-labs-e-pinos)
  - [Conclusões](#conclusões)
  - [Anexos](#anexos)


## Recursos utilizados 
<ul>
<li><a href="#fpgaimg">Kit de desenvolvimento Mercurio IV contendo a FPGA Cyclone IV (EP4CE30F23).</a></li>
<li><a href="#dht11img">Sensor de Temperatura e Umidade DHT11.</a></li> 
</ul>

## Como executar
Nesta seção, forneceremos instruções sobre como executar o projeto nas seguintes abordagens:

### Em C
Para executar é necessário a utilização de um sistema operacional da família Linux.
1. Abra a pasta arquivos_em_c que se encontra no diretório principal do projeto.
2. Em seguida abra duas janelas de terminal dentro da pasta, um para cada arquivo do projeto.
3. Compile os códigos com os seguintes comando:
- Para o arquivo de escrita: <p><code>$ gcc MenuSensoresEscritav2.c -o writer</code></p>
- Para o arquivo de leitura: <p><code>$ gcc uartReaderv2.c -o reader</code></p>
4. Após compilar, execute osexecutáveis gerados, um em cada terminal, usando os seguintes comandos:
- Para o arquivo de escrita: <p><code>$ ./writer</code></p>
- Para o arquivo de leitura: <p><code>$ ./reader</code></p>

### Para programar na FPGA
1. **Abra o Projeto:**
   - Utilize o software Quartus.
   - Abra o projeto "pblsd.qpf" selecionando a opção "Abrir Projeto" ou similar no Quartus.
     
     <div align="center">
        <img src="/img/parte1FPGA.png" alt="Abrindo o projeto" width="350" height="350">
    </div>

2. **Compilação do Projeto:**
   - Verifique se o arquivo "mainV3.v" está configurado como o módulo de nível superior (TOP-LEVEL) do projeto.
   - Compile o projeto selecionando a opção de compilação no Quartus.
     
     <div align="center">
        <img src="/img/parte2FPGA.png" alt="Compilando o projeto" width="350" height="350">
    </div>

3. **Conferindo da Pinagem da FPGA:**
   - Confirme a configuração da pinagem da FPGA para garantir que esteja corretamente definida de acordo com as especificações do projeto.
  
     <div align="center">
        <img src="/img/parte3FPGA.png" alt="Conferindo a pinagem" width="350" height="350">
    </div>

4. **Programação na FPGA:**
   - Certifique-se de que a FPGA esteja conectada ao computador via USB ou outra interface apropriada.
   - Utilize a opção de programação no Quartus para carregar o projeto compilado na FPGA conectada.
    <div align="center">
        <img src="/img/parte4FPGA.png" alt="Iniciando a programação da FPGA" width="350" height="350">   <img src="/img/parte5FPGA.png" alt="Programando a FPGA" width="350" height="350">
      
    </div>

## Exemplo de montagem

<img align="center" src="/img/montagem.png" alt="Sensor de Temperatura e Umidade DHT11">
<p align="center">
Montagem do projeto.
</p>

<img align="center" src="/img/terminal.png" alt="Sensor de Temperatura e Umidade DHT11">
<p align="center">
Respostas recebidas através do terminal.
</p>


## UART

Para a realização da comunicação entre o computador e a FPGA foi necessário implementar o protocolo de comunicação serial UART em ambos dispositivos. O protocolo UART (Universal Asynchronous Receiver/Transmitter) é um método de comunicação serial assíncrona que transfere dados entre dispositivos. Ele utiliza um sistema de start bits, dados, stop bits para encapsular os dados a serem transmitidos. As linhas de RX (Receiver) e TX (Transmitter) são usadas para receber e transmitir dados bidirecionalmente. A comunicação UART também envolve a configuração da taxa de transmissão, chamada de baud rate, para determinar a velocidade da transferência de dados. o baud rate escolhido para ambas as implementações foi de 9600 bps.

<div align="center">
  <img src="/img/serial.png" alt="Diagrama de Estados do Receiver">
   <p>
      Diagrama de Estados do Receiver. Fonte: <a href="https://www.rohde-schwarz.com/br/produtos/teste-e-medicao/essentials-test-equipment/digital-oscilloscopes/compreender-uart_254524.html">rohde&schwarz</a>
    </p>
</div>

### Escrita e Leitura em C
Para fazer a comunicação por parte do computador, foram desenvolvidos dois programas, um para escrita e outro para leitura. Em ambos foram utilizadas as seguintes bibliotecas:
<b>termios.h</b> utilizada para fazer a configuração da porta em aspectos de velocidade e da forma de como os dados são enviados e recebidos;
<b>fcntl.h</b> responsável por definir a porta como somente escrita e leitura nos seus respectivos códigos;
<b>unistd.h</b> responsável por fazer a escrita e a leitura na porta.


- O código de escrita funciona como um menu, primeiro ele configura a porta serial, definindo a velocidade e a forma como a porta serial deve se comportar, e define a porta para somente escrita usando a flag <b>O_WRONLY</b>, após isso, ele pede continuamente ao usuário, através de um menu, o endereço do sensor, de 1-8, e o comando de acordo com a informação desejada. Essas informações são então enviadas, respectivamente, o endereço e o comando para a FPGA através da porta serial.

- O código de leitura primeiro configura a porta serial com as mesma condigurações de velocidade e comportamento da porta serial utilizadas pelo código de escrita, exceto que ela utiliza a flag <b>O_RDONLY </b> para definir a porta como somente leitura, logo após, ele pede a cada 1 segundo, as informações que estão sendo recebidas da FPGA pela porta serial, caso não seja recebido nada, não terá saída, mas caso um comando válido seja recebido, a interface exibirá de acordo com o comando a informação do sensor assim como seu endereço.

Além das flags de escrita e leitura já explicadas, ambos os códigos utilizam as seguintes flags para configuração da porta serial:

  <b>IGNPAR</b>: Usada para ignorar erros de paridade.<br>
  <b>CS8</b>: Define o tamanho dos caracteres da comunicação serial, nesse caso cada caractere é composto por 8 bits.<br>
  <b>CLOCAL</b>: Indica que a entrada/saída serial está em modo local, não verificando a presença de um modem ou dispositivo de comunicação.<br>
  <b>CREAD</b>: Indica que a porta serial está pronta para receber dados, ou seja, habilita o receiver.<br>
  <b>TCIFLUSH</b>: Usada para descartar dados na fila de entrada da porta serial que não foram lidos.<br>
  <b>TCSANOW</b>: Aplica imediatamente as alterações nas configurações da porta serial.<br>
  <b>B9600</b>: Representa a velocidade da transmissão serial em baus, assim a velocidade nesse caso é de 9600 bauds.


### Receiver e Transmitter
**Módulo Receiver**

Este módulo é responsável por receber dados seriais e reconstruir um valor de 16 bits a partir desses dados. Ele opera de acordo com uma taxa de baud_rate e detecta o início e o fim da transmissão de dados para coletar os bits intermediários. O modulo foi feito utilizando Verilog comportamental e faz uso de uma FSM de Mealy, com 3 estados.


**Funcionamento:**

1. **START (Estado de Início):** Inicialmente, recived é definido como 0 (indicando que os dados não foram recebidos). O módulo aguarda a detecção de um início de transmissão (nível baixo em in). Quando o início é detectado, o estado muda para DATA.
2. **DATA (Estado de Coleta de Dados):** Neste estado, o módulo coleta bits de dados (in) e armazena-os em buffer. O contador counter é incrementado para rastrear o número de bits recebidos. Quando counter atinge 8 ou 16 bits, o estado muda para STOP.
3. **STOP (Estado de Fim):** O módulo verifica se counter atingiu 16 bits, o que indica que todos os dados foram recebidos. Se todos os bits foram recebidos, os dados são copiados do buffer para data, e recived é definido como 1 (indicando que os dados foram recebidos com sucesso) e o contador é redefinido para 0, preparando o módulo para uma nova transmissão. O estado é então retornado ao START para aguardar a próxima transmissão. Se todos os bits ainda não forem recebidos, o contador não é zerado, porem ele continua indo para o estado de START, para queo segundo byte possa ser lido.

<div align="center">
  <img src="/img/receiver_diagram.png" alt="Diagrama de Estados do Receiver">
   <p>
      Diagrama de Estados do Receiver.
    </p>
</div>

**Módulo Transmitter**

O módulo é responsável por transmitir dados em formato serial. Assim como o receiver ele opera em sincronia com uma taxa de baud_rate e usa um sinal de início (start) para indicar o início da transmissão dos dados. Os dados são transmitidos sequencialmente, começando pelo bit mais significativo, através de 3 bytes. O modulo foi feito utilizando Verilog comportamental e faz uso de uma FSM de Mealy, com 4 estados.

**Funcionamento:**

1. **IDLE (Estado de Inatividade):** Inicialmente, transmitted é definido como 0 (indicando que os dados não foram transmitidos). O módulo aguarda o sinal de início (start). Quando o sinal de início é detectado, o estado muda para START.
2. **START (Estado de Início):** Neste estado, o módulo indica que está aguardando a transmissão(r_wait_transmittion é definido como 1) e define o sinal de saída (out) como 0 para indicar o início da transmissão. O estado muda para DATA.
3.**DATA (Estado de Transmissão de Dados):** Neste estado, o módulo transmite os bits de dados sequencialmente a partir do bit mais significativo. out é definido como o próximo bit de dados a ser transmitido.
r_wait_transmittion é definido como 0 para indicar que não está mais aguardando. O contador counter é decrementado para acompanhar a posição do bit atual. Quando counter atinge valores específicos (15, 7 ou -1), o estado muda para STOP.
4. **STOP (Estado de Parada):** Neste estado, o módulo indica o fim da transmissão de um byte, definindo out como 1 para indicar um nível alto. O estado é então retornado para START para gerar o próximo sinal de início. Quando counter atinge -1, indicando que todos os bits foram transmitidos, transmitted é definido como 1, indicando que a transmissão foi concluída com sucesso, e o estado retorna a IDLE.

<div align="center">
  <img src="/img/transmitter_diagram.png" alt="Diagrama de Estados do Transmitter">
   <p>
      Diagrama de Estados do Transmitter.
    </p>
</div>

### Baud Rate
Este módulo tem a finalidade de gerar um sinal de clock (saída tick) com uma frequência específica de 9600 Hz, que é comumente usada como taxa de transmissão em comunicação serial. O módulo utiliza o clock de entrada (clk) para calcular a frequência desejada.

**Funcionamento:**

Ele utiliza um contador de 28 bits chamado counter para dividir a frequência do clock de entrada (clk) na frequência desejada de 9600 Hz. Como clock de entrada (clk) é de 50 MHz (50 milhões de Hz) e a taxa de transmissão desejada é de 9600 Hz o valor do DIVISOR é calculado como:

<div align="center">
  <img src="/img/calculo_baud_rate.png" alt="Calculo do Divisor do Baud_Rate">
</div>

Em cada ciclo de clock de subida, o contador counter é incrementado em 1. Quando o valor do contador atinge ou excede DIVISOR - 1, ele é redefinido para 0, criando um ciclo de clock dividido. O sinal de saída tick é controlado com base no valor atual do contador. Quando o contador está abaixo da metade do divisor (DIVISOR/2), tick é definido como 1 (nível alto), caso contrário, tick é definido como 0 (nível baixo). Desse moodo gerando um tick com a frequencia desejada.

## DHT11
O sensor DHT11 é um sensor de umidade e temperatura amplamente utilizado em projetos de eletrônica e automação. Ele é conhecido por sua simplicidade de uso e baixo custo. O DHT11 é capaz de medir a temperatura ambiente e a umidade relativa do ar com precisão razoável para aplicações simples.

Além disso, o sensor DHT11 opera de acordo com o seguinte princípio de funcionamento: Quando a FPGA alimenta o sensor, ele inicia a comunicação enviando um sinal de início em nível lógico baixo, mantendo-o assim por 19ms. Em seguida, ele muda para nível lógico alto e aguarda a resposta do sensor.

Após receber o sinal de nível lógico alto, o sensor responde enviando primeiro um pulso em nível lógico baixo por aproximadamente 80us, seguido por um pulso em nível lógico alto também com cerca de 80us. Em seguida, o sensor envia o bit de início (start bit) em nível lógico baixo, indicando o início da transmissão dos dados.

Os dados transmitidos pelo sensor são representados por pulsos em nível lógico alto, e a duração desses pulsos determina se o bit é um "1" ou "0". Se o tempo em que o sinal permanece em nível lógico alto for superior a 50us, isso é interpretado como "1". Caso contrário, se for inferior a 50us, é interpretado como "0".

<p align="center">
  <img src="/img/transmissao.PNG" alt="MCU Sends out Start Signal & DHT Responses">
</p>

O módulo DHT11 é responsável pela comunicação com o sensor DHT11.
Clock de 1 MHz: O módulo utiliza um clock de 1 MHz gerado pelo componente geradorMicrossegundos. Esse clock é obtido a partir de um clock principal de 50 MHz proveniente da FPGA e é utilizado para sincronizar todas as operações de comunicação.

Start_bit: O sinal start_bit desempenha o papel de gatilho para iniciar a comunicação com o sensor DHT11. Quando ativado, ele inicia a troca de dados entre o módulo e o sensor.

DHT_DATA (inout): A porta DHT_DATA é configurada como inout e possui uma função versátil na comunicação. Ela pode atuar tanto como entrada quanto como saída, permitindo uma troca de dados bidirecional entre o módulo e o sensor. O módulo Tristate é responsável por controlar a direção dessa porta (entrada ou saída) e o que está sendo transmitido.

Funcionamento do Módulo: Quando o sinal start_bit é definido como 1, o módulo reage resetando as variáveis index, send (que contém o dado a ser enviado ao sensor), counter, e também o cache utilizado para armazenar os dados recebidos do sensor. Então segue esses estados: 

**Funcionamento do Módulo DHT11:**

1. **IDLE:** Este é o estado inicial em que o módulo aguarda o bit de start para transitar para o estado START. Durante este estado, todas as variáveis mencionadas anteriormente são redefinidas.

2. **START:** O módulo mantém o sinal de dados para o sensor em nível lógico baixo por 19ms e, em seguida, altera-o para nível lógico alto para iniciar a troca de dados no estado DETECT_SIGNAL.

3. **DETECT_SIGNAL:** Neste estado, o módulo continua a enviar nível lógico alto por 20us e, em seguida, altera a direção da porta INOUT para IN para receber os dados do sensor. Em seguida, ele avança para o estado WAIT_DHT11.

4. **WAIT_DHT11:** Este estado aguarda 40us ou a resposta do sensor no nível lógico baixo do DHT11 para prosseguir para o estado DHT11_RESPONSE.

5. **DHT11_RESPONSE:** Aqui, o módulo aguarda até 80us pelo sinal de nível lógico alto do DHT11. Se esse tempo for excedido e o DHT11 ainda estiver em nível lógico baixo, o módulo transita para o estado WAIT_SIGNAL e define a variável "error" como 1. Se o DHT11 enviar nível lógico alto dentro do limite de tempo, ele entra no estado DHT11_HIGH_RESPONSE.

6. **DHT11_HIGH_RESPONSE:** Neste estado, o módulo aguarda mais 80us para que o sensor envie o bit de start (nível lógico baixo), indicando o início da transmissão. Se o tempo limite for excedido, a variável "error" recebe 1, e o próximo estado é WAIT_SIGNAL. Se o bit de start for recebido, o módulo transita para o estado TRANSMIT.

7. **TRANSMIT:** O módulo verifica qual bit está sendo transmitido e aguarda o sensor enviar nível lógico alto por 50us. Se o sensor não responder a tempo, a variável "error" recebe 1, e o próximo estado é WAIT_SIGNAL. Se o sensor responder dentro do limite de tempo, o módulo entra no estado DETECT_BIT.

8. **DETECT_BIT:** Neste estado, o módulo verifica se o bit enviado pelo DHT11 é 1 ou 0 com base na duração do sinal de nível lógico alto. Os resultados são armazenados na variável "temp_data," e o índice é incrementado. O módulo retorna ao estado TRANSMIT até que todos os 40 bits tenham sido recebidos.

9. **WAIT_SIGNAL:** Neste estado, o módulo aguarda aproximadamente 100us para liberar o sinal do DHT11 e, em seguida, altera a direção do INOUT para OUT, enviando nível lógico alto. O módulo então transita para o estado STOP.

10. **STOP:** O módulo verifica se a variável "error" é igual a 1 e, se for o caso, retorna ao estado IDLE.

<p align="center">
  <img src="/img/DHT11OFC.drawio (1).png" alt="Estados da máquina DHT11">
</p>

## Gerenciamento e processamento da informação
Nesta seção, detalharemos o gerenciamento e o processamento da informação no sistema, incluindo:

### Interface
- Nicassio

### Escalonador
O módulo de escalonador foi feito em Verilog Comportamental e atua como um controlador para comunicação com as interfaces dos sensores e o decodificador. O funcionamento desse escalonador é controlado por uma FSM de Mealy, com 17 estados, sendo um estado para executar o comando e um estado para executar o monitoramento contínuo da temperatura e outro para o da umidade de cada sensor. 

**A FSM do módulo funciona do seguinte modo:**

1. **COMMAND (1ºetapa - Comunicação com Sensores):**
Quando dados são recebidos, o módulo começa a processar esses dados. O comando e o endereço são extraídos dos dados recebidos. Dependendo do comando e do endereço, uma das oito interfaces é habilitada para iniciar a comunicação com o sensor específico, solicitando o comando atribuído ou o monitoramento contínuo da temperatura ou umidade de um dos sensores é habilitada ou desabilitada. O estado avança para a próxima etapa assim que a comunicação com o sensor é iniciada.

2. **COMMAND (2ºetapa - Transferência de Dados):** Após a inicialização da comunicação, o escalonador espera que a interface do sensor conclua a transmissão dos dados. Quando a interface do sensor concluir, os dados e a resposta do sensor são lidos e enviados para o decodificador. O decodificador é habilitado, e o estado avança para a próxima etapa.

3. **COMMAND (3ºetapa - Espera pela Conclusão):** O escalonador aguarda até que o decodificador indique que concluiu o processamento e envio dos dados. Após a conclusão, o escalonador desabilita o decodificador e aguarda 1s, tempo necessário para que o sensor esteja apto para o uso novamente. Então o estado é alterado para TEMP_CONT_S1.

4. **TEMP_CONT_S1 (Monitoramento Contínuo de Temperatura do Sensor 1):** Se o monitoramento contínuo de temperatura do sensor 1 estiver habilitado, o escalonador inicia a comunicação com o sensor 1. Depois aguarda a conclusão da transmissão dos dados do sensor. Quando a transmissão é concluída, os dados são enviados ao decodificador. Após a conclusão do decodificador, o escalonador aguarda 1s. Posteriormente a essa espera, o estado é alterado para UMID_CONT_S1. Caso o monitoramento contínuo não esteja ativado ele avança diretamente para o próximo estado, UMID_CONT_S1.

 5. **UMID_CONT_S1 (Monitoramento Contínuo da Umidade do Sensor 1):** Se o monitoramento contínuo da umidade do sensor 1 estiver habilitado, o escalonador inicia a comunicação com o sensor de umidade especificado. Depois aguarda a conclusão da transmissão dos dados do sensor. Quando a transmissão é concluída, os dados são enviados ao decodificador. Após a conclusão do decodificador, o escalonador aguarda 1s. Posteriormente a essa espera o estado é alterado para  TEMP_CONT_S2. Caso o monitoramento contínuo não esteja ativado ele avança diretamente para o próximo estado, TEMP_CONT_S2.

Nos demais estados essa mesma lógica dos estados TEMP_CONT_S1 e UMID_CONT_S2 se repetem, sempre avançando para o estado seguinte, até chegar ao UMID_CONT_S8 que sendo o último monitoramento do último sensor,  retorna para o estado COMMAND. Deste modo para um aumento do número de sensores monitorados bastaria apenas adicionar mais estados para os novos sensores e adaptar o código.

<div align="center">
  <img src="/img/escalonador_diagram.png" alt="Diagrama de Estados do Escalonador">
   <p>
      Diagrama de Estados do Escalonador.
    </p>
</div>




### Decodificador
- Nicassio

## LEs, LABs e Pinos
<div align="center">
  <img src="/img/recursos_placa.PNG" alt="Recursos usados pela placa.">
   <p>
      Resultados de síntese,.
    </p>
</div>

## Conclusões
[Inclua suas conclusões aqui]

## Anexos
<div id="fpgaimg" style="display: inline_block" align="center">
    <img src="/img/KitMERCURIO.png" alt="Kit de desenvolvimento Mercurio IV">
    <p>
      Kit de Desenvolvimento Altera FPGA Mercurio IV.
    </p>
</div>

<div id="dht11img" style="display: inline_block" align="center">
    <img src="/img/sensorDHT11.png" alt="Sensor de Temperatura e Umidade DHT11">
    <p>
      Sensor de Temperatura e Umidade DHT11.
    </p>
</div>
