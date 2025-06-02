#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "malloc.h"

int main(long int argc, char **argv)
{
    void *a;
    int i;

    iniciaAlocador();
    a = (void*) alocaMemoria(100);
    a = (void*) alocaMemoria(5);
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