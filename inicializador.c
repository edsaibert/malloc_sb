#include <stdio.h>
#include "malloc.h"

int main (long int argc, char** argv) {
  void *a,*b,*c,*d,*e;

  iniciaAlocador();
  imprimeHeap();
  printf("\n");
  // 0) estado inicial

  a=(void *) alocaMemoria(10);
  imprimeHeap();
  printf("\n");
  b=(void *) alocaMemoria(30);
  imprimeHeap();
  printf("\n");
  c=(void *) alocaMemoria(20);
  imprimeHeap();
  printf("\n");
  d=(void *) alocaMemoria(40);
  imprimeHeap();
  printf("\n");
  // 1) Espero ver quatro segmentos ocupados

  liberaMemoria(a);
  imprimeHeap();
  printf("\n");
  liberaMemoria(c);
  imprimeHeap();
  printf("\n");
  // 2) Espero ver quatro segmentos alternando
  //    ocupados e livres

  a=(void *) alocaMemoria(5);
  imprimeHeap();
  printf("\n");
  c=(void *) alocaMemoria(9);
  imprimeHeap();
  printf("\n");
  // 3) Deduzam

  liberaMemoria(c);
  imprimeHeap();
  printf("\n");
  liberaMemoria(a);
  imprimeHeap();
  printf("\n");
  liberaMemoria(b);
  imprimeHeap();
  printf("\n");
  liberaMemoria(d);
  imprimeHeap();
  printf("\n");
   // 4) volta ao estado inicial

  finalizaAlocador();
}
