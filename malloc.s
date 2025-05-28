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


; .globl alocaMemoria
; .type alocaMemoria, @function
; alocaMemoria:

; .globl finalizaAlocador
; .type finalizaAlocador, @function
; finalizaAlocador

; .globl liberaMemoria
; .type liberaMemoria, @function
; liberaMemoria:

