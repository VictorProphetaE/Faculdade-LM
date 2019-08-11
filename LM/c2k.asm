section .data
  ;*********************************************************************************************
  celsius dw 25, 80, 115, 15  ; VETOR celsius DO TIPO word, SE FOSSE dword SERIA celsius dd 25, 80, 115, 15
  ;*********************************************************************************************
  kelvin dw  0,  0,   0,  0
  aux db 0
  branco db ' '
  eol  db 10 ;nova linha
; kelvin deverá ter 298, 353, 388, 288

;******************************************************************************************************
;ATENÇÃO: EMBORA A INSTRUÇÃO push reg COLOQUE O REGISTRO NA PILHA, ELE NÃO CRIA
;UMA PILHA PARA CADA REGISTRO. ELE SIMPLESMENTE EMPILHA.
;
;ASSIM, QUANDO FAZEMOS NA SEQUENCIA
; push reg1
; push reg2
; push reg3
; ...
;E SE DEPOIS FIZERMOS pop reg1 ESTAREMOS COLOCANDO O VALOR DO TOPO DA PILHA
;EM reg1. OU SEJA, O TOPO DA PILHA TINHA O VALOR DE reg3. É COMO SE FIZÉSSEMOS
;mov reg1,reg3
;
;ASSIM, UMA MANEIRA DE TROCAR VALORES DE REGISTRADORES PODE SER FEITA DA SEGUINTE
;FORMA:
;push rax    ; salvei na pilha rax
;mov rax,rbx ; passei o valor do rbx para rax
;pop rbx     ; recuperei do topo da pilha o antigo valor de rax e coloquei em rbx
;******************************************************************************************************

section .text

  global _start

  _start:
  
  mov rcx,4      ; faremos 4 repeticoes
  xor rsi,rsi
   
  forcx:
    lea rbx, [celsius+rsi]
;************************************************************************************************************************
;SE FIZERMOS mov rax,[rbx], TEREMOS TODOS OS VALORES DO VETOR celsius EM rax DE UMA VEZ SÓ, POIS rax TEM TAMANHO DE 4 WORDS
    mov ax, [rbx]         ; nao é possivel fazer mov [kelvin+rsi],[celsius+rsi], precisa-se de um registrador auxiliar
    add ax, 273           ; soma 273
    mov [kelvin+rsi], ax  ; *(kelvin+rsi)=rax  
	
    push rcx       ;guarda valor antigo do contador, que está sendo usado na repetição do label forcx
    
    ;divide por 10
    xor rcx,rcx           ;xor reg,reg zera reg. Melhor que mov reg, 0
    xor rdx,rdx
    xor rbx,rbx
    _divide:
      mov rbx,10
;********************************************************************************************************
      div bl        ;divide o acumulador ax por 10. Nao se permite div 10, div 3, div 20, etc
      add ah,'0'    ;al quociente, ah é o resto, temos que guardar ah. Não importa o que está em al
;********************************************************************************************************      
      push rax      ;deveria empilhar somente ah, mas temos que empilhar todo o rax

;*********************************************FIZ BURRADA NA AULA, O ARQUIVO DISPONÍVEL SomaNumero.asm ESTAVA CERTO************************************
; POR FAVOR ALTEREM A LINHA DO MESMO ONDE TEM A INSTRUÇÃO and. DEVE FICAR IGUAL A INSTRUÇÃO ABAIXO

      and ax,0x00ff ;zera ah: fica somente com al (ax tem 2 bytes e dois nibble de 1 byte). LEMBRAM QUE EU TINHA COLOCADO and ax,0xff00?
                    ;Como só podemos dividir ax por 10 e não somente al, temos que zerar ah, a parte alta.
;******************************************************************************************************************************************************
      inc rcx       ;conta elementos na pilha
      cmp al,0      ;verifica se o quociente foi zero. Se for zero, acabou o processo de divisao.
      jnz _divide   ;Se o quociente for diferente de zero, salte para o label _divide:
	
    ;imprime elementos da pilha

    _imprimeTopo:
              
       pop rax           ;desempilha rax. O que nos interessa é somente o ah, que já está somado com '0'. O que tem em al não interessa.
       push rcx          ;guarda valor antigo do contador de elementos da pilha, que está sendo usado na repetição do label _imprimeTopo   
       mov byte [aux],ah ; pega o resto e guarda na variável aux. No endereço de aux
       mov eax,4         ;escrita
       mov ebx,1         ;fd=1, na tela
       mov ecx,aux       ;&buffer a ser impresso, no caso um caractere só
       mov edx,1         ;tamanho a ser gravado. Se é um caractere só, o tamanho é 1. 
       int 0x80
	
       pop rcx        ;recupera o tamanho da pilha
       dec rcx         ;atualiza o tamanho
       cmp rcx,0
       jnz _imprimeTopo
    
    mov eax,4      ;escrita
    mov ebx,1      ;fd=1, na tela
    mov ecx,branco ;&buffer a ser impresso, no caso um caractere só
    mov edx,1      ;tamanho a ser gravado. Se é um caractere só, o tamanho é 1. 
    int 0x80   
    ;********************************************************************************************
    add rsi,2      ; DESLOCAMENTO DE 2 EM 2 BYTES. WORD TEM 2 BYTES. dword tem 4 bytes
    ;********************************************************************************************
    pop rcx        ; recupera o número de iterações do label forcx
    dec rcx         ; decrementa
    cmp rcx,0
    jnz forcx
  ;***********************************************************************
  ;PULA LINHA   
  mov eax,4      ;escrita
  mov ebx,1      ;fd=1, na tela
  mov ecx,eol    ;&buffer a ser impresso, no caso um caractere só
  mov edx,1      ;tamanho a ser gravado. Se é um caractere só, o tamanho é 1. 
  int 0x80   
  
  mov rax,1
  mov rbx,0
  int 0x80
		
