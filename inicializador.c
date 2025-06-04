#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "malloc.h"

int main(long int argc, char **argv)
{
    void *a, *b, *c, *d;
    int i;

    iniciaAlocador();
    a = (void*) alocaMemoria(5);
    b = (void*) alocaMemoria(1); 
    c = (void*) alocaMemoria(1);
    d = (void*) alocaMemoria(5);
    imprimeHeap();

    liberaMemoria(b);
    printf("CHECKPOINT 1 \n");
    imprimeHeap();
    liberaMemoria(d);
    printf("CHECKPOINT 2 \n");
    imprimeHeap();
    liberaMemoria(c);
    printf("CHECKPOINT 3 \n");
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
