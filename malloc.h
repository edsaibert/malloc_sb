#ifndef malloc_h
#define malloc_h

void* alocaMemoria();

void iniciaAlocador();

void finalizaAlocador();

int liberaMemoria(void* bloco);

#endif