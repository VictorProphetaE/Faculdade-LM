;**************************
;Compilar : nasm -g -f elf64 movsb123.asm  (isso cria movsb123.o)
;Linkar   : ld movsb123.o -o movsvb123  (cria movsb123 como executável)
;Depois de entender usando o edb,
;criar um programa com o nome movsb.asm que 
;copia str1 em str2, imprime str2 e pula uma linha
;sendo que str1 deve conter Computação e não Computacao
;Tá quase pronto, é só modificar umas coisinhas
;                                        ****************

section .data
  str1 db 'Computacao',0
  str2 times 15 db 0
  tam  db 0
  pula  db '123' ;observar no endereço de pula
                 ;através do edb, depois modificar para pula db 10
                 
  tpula equ $-pula 
section .text
   global _start

_start:
   ;aqui funciona
   mov rax,4          ;escrita
   mov rbx,1          ;fd=1, na tela
   mov rcx,pula       ;&buffer a ser impresso
   mov rdx,tpula      ;tamanho a ser gravado 
   int 0x80
   
   mov rdi,str1
   mov rcx,-1
   xor al,al
   cld
   repne scasb
   not rcx
   dec rcx
   
   mov [tam],rcx ; se colocar mov [tam],rcx a memoria ou vetor 
                 ; pula será sobreposto com NULL
                 ; o correto pode ser mov [tam],cl
                 ; ou defnir tam como dq no lugar de db
   mov rsi,str1
   mov rdi,str2
   cld
   rep movsb
   mov rbx, [tam]
   
   ;mov byte [str2+rbx],10 
   mov rax,4
   mov rbx,1      ; tela
   mov ecx,str2   ; buffer
   mov rdx,[tam]
   ;inc rdx
   int 0x80
   
   ;deveria funcionar
   mov rax,4          ;escrita
   mov rbx,1          ;fd=1, na tela
   mov rcx,pula       ;&buffer a ser impresso
   mov rdx,tpula      ;tamanho a ser gravado 
   int 0x80
   
  ;exit 0 
   mov rax,1     
   mov rbx,0    
   int 0x80
   
