;--------------------------------------------------
;MACRO DE SAIDA
;
;--------------------------------------------------
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Aluno: Victor Propheta Erbano
;RGM: 021052
;Materia: LM
;Prof: Osvaldo
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;=============================================================
;Leitura do primeiro numero
;=============================================================
%macro _leitura 2
  mov eax,4             ;escrita
  mov ebx,1             ;fd=1, na tela
  mov ecx,%1       ;buffer a ser gravado
  mov edx,%2      ;tamanho a ser gravado 
  int 0x80
  
  mov eax,3       ;leitura
  mov ebx,0       ;teclado
  mov ecx,strNum1 ;buffer a ser lido
  mov edx,10 ;tamanho maximo
  int 0x80   ; apos a leitura do teclado guarda o tamanho lido em rax
  mov [tamNum1],al  ;pega o tamanho da string lida
  dec byte [tamNum1]; guarda tamanho lido + ENTER
%endmacro

;=============================================================
;Leitura do segundo numero
;=============================================================  
%macro _leitura2 2
  mov eax,4          ;escrita
  mov ebx,1          ;fd=1, na tela
  mov ecx,%1    ;buffer a ser gravado
  mov edx,%2   ;tamanho a ser gravado 
  int 0x80
  
  mov eax,3          ;leitura
  mov ebx,0          ;teclado
  mov ecx,strNum2    ;buffer a ser lido
  mov edx,10   ;tamanho maximo
  int 0x80
  mov [tamNum2],al          ;pega o tamanho da string lida
  dec byte [tamNum2]
%endmacro

;=============================================================
;Imprime mensagem Resultado:
;=============================================================
%macro _resultado 2
  push rcx   ;salva o contador, pois vou usar no servico de impressao
  mov eax,4             ;escrita
  mov ebx,1             ;fd=1, na tela
  mov ecx,%1   ;&buffer a ser gravado
  mov edx,%2 ;tamanho a ser gravado 
  int 0x80
  pop rcx 
  
%endmacro

;=============================================================
;Pula Linha
;=============================================================
%macro _pulalinha 1
  mov eax,4          ;escrita
  mov ebx,%1          ;fd=1, na tela
  mov ecx,pulaLinha  ;&buffer a ser impresso
  mov edx,1          ;tamanho a ser gravado 
  int 0x80
%endmacro

;=============================================================
;exit 0
;============================================================= 
%macro _exit 1
  mov eax,1     
  mov ebx,%1    
  int 0x80
%endmacro