# Problema_1_Monitoramento_Humidade_e_Temperatura
Problema 1 da disciplina de Sistemas Digitais - Monitoramento de Temperatura e Humidade 

## Introdução
Neste projeto, apresentamos uma contextualização do desenvolvimento do sistema Nirvan.

## :student: Equipe de desenvolvimento
- Antonio
- Cláudia
- Luis
- Nirva

## :man_teacher: Tutor
- Thiago Jesus

## :page_facing_up: Sumário
- [Recursos utilizados](#recursos-utilizados)
- [Como executar](#como-executar)
  - [Em C](#em-c)
  - [FPGA](#fpga)
- [Exemplo de montagem](#exemplo-de-montagem)
- [UART](#uart)
  - [Escrita e Leitura em C](#escrita-e-leitura-em-c)
  - [Receiver e Transmitter](#receiver-e-transmitter)
  - [Baud Rate](#baud-rate)
- [DHT](#dht)
  - [Fundamentação teórica e módulo](#fundamentação-teórica-e-módulo)
- [Gerenciamento e processamento da informação](#gerenciamento-e-processamento-da-informação)
  - [Interface](#interface)
  - [Escalonador](#escalonador)
  - [Decodificador](#decodificador)
- [Conclusões](#conclusões)
- [Anexos](#anexos)


## Recursos utilizados 
Nesta seção, descreveremos os recursos utilizados no projeto Nirvan.

## Como executar
Nesta seção, forneceremos instruções sobre como executar o projeto Nirvan nas seguintes abordagens:

### Em C
- Nirvan

### FPGA
- Cláudia

## Exemplo de montagem
Nesta seção, apresentaremos um exemplo de montagem do sistema Nirvan.

## UART
Nesta seção, abordaremos aspectos relacionados à comunicação UART, incluindo:

### Escrita e Leitura em C
- Nirvan

### Receiver e Transmitter
- Luis

### Baud Rate
- Luis

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
  <img src="/img/DHT11OFC.drawio(1).png" alt="Estados da máquina DHT11">
</p>

## Gerenciamento e processamento da informação
Nesta seção, detalharemos o gerenciamento e o processamento da informação no sistema Nirvan, incluindo:

### Interface
- Nicassio

### Escalonador
- Luis

### Decodificador
- Nicassio

## Conclusões
[Inclua suas conclusões aqui]

## Anexos
[Adicione anexos relevantes, como documentos, diagramas, ou qualquer outra informação complementar.]
