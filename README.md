# Códigos em Assembly

## SomaNumero.asm

Este código tem como objetivo ler dois números em formato de string, convertê-los para valores numéricos e realizar a soma entre eles. Em seguida, o resultado é exibido na tela.

### Como compilar e executar

Para compilar o código, utilize o seguinte comando:

    nasm -g -f elfX SomaNumero.asm

Substitua o X pelo valor 64 ou 32, dependendo da arquitetura do seu sistema.

Em seguida, para realizar o link e gerar o executável, utilize o comando:

    ld SomaNumero.o -o SomaNumero

## Como utilizar

Ao executar o programa, será solicitado que você insira dois números. Digite-os e pressione Enter.

Após isso, o programa irá realizar a soma e exibir o resultado na tela.

## t4.asm

Este código tem como objetivo ler uma frase, uma palavra a ser procurada nessa frase e uma palavra a ser trocada pela palavra encontrada. Em seguida, ele realiza a troca da palavra encontrada pela palavra desejada na frase.

### Como compilar e executar

Para compilar o código, utilize o seguinte comando:

    nasm -g -f elf64 t4.asm

Em seguida, para realizar o link e gerar o executável, utilize o comando:

    ld t4.o -o t4

## Como utilizar

Ao executar o programa, será solicitado que você insira uma frase. Digite-a e pressione Enter.

Em seguida, será solicitado que você insira uma palavra a ser procurada dentro da frase. Digite-a e pressione Enter.

Após isso, será solicitado que você insira uma palavra a ser trocada pela palavra encontrada na frase. Digite-a e pressione Enter.

O programa irá realizar a troca da palavra encontrada pela palavra desejada na frase e exibir o resultado na tela.

## mymacros.inc

Este arquivo contém as macros utilizadas nos códigos SomaNumero.asm e t4.asm.

### Como compilar e executar

Os códigos em Assembly são compilados e executados utilizando o NASM e o LD.

Para compilar um código em Assembly, utilize o seguinte comando:

    nasm -g -f elfX nome_do_arquivo.asm

Substitua o X pelo valor 64 ou 32, dependendo da arquitetura do seu sistema.

Após a compilação, para realizar o link e gerar o executável, utilize o seguinte comando:

    ld nome_do_arquivo.o -o nome_do_arquivo

Por fim, execute o programa gerado utilizando o comando:

    ./nome_do_arquivo

## aulaLeitura.asm

Esse código faz a leitura de um nome digitado pelo usuário e o imprime na tela junto com uma mensagem de "Boa tarde". Para fazer o código funcionar, você precisa seguir os seguintes passos:

### Como compilar e executar

Os códigos em Assembly são compilados e executados utilizando o NASM e o LD.

Para compilar um código em Assembly, utilize o seguinte comando:
    
    nasm -f elf64 aulaLeitura.asm

Substitua o X pelo valor 64 ou 32, dependendo da arquitetura do seu sistema.

Após a compilação, para realizar o link e gerar o executável, utilize o seguinte comando:

    ld -o aulaLeitura aulaLeitura.o

Por fim, execute o programa gerado utilizando o comando:

    ./aulaLeitura

## c2k.asm

Esse código faz a conversão de uma temperatura em Celsius para Kelvin. Para fazer o código funcionar, você precisa seguir os seguintes passos:

### Como compilar e executar

Os códigos em Assembly são compilados e executados utilizando o NASM e o LD.

Para compilar um código em Assembly, utilize o seguinte comando:
    
    nasm -f elf64 c2k.asm

Substitua o X pelo valor 64 ou 32, dependendo da arquitetura do seu sistema.

Após a compilação, para realizar o link e gerar o executável, utilize o seguinte comando:

    ld -o c2k c2k.o

Por fim, execute o programa gerado utilizando o comando:

    ./c2k
    
## lesenha.asm

Esse código faz a leitura de uma senha digitada pelo usuário e verifica se ela está correta. Caso esteja correta, imprime uma mensagem de parabéns. Caso contrário, imprime uma mensagem de erro. Para fazer o código funcionar, você precisa seguir os seguintes passos:

### Como compilar e executar

Os códigos em Assembly são compilados e executados utilizando o NASM e o LD.

Para compilar um código em Assembly, utilize o seguinte comando:
    
    nasm -f elf64 lesenha.asm

Substitua o X pelo valor 64 ou 32, dependendo da arquitetura do seu sistema.

Após a compilação, para realizar o link e gerar o executável, utilize o seguinte comando:

    ld -o lesenha lesenha.o

Por fim, execute o programa gerado utilizando o comando:

    ./lesenha

## readfile.asm

Esse código faz a leitura de um arquivo de texto e imprime o seu conteúdo na tela. Para fazer o código funcionar, você precisa seguir os seguintes passos:

### Como compilar e executar

Os códigos em Assembly são compilados e executados utilizando o NASM e o LD.

Para compilar um código em Assembly, utilize o seguinte comando:
    
    nasm -f elf64 readfile.asm

Substitua o X pelo valor 64 ou 32, dependendo da arquitetura do seu sistema.

Após a compilação, para realizar o link e gerar o executável, utilize o seguinte comando:

    ld -o readfile readfile.o

Por fim, execute o programa gerado utilizando o comando:

    ./readfile
