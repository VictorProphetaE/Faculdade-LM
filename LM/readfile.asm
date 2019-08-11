;compilar:   nasm -f elfx readfile.asm  onde x=32 ou x=64
;linkeditar: ld readfile.o  -o readfile
;executar:   ./readfile


;=========================================================================================================  
;AS MACROS DEVEM SER DECLARADAS ANTES DOS section
;=========================================================================================================  

%include "mymacros.inc"   ;INCLUI UM ARQUIVO DE MACROS DE NOME mymacros.inc

section .data
  ;=========================================================================================================
  ;Na plataforma windows, o pulo de linha deveria ser a junção do codigo 10 (0xA) e o codigo 13 (0xD)
  ;No linux, só precisa do 10

  msgLendo              db 'Lendo o arquivo',10   ;definição de uma string
                          
  ;=========================================================================================================  
  ;CALCULO DO TAMANHO DE UMA STRING
  ;O $ é entendido pelo nasm como posicao após a string msgLendo. msgLendo tem tamanho 16, incluindo o valor 10
  ;Supondo que msgLendo começasse no endereço DS:0035, iria até DS:0050. Assim, 0051-0035=16
  ;Exemplo : str db 'Teste', que começasse numa posição 15 da memória
  ;                  15 :16 : 17:18 :19 :20
  ;                   |   |   |   |   |  |
  ;                   v   v   v   v   v  v 
  ;Seria assim, str=|'T'|'e'|'s'|'t'|'e'|$|
  ;                                          
  TAM_MSG_LENDO         equ $-msgLendo  
  buffLeitura  times 80 db 0     ;preenche um vetor com 80 zeros
  TAM_BUFF_READ         equ 80            ;declaração de constante (em  C, seria #define TAM_BUFF_READ 80)
  arquivo               db 'teste.txt',0 ; esse zero é algo semelhante ao '\0' da linguagem C

  ;**********************************************************************************************************
  MODO                 db "O_RDWR"   ;leitura e escrita, funciona quando se usa tipo .str 
  ;**********************************************************************************************************

  msgErroAbertura       db "Erro na abertura do arquivo",10,13
  TAM_MSG_ERRO_ABERTURA equ $-msgErroAbertura   
  msgErroLeitura        db "Erro na leitura do arquivo",10,13
  TAM_MSG_ERRO_LEITURA  equ $-msgErroLeitura
  fd                    db  0    ;variável para guardar o descritor do arquivo
  tamLido               db  0    ;variável para guardar a quantidade de caracteres lida (tamanho lido)
  crlf                  db  0xd,0xa ;carriage return, line feed
  ;=========================================================================================================
  ;Valores para MODO de acesso. Quando abrimos um arquivo em READ_ONLY outro usuario nao pode alterá-lo
  ;========================================================================================================= 
  
  O_RDONLY              equ 0    ;somente leitura
  O_WRONLY              equ 1    ;somente escrita
  O_RDWR                equ 2    ;leitura e escrita
  O_TRUNC               equ 512  ;abre e limpa o arquivo
  O_APPEND              equ 1024 ;inserir no final
  ;=========================================================================================================
  ;VALORES DE MODO DE ACESSO EM DECIMAL E OCTAL (começa com 0 é octal)
  ;=========================================================================================================
  ; ACESSO     	       DECIMAL	          OCTAL 
  ;O_RDONLY     	     0               00
  ;O_WRONLY     	     1               01
  ;O_RDWR      		     2               02
  ;O_CREAT        	    64             0100
  ;O_EXCL                  128             0200
  ;O_TRUNC                 512            01000
  ;O_APPEND               1024            02000
  ;O_DIRECT              16384           040000
  ;O_NOFOLLOW           131072          0400000
  ;O_FSYNC             1052672         04010000
  ;---------------------------------------------------------------------------------------------------------
  ;=========================================================================================================
  ;VALORES DE PERMISSAO DE ARQUIVO
  ;=========================================================================================================
  ;  USER  | GROUP  | OTHER
  ; R W X  | R W X  | R W X 
  ; A permissao é composta de 9 bits, 3 para USER, 3 para GROUP, e 3 para OTHER
  ; Por exemplo, se somente W e X de USER estivessem setados, o valor de permissao seria 011 000 000.
  ; Isso é equivalente em decimal a 0300, coloca-se um zero antes, por comodidade.
  ; Repare que se somente W fosse setado, teria o valor 2 ou 010, se somente R fosse setado, teria o valor
  ; 4, se somente X fosse setado, teria o valor 1. Assim 011=3, ou seja 2+1=3. Logo associamos os valores 
  ; R=4, W=2, X=1, em ordem decrescente de potência  de 2. Logo, se quero leitura e escrita e execução 
  ; para USER e somente leitura e execução para GROUPteríamos 0750. É assim no linux, com a atribuição 
  ; pelo comando chmod.

;end .data

;************************************************************************************************************
;MAIS INFORMACOES SOBRE ARQUIVOS OU FICHEIROS
;http://web.fe.up.pt/~jmcruz/etc/unix/Unix.pdf
;http://www.gsp.com/cgi-bin/man.cgi?section=2&topic=open
;************************************************************************************************************


section .text
  global _start
 
_start:
  ;syscall write(4), retorna quantidade gravada em eax
  ;mov eax,4             ; escrita
  ;mov ebx,1             ; fd=1, na tela
  ;mov ecx,msgLendo      ;buffer a ser gravado
  ;mov edx,TAM_MSG_LENDO ;tamanho a ser gravado 
  ;int 0x80
  _printf msgLendo, TAM_MSG_LENDO
 ;syscall open(5), retorna fd em eax
  mov eax,5         ; open
  mov ebx,arquivo
  mov ecx,O_RDONLY ; modo de abertura, leitura
  mov edx,0700 ;permissao do arquivo 
  int 0x80
  
  mov [fd], eax     ; salva fd  
  
  cmp eax,0
  jb ERRO_ABERTURA ;salta para o label ERRO_ABERTURA se eax < 0 (jump if below, salta se abaixo)
  
  ;syscall read(3), retorna quantidade lida em eax,
  ;o conteúdo lido fica em buffLeitura
  xor eax,eax

  mov eax, 3              ;read
  mov ebx, [fd]           ;fd do ARQUIVO 
  mov ecx, buffLeitura    ;buffLeitura é o vetor onde será lido o arquivo 
  mov edx, TAM_BUFF_READ  ;tamanho máximo do buffLeitura
  int 0x80

  ;------------------------------------------------------------------------------
  ;SALVANDO O TAMANHO LIDO
  ;------------------------------------------------------------------------------
  mov [tamLido], eax ; salva o tamanho lido

  cmp eax,0          ; verifica se conseguiu ler algo
  jb ERRO_LEITURA    ; salta para rotina de erro de leitura se algo deu errado
    
  ;----------------------------------------------------------------------------
  ;AGORA VAMOS IMPRIMIR O QUE FOI LIDO NO buffLeitura
  ;----------------------------------------------------------------------------
  
  mov eax,4           ; escrita
  mov ebx,1           ;fd=1, tela
  mov ecx,buffLeitura ;buffer a ser gravado
  mov edx,[tamLido]            
  int 0x80

  _exit 0   ;chama a macro _exit

  ;----------------------------------------------------------------------------
  ;FECHA A BAGAÇA
  ;----------------------------------------------------------------------------
  ;syscall close(6)
  mov eax,6
  mov ebx,[fd]  ; fd, o descritor do arquivo
  int 0x80
  
  _exit 0      ;chama macro _exit, exit(0), saida OK

  ;----------------------------------------------------------------------------
  ;Rotina para mensagem de erro de abertura do arquivo
  ;----------------------------------------------------------------------------
ERRO_ABERTURA:
  ;syscall write(4)
  mov eax,4                     ;escrita
  mov ebx,1                     ;fd=1, na tela
  mov ecx,msgErroAbertura     ;buffer a ser gravado
  mov edx,TAM_MSG_ERRO_ABERTURA ;tamanho a ser gravado 
  int 0x80
  jmp SAI 

  ;----------------------------------------------------------------------------
  ;Rotina para mensagem de erro de leitura
  ;----------------------------------------------------------------------------
ERRO_LEITURA:
  ;syscall write(4)
  mov eax,4                    ; escrita
  mov ebx,1                    ; fd=1, na tela
  mov ecx,msgErroLeitura       ;buffer a ser gravado
  mov edx,TAM_MSG_ERRO_LEITURA ;tamanho a ser gravado 
  int 0x80

SAI:
  _exit 1 ;exit(1), deu caca

;end .text  





