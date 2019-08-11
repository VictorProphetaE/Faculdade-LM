.data
   msgNome 'Entre com seu nome:  '
   tmsgNome equ $-msgNome
   msgBoaTarde 'Boa tarde '
   tmsBoaTarde equ $-msBoaTarde
   tamLido db 0
   Buffer times 40 db 0
   
.text
   global _start
   _start:
   mov rax,4 ; gravacao/impressao
   mov rbx,1 ; fd de tela, logo impressao
   mov rcx,msgNome  ; endereco da string a gravar/imprimir
   mov rdx,tmsgNome ; quantidade de caracteres que irá imprimir a partir de msgNome[0] 
   int 0x80 ;chama a interrupcao

   mov rax,3 ; leitura
   mov rbx,0 ; fd de teclado
   mov rcx,Buffer  ; endereco da string a guardar o que digitar
   mov rdx,40 ; tamanho maximo a ser lido 
   int 0x80 ;chama a interrupcao, retorna o tamanho lido em ax
  
   dec ax  ; ax=ax-1, diminui devido ao enter que é considerado parte do buffer lido
   mov [tamlido],ax  ; guarda na variável tamlido[0] o tamanho lido
   ; ou push rax, guarda na pilha o conteúdo de rax, e depois pode ser recuperado com pop registrador (rax, rbx)
   ; MAIS TARDE
  
   mov rax,4 ; gravacao/impressao
   mov rbx,1 ; fd de tela, logo impressao
   mov rcx,msgBoaTarde  ; endereco da string a gravar/imprimir
   mov rdx,tmsgBoaTarde ; quantidade de caracteres que irá imprimir a partir de msgNome[0] 
   int 0x80 ;chama a interrupcao
   
   mov rax,4 ; gravacao/impressao
   mov rbx,1 ; fd de tela, logo impressao
   mov rcx,Buffer  ; endereco da string a gravar/imprimir
   mov dx,[tamlido] ; quantidade de caracteres que irá imprimir a partir de msgNome[0] 
   int 0x80 ;chama a interrupcao 

   mov rax,1  ;exit
   mov rbx,0  ;exit(0)
   int 0x80 
   
