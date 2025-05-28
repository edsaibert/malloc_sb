.section .data
    inicioHeap: .quad 0
    topoHeap: .quad 0

.section .text
.globl _start

_start:
   call iniciaAlocador 

    movq $60, %rax
    movq $0, %rdi
    syscall

iniciaAlocador:
    movq $12, %rax
    movq $0, %rdi
    syscall 

    movq %rax, inicioHeap
    movq %rax, topoHeap

//finalizaAlocador:

//liberaMemoria:

//alocaMemoria:
