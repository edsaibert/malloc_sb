#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "malloc.h"

int main(long int argc, char **argv)
{
    void *a, *b, *c, *d; 

    iniciaAlocador();
    a = (void*) alocaMemoria(100);
    b = (void*) alocaMemoria(100);
    c = (void*) alocaMemoria(90);
    d = (void*) alocaMemoria(100);
    imprimeHeap();

    liberaMemoria(a);
    printf("CHECKPOINT 1 \n");
    imprimeHeap();
    liberaMemoria(c);
    printf("CHECKPOINT 2 \n");
    imprimeHeap();

    a = (void*) alocaMemoria(90);
    printf("CHECKPOINT 3\n");
    imprimeHeap();
    liberaMemoria(a);
    printf("CHECKPOINT 4\n");
    imprimeHeap();
    liberaMemoria(b);
    printf("CHECKPOINT 5\n");
    imprimeHeap();
    liberaMemoria(d);
    printf("CHECKPOINT 6\n");
    imprimeHeap();

    // to-do: inserir logica do codigo aqui
    // for (i = 0; i < 100; i++) {
    //     a = malloc(100);
    //     strcpy(a, "TESTE");
    //     printf("%p %s\n", a, (char *)a);
    //     free(a);
    // }

    return 0;
}
