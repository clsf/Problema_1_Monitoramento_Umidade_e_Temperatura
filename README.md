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
