;compilar:   nasm -g -f elfx lesenha.asm  onde x=32 ou x=64
;linkeditar: ld lesenha.o  -o lesenha
;executar:   ./lesenha

section .data
  ;=========================================================================================================
  ;Na plataforma windows, o pulo de linha deveria ser a junção do codigo 10 (0xA) e o codigo 13 (0xD)
  ;No linux, só precisa do 10

  msgLendo   db 'Entre com a senha: '   ;definição de uma string
  TAM_MSG_LENDO equ $-msgLendo
  msgCongrat db 'Parabens, esta se tornando um Hacker',10,13
  TAM_MSG_CONG equ $-msgCongrat
  msgErro db 'Senha inconsistente',10,13
  TAM_MSG_ERRO equ $-msgErro
  TAM_MAX  equ 10
  strLida times 10 db 0

;enddata

section .text

  global _start

  _start:
  
    ;syscall write(4), retorna quantidade gravada em eax
    mov eax,4             ; escrita
    mov ebx,1             ; fd=1, na tela
    mov ecx,msgLendo      ;buffer a ser gravado
    mov edx,TAM_MSG_LENDO ;tamanho a ser gravado 
    int 0x80
  
    mov eax,3             ; leitura
    mov ebx,0
    mov ecx,strLida       
    mov edx,TAM_MAX       ;tamanho maximo de leitura
    int 0x80              ;faz a chamada de leitura, guarda em eax O tamanhoDigitado + 1 (devido ao <ENTER>)
    cmp eax,0
    jz  falha
    xor esi,esi
  
    cmp byte [strLida+esi],33h  ; compara com '3'
    jne falha
    inc esi
    cmp byte [strLida+esi],39h  ; compara com '9'
    jne falha
    inc esi
    cmp byte [strLida+esi],37h  ; compara com '7'
    jne falha
    inc esi
    cmp byte [strLida+esi],31h  ; compara com '1'
    jne falha 
    mov eax,4
    mov ebx,1
    mov ecx,msgCongrat
    mov edx,TAM_MSG_CONG
    int 0x80
    jmp fim

  falha:
    mov eax,4
    mov ebx,1
    mov ecx,msgErro
    mov edx,TAM_MSG_ERRO
    int 0x80

  fim:
    mov eax,1
    mov ebx,0
    int 0x80

  
  
