;Compilar : nasm -g -f elf64 t4.asm  (isso cria teste.o)
;Linkar   : ld t4.o -o t4  (cria teste como executável)
;----------------------------------------------
;Alunos: Victor Propheta Erbano		RGM:021052
;Linguagens de Montagem
;Prof. Dr. Osvaldo Vargas Jaques
;----------------------------------------------
section .data
;********************
;Parte das mensagens
;********************
  MsgNum1          db 'Entre com a frase: '
  tMsgNum1        equ $- MsgNum1 				;  é a posição após a alocação de bytes por MsgNum1
  MsgNum2          db 'Entre com a palavra a ser procurada: '
  tMsgNum2        equ $- MsgNum2 				; é a posição após a alocação de bytes por MsgNum2
  MsgNum3     	   db 'Entre com a palavra a ser trocada: '
  tMsgNum3   	  equ $- MsgNum3 				; é a posição após a alocação de bytes por MsgNum3
  MsgResultado 	   db 'Resultado da troca'
  tMsgResultado	  equ $- MsgResultado 			; é a posição após a alocação de bytes por MsgResultado
  MsgErro		   db 'Palavra não existe'
  tMsgErro		  equ $- MsgErro				; é a posição após a alocação de bytes por MsgErro
  MsgErroTamanho	db 'Palavra maior que a frase'
  tMsgErroTamanho	equ $- MsgErroTamanho		; é a posição após a alocação de bytes por MsgErro de tamanho
;*******************
;Parte das strings
;******************
  str1 times 200 db 0; mesmo que char strNum1[]={0,0,0,...,0}, um vetor com 10 celulas e zerado
  tam1          dq 0
  str2 times 200 db 0
  tam2          dq 0
  str3 times 200 db 0
  tam3			dq 0
  strres times 200 db 0
  tamres 		dq 0
  buffer  equ  200
  porMax dq 0
  aux    dq 0
  aux1   dq 0
  
;******
;Extras
;******
  pula  db 10 ;observar no endereço de pula
                 ;através do edb, depois modificar para pula db 10           
  tpula equ $-pula 
;enddata  

section .text
  global _start

  _start:
  
;*********************
;Leitura da Frase
;*********************

  mov rax,4             ; escrita
  mov rbx,1             ; fd=1, na tela
  mov rcx,MsgNum1       ;buffer a ser gravado
  mov rdx,tMsgNum1	    ;tamanho a ser gravado 
  int 0x80
  
  mov rax,3				;leitura
  mov rbx,0				;teclado
  mov rcx,str1 			;buffer a ser lido    
  mov rdx,buffer		;tamanho maximo
  int 0x80
 
  dec rax				;decrementa o ENTER
  mov [tam1],rax     	 ;tam 1 recebe o tamanho final de rax
    

;**********************************
;Leitura da Palavra a ser procurada
;**********************************

  mov rax,4             ; escrita
  mov rbx,1             ; fd=1, na tela
  mov rcx,MsgNum2       ;buffer a ser gravado
  mov rdx,tMsgNum2	    ;tamanho a ser gravado 
  int 0x80
  
  mov rax,3				;leitura
  mov rbx,0				;teclado
  mov rcx,str2 			;buffer a ser lido
  mov rdx,buffer		;tamanho maximo
  int 0x80

  dec rax				;decrementa o ENTER
  mov [tam2],rax		;tam 2 recebe o tamanho final de rax
  	
;********************************
;Leitura da Palavra a ser Trocada
;********************************

  mov rax,4             ; escrita
  mov rbx,1             ; fd=1, na tela
  mov rcx,MsgNum3       ;buffer a ser gravado
  mov rdx,tMsgNum3	    ;tamanho a ser gravado 
  int 0x80
 
  mov rax,3				;leitura
  mov rbx,0				;teclado
  mov rcx,str3 			;buffer a ser lido
  mov rdx,buffer     	;tamanho maximo
  int 0x80

  dec rax				;decrementa o ENTER
  mov [tam3],rax		;tam 3 recebe o tamanho final de rax

;**************************************
;Substituição de string
;**************************************

  mov rsi, str2 		;guarda o conteudo da string 2
  xor rbx,rbx			;zera rbx
  xor rax,rax			;zera rax
  xor rcx,rcx			;zera rcx

  mov rax,[tam1] 		;rax recebe tamanho de 1
  mov rcx,[tam2]		;rcx recebe tamanho de 2
  
  cmp rax,rcx			;compara os valores de rax com rcx
  jl erroTam			;após comparação pula para erro de tamanho
  mov [porMax],rax		;por max recebe o tamanho de rax
  sub [porMax],rcx		;por max subtrai o valor guardado com o rcx
 
loop:
	lea rsi,[str2]		;pega o endereço de str2 e coloca como indice
	lea rdi,[str1+rbx]	;pega o endereço de str1 mais rbx e coloca como destino
	mov rcx,[tam2]		;guarda o tamanho da string 2 em rcx
	cld					;reseta flag de direção (DF = 0)
	rep cmpsb			;repetir enquanto cx diferente de zero CoMPara String

	jz aceita			;caso palavra achada ele pula para aceita
	inc rbx				;incrementa o rbx
	mov rax,rbx			;rax recebe rbx 
	add rax,[tam2]		;soma rax com o tamanho da str 2
	cmp [porMax],rax	;compara rbx com por Max
	jl erro				;pula para erro caso não tenha achado a palavra
	jnz loop			;pula para o começo do loop

;****************************
;Erro de tamanhos diferentes
;***************************
erroTam:
    mov rax,4				;escrita
    mov rbx,1				;fd=1, na tela
    mov rcx,MsgErroTamanho	;buffer a ser gravado 
    mov rdx,tMsgErroTamanho	;tamanho a ser gravado 
    int 0x80
    
   mov rax,4          ;escrita
   mov rbx,1          ;fd=1, na tela
   mov rcx,pula       ;&buffer a ser impresso
   mov rdx,tpula      ;tamanho a ser gravado 
   int 0x80
;****
;exit
;****
  mov rax,1     
  mov rbx,0    
  int 0x80

;*************************
;Caso não exista a palavra
;*************************
	
erro:
    mov rax,4			;escrita
    mov rbx,1			;fd=1, na tela
    mov rcx,MsgErro		;buffer a ser gravado 
    mov dl,tMsgErro		;tamanho a ser gravado 
    int 0x80
    
   mov rax,4          ;escrita
   mov rbx,1          ;fd=1, na tela
   mov rcx,pula       ;&buffer a ser impresso
   mov rdx,tpula      ;tamanho a ser gravado 
   int 0x80
  
;*****
;exit
;*****
  mov rax,1     
  mov rbx,0    
  int 0x80

;***********************
;Aceitação da palavra
;***********************
aceita:
	
   lea rsi,[str1]		;pega o endereço de str1 e coloca como indice
   lea rdi,[strres]		;pega o endereço de str res e coloca como destino
   mov rcx,rbx			;guarda rbx em rcx
   cld					;reseta flag de direção (DF = 0)
   rep movsb			;repetir enquanto cx diferente de zero MOVe String
 
   lea rsi,[str3]		;pega o endereço de str3 e coloca como indice 
   lea rdi,[strres+rbx]	;pega o endereço de str res + o valor de rbx e coloca como destino
   mov rcx,[tam3]		;guarda o tamanho da string 3 em rcx
   cld					;reseta flag de direção (DF = 0)
   rep movsb 			;repetir enquanto cx diferente de zero MOVe String
   
   
   xor rax,rax   		;zera rax

   mov rax,[tam2]		;guarda o tamanho da string 2 em rax
   add rax,rbx			;(rbx+t2)
    

   xor rdx,rdx			;zera rdx
   mov rdx,strres		;guarda o tamanho da str res em rdx
   add rdx,rbx			;(strres+bx)
  
   mov rcx,[tam1]		;guarda o tamanho da string 1 em rcx
   mov [aux1],rcx		;aux1 recebe rcx
   sub [aux1],rbx		;subtrai rbx de aux1
  
   lea rsi,[str1+rax]   ;str1+rbx+t2
   add rbx,[tam3]		;adiciona tam 3 em rbx
   lea rdi,[strres+rbx] ;strres+rbx+tam3
   mov rcx,[tam1]		;rcx recebe valor de tam 1
   sub rcx,rax 			;rcx=tam-(rbx+tam2)
   cld					;reseta flag de direção (DF = 0)
   rep movsb			;repetir enquanto cx diferente de zero Move String byte

;*****************************************************************
   ;pegar tamanho de strres 
   
   xor rax,rax      	;zera rax
   mov rcx,-1       	;procura nulo = '\0'
   mov rdi,strres   	;move strres para o destino
   cld					;reseta flag de direção (DF = 0)
   repnz scasb    		;compara o byte em AL com o byte no [ES: DI] ou [ES: EDI], cx = - tamanho –2

   not rcx  			;cx = - tamanho +1
   dec rcx  			;cx = - tamanho 

   mov [tamres],rcx		;tam res recebe o tamanho final da frase
;*****************************************************************
   mov rax,4 			;escrita
   mov rbx,1			;fd=1, na tela
   mov rcx,strres		;Imprime o resultado final de str res
   mov rdx,[tamres]		;Imprime o tamanho da frase
   int 0x80

   mov rax,4          ;escrita
   mov rbx,1          ;fd=1, na tela
   mov rcx,pula       ;&buffer a ser impresso
   mov rdx,tpula      ;tamanho a ser gravado 
   int 0x80

;******
;exit
;****** 
  mov rax,1     
  mov rbx,0    
  int 0x80
