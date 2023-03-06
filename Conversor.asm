; Autor: Leonardo Balan
; arquivo: Conversor.asm
; objetivo: Construa o código que converta o texto apresentado em entrada da seção .data para um inteiro e armazene em resultado na seção .bss.
; nasm -f elf64 Conversor.asm && ld Conversor.o -o Conversor.x
; OBS: Optei por quando acontecer o estouro de representacao zerar a variavel resultado.

section .data
    entrada :   db "-3", 0    ;String que será convertida entre aspas    , 0 obrigatorio

section .bss
    resultado   resq 1
    isCastValid resb 1

section .text
    global _start

_start:
    ; Inicialização dos registradores
    xor rax, rax
    xor rcx, rcx 
    xor rdx, rdx   
    
    ; Descobrir tamanho da string
    mov rcx, -1
    lea rdi, [entrada]
    loop1:
        inc rcx
        cmp byte [rdi+rcx], 0
        jne loop1
        
        ;tratamento para valor unitario de 0-9 positivo
        cmp rcx, 1
        je convert1

lentsi:    
        ;checagem pra ver se estrapola a representação x64 int
        ;caso estrapole pula para o label erro onde o resultado e o cast recebem 0
        ;Escolhi por nao mostrar o resultado estrapolado, somente 0 mesmo        
        cmp rcx, 19
        jg erro
conv:
    ; Converter cada caractere da string para inteiro de 1 byte
    mov rdi, entrada
    sub rcx, 1
    xor rax, rax
    mov r12, 10
    
    ;primeira sem multiplicar por 10, indice de unidade
    movzx r8d, byte [rdi+rcx]
    sub r8d, 0x30
    cmp r8d, 0x2d  ; sinal de -
    je neg
    mov r10d, r8d
    add rax, r10
    sub rcx, 1

    ;leitura da string da direita para esquerda, como recomendado
    loop2:

        movzx r8d, byte [rdi+rcx]
        sub r8d, 0x30
        cmp r8d, 0x2d
        je neg
        cmp r8d, 0Ah
        jae neg         ;jmp de verificacao 0-9
        mov r9, rax
        mov r10, r8
        imul r10, r12
        add rax, r10     ;acumulator do resultado a cada laco
        cmp rax, r9
        jl neg
        sub rcx, 1
        imul r12, 10     ;multiplicando por 10 o r12 a cada laco, r12*i
        jge loop2
        

certo:
    ; Ajustar resultado e isCastValid
    mov [resultado], rax
    mov byte [isCastValid], 1
    jmp fim

;valor negativo valido
neg:
   mov byte [isCastValid], 1
    neg rax
    mov [resultado], rax
    jmp fim

;tratamento para valor unitario de 0-9 positivo
convert1:
    ; Movimenta o end da string para o reg RDI
    mov rdi, entrada

    ; Subtrai o valor ASCII '0' do primeiro caractere da string
    mov al, byte [rdi]
    sub al, 48

    ; Armazene o resultado
    mov [resultado], rax
    jmp certo

;sempre que a representacao nao pode ser feita o resultado tambem fica em 0, pois a verificacao e feita no inicio do codigo
erro:
    ; Ajustar isCastValid, valor nao representavel
    mov byte [isCastValid], 0
    
fim:
    ; Encerrar o programa(exit)
    mov rax, 60
    xor rdi, rdi
    syscall
