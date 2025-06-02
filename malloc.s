.section .data
    inicioHeap: .quad 0
    topoHeap: .quad 0
    listaOcupado: .quad 0
    listaLivre: .quad 0

    blocoLivre: .string "-"
    blocoOcupado: .string "+"
    novaLinha: .string "\n"
    gerencial: .string "########################"

.section .text
.extern printf

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
    movq $0, listaOcupado
    movq $0, listaLivre

    pop %rbp
    ret


.globl criarNodo
.type criarNodo, @function
criarNodo:
    pushq %rbp
    movq %rsp, %rbp

    movq $1, (%rdi)      # Marca como ocupado
    movq %rdx, 8(%rdi)    # next = NULL
    movq %rsi, 16(%rdi)   # Salva o tamanho 
    movq listaOcupado, %rdx
    movq %rdi, listaOcupado        # listaOcupado = end ultimo bloco alocado

    movq %rdi, %rax      # Retorna o endereço do bloco criado

    pop %rbp
    ret

.globl alocaMemoria
.type alocaMemoria, @function
alocaMemoria:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rbx # tamanho solicitado
    add $24, %rbx # tamanho total do bloco (header + payload)

    # se a lista livre estiver vazia, aumentar a heap
    movq listaLivre, %rcx
    cmp $0, %rcx
    je aumentarHeap

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
        movq %rbx, %rdi         # novo topo desejado em %rdi
        add topoHeap, %rdi      # adiciona o topo atual para obter o novo topo
        syscall                 # brk(novo topo)
        movq %rax, topoHeap     # retorna endereço do novo topo
        subq %rbx, %rdi
        movq %rbx, %rsi         # tamanho do bloco
        subq $24, %rsi          # subtrai header
        call criarNodo

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


.globl imprimeNodo
.type imprimeNodo, @function
imprimeNodo:
    pushq %rbp
    movq %rsp, %rbp

    movq 16(%rbp), %rbx      # endereço do bloco
    movq %rbx, %r8
    movq (%rbx), %rax        # status
    cmp $1, %rax
    jne blocoLivreJump
    leaq blocoOcupado(%rip), %rsi
    jmp imprimeBloco

    blocoLivreJump:
    leaq blocoLivre(%rip), %rsi

    imprimeBloco:
    movq 16(%rbx), %r9      # pega o tamanho direto
    movq $0, %rcx           # iterador

    # imprime bloco gerencial
    pushq %rcx
    pushq %rsi
    movq $24, %rdx
    movq $1, %rdi
    movq $1, %rax
    leaq gerencial(%rip), %rsi
    syscall
    popq %rsi
    popq %rcx

    loopImprimeBloco:
    cmp %rcx, %r9         
    je fimImprimeBloco

    pushq %rcx
    pushq %rax

    # syscall: write(STDOUT, %rsi, 1)
    movq $1, %rdx         # size = 1
    movq $1, %rdi         # STDOUT
    movq $1, %rax         # syscall number for write
    syscall

    popq %rax
    popq %rcx

    inc %rcx
    jmp loopImprimeBloco

    fimImprimeBloco:
    # imprime nova linha
    leaq novaLinha(%rip), %rsi  # Endereço da string "\n"
    movq $1, %rdx               # Tamanho da nova linha
    movq $1, %rdi               # STDOUT
    movq $1, %rax               # Syscall número para write
    syscall

    movq 8(%r8), %rax        # próximo bloco via .next
    pop %rbp
    ret


.globl imprimeHeap
.type imprimeHeap, @function
imprimeHeap:
    pushq %rbp
    movq %rsp, %rbp

    movq topoHeap, %rdx
    movq inicioHeap, %rbx

    loopImprimeHeap:
    cmp %rdx, %rbx
    jge fimImprimeHeap
    pushq %rdx
    pushq %rbx 
    call imprimeNodo
    add $8, %rsp
    popq %rdx
    movq %rax, %rbx
    jmp loopImprimeHeap

    fimImprimeHeap:
    pop %rbp
    ret