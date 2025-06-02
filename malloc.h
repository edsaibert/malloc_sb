#ifndef malloc_h
#define malloc_h

void* alocaMemoria(int t);

void iniciaAlocador();

void finalizaAlocador();

int liberaMemoria(void* bloco);

void imprimeHeap();

#endif