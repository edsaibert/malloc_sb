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

    movq $1, (%rdi)         # status = 1 (ocupado)
    movq $0, 8(%rdi)        # next = 0
    movq %rsi, 16(%rdi)     # tamanho = %rsi

    # se listaOcupado estiver vazia, é o primeiro bloco
    movq listaOcupado, %rax
    cmp $0, %rax
    je primeiroBloco

    # senão, percorre a lista até o último
    procurarUltimo:
    movq %rax, %rcx
    movq 8(%rcx), %rax      # %rax = next
    cmp $0, %rax
    jne procurarUltimo

    # agora %rcx é o último nodo, atualiza o next dele
    movq %rdi, 8(%rcx)

    jmp fimCriar

    primeiroBloco:
    movq %rdi, listaOcupado

    fimCriar:
    movq %rdi, %rax         # retorna o endereço do bloco
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

    # caso contrário, tenta encontrar um bloco vazio com tamanho pelo menos %rbx
    

    # utiliza a syscall brk e aumenta o tamanho da heap
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
    # parametros:
    # %rdi - bloco a ser liberado

    # necessário:
    # liberar bloco da lista de blocos ocupados, rearranjar os ponteiros
    # adicionar bloco aos blocos livres, rearranjar os ponteiros
    # fundir blocos livres adjacentes

    movq listaOcupado, %rax
    cmp %rdi, %rax
    je primeiroBlocoOcupado

    movq %rax, %rbx

    loopEncontraBloco:
    movq 8(%rax), %rax
    cmp %rdi, %rax  # verifica se o endereço next de rax é o bloco a ser liberado
    je blocoEncontrado
    movq 8(%rbx), %rbx
    movq %rbx, %rax
    jmp loopEncontraBloco

    primeiroBlocoOcupado:
    # Caso o bloco seja o primeiro da lista
    movq listaOcupado, %rdx
    movq 8(%rax), %rdx
    jmp blocoLiberado

    blocoEncontrado:
    # %rbx - bloco anterior
    # %rax - bloco atual (a ser liberado)
    # %rcx - próximo bloco

    movq 8(%rax), %rcx
    movq %rcx, 8(%rbx)  # Atualiza o ponteiro do bloco anterior para o próximo

    blocoLiberado:
    # Adiciona o bloco liberado à lista de blocos livres
    movq listaLivre, %rcx
    movq %rdi, listaLivre
    movq %rcx, 8(%rdi)  # Atualiza o ponteiro do bloco liberado para o próximo livre
    movq $0, (%rdi)     # Marca o bloco como livre

    call fundirVizinhos

    pop %rbp
    ret


.globl fundirVizinhos
.type fundirVizinhos, @function
fundirVizinhos:
    pushq %rbp
    movq %rsp, %rbp
    # parametros:
    # rdi - endereço do bloco que acabou de ser liberado

    # necessário percorrer a heap e encontrar o bloco anterior e próximo do bloxo
    movq inicioHeap, %rax 
    movq %rax, %rbx

    loopEncontraBloco:
    cmp %rdi, %rax
    jge fimLoopEncontraBloco
    add 16(%rbx), %rbx
    jmp loopEncontraBloco

    fimLoopEncontraBloco:
    popq %rbp
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

    movq %r9, %rax
    add %r8, %rax
    add $24, %rax 
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