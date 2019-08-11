section .data
  ;=========================================================================================================
  ;Na plataforma windows, o pulo de linha deveria ser a junção do codigo 10 (0xA) e o codigo 13 (0xD)
  ;No linux, só precisa do 10

  msgLendo   db 'Entre com o seu nome: '   ;definição de uma string
  TAM_MSG_LENDO equ $-msgLendo
  msgBenvindo db 'Seja bem vindo '
  TAM_MSG_BENVINDO equ $-msgBenvindo
  TAM_MAX  equ 20
  strNome times 20 db 0
  tNome db 0

;enddata


section .text
  global _start

  _start:

  mov rax,4             ; escrita
  mov rbx,1             ; fd=1, na tela
  mov rcx,msgLendo      ;buffer a ser gravado
  mov rdx,TAM_MSG_LENDO ;tamanho a ser gravado 
  int 0x80

  mov rax,3             ; leitura
  mov rbx,0             ; fd = 0, teclado
  mov rcx,strNome       
  mov rdx,TAM_MAX       ;tamanho maximo de leitura
  int 0x80              ;faz a chamada de leitura, guarda em eax O tamanhoDigitado + 1 (devido ao <ENTER>)
  mov [tNome],rax
  mov byte [strNome+rax],10 
 
  mov rcx,10
  for10:
    mov rax,4                ; escrita
    mov rbx,1                ; fd=1, na tela
  
    mov rcx,msgBenvindo      ;buffer a ser gravado
    mov rdx,TAM_MSG_BENVINDO ;tamanho a ser gravado 
    int 0x80
    
    mov rax,4
    mov rbx,1
    mov rcx,strNome
    mov rdx,[tNome]
    int 0x80
    
    dec rcx
    jnz for10

    
