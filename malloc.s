.section .data
    inicioHeap: .quad 0
    topoHeap: .quad 0

.section .text

.globl iniciaAlocador
.type iniciaAlocador, @function
iniciaAlocador:
    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax
    movq $0, %rdi
    syscall 

    movq %rax, inicioHeap
    movq %rax, topoHeap

    pop %rbp
    ret


.globl criarNodo
.type criarNodo, @function
criarNodo:
    pushq %rbp 
    movq %rsp, %rbp
    subq $16, %rsp

    movq 16(%rbp), %rsi
    movq topoHeap, %rax

    movq $1, (%rax)
    movq %rsi, 1(%rax)

    add $16, %rsp
    pop %rbp
    ret

.globl alocaMemoria
.type alocaMemoria, @function
alocaMemoria:
    pushq %rbp
    movq %rsp, %rbp
    subq $8 , %rsp
    movq %rdi, %rbx # transfere parametro para reg rbx

    movq topoHeap, %rcx
    cmp inicioHeap, %rcx
    je aumentarHeap # caso a heap esteja vazia, pula para aumentarHeap

    # movq 0, %rax # flag para o loop
    # # necessario procurar um bloco livre com tamanho igual ou maior a reg rax
    # loop:
    # cmp %rax, %rsi
    # jge fimLoop

    # # se encontrar, torna o bloco ocupado e retorna o endereço 

    # fimLoop:

    # se não, utiliza a syscall brk e aumenta o tamanho da heap
    aumentarHeap:
    movq $12, %rax
    add topoHeap, %rdi
    syscall
    pushq %rdi
    call criarNodo
    add $8, %rsp
    movq %rax, topoHeap
    movq %rbx, %rax

    fimAlocaMemoria:
    pop %rbp
    ret

.globl finalizaAlocador
.type finalizaAlocador, @function
finalizaAlocador:
    pushq %rbp
    movq %rsp, %rbp

    pop %rbp
    ret


.globl liberaMemoria
.type liberaMemoria, @function
liberaMemoria:
    pushq %rbp
    movq %rsp, %rbp

    pop %rbp
    ret


