CC = gcc
CFLAGS = -g -Wall -no-pie
PROG = malloc

all: $(PROG)

$(PROG): inicializador.o ass_malloc.o
	$(CC) $(CFLAGS) -o $(PROG) inicializador.o malloc.o

test.o: inicializador.c
	$(CC) $(CFLAGS) -c inicializador.c -o inicializador.o

ass_malloc.o: malloc.h malloc.s
	as malloc.s -o malloc.o -g

clean:
	rm -rf *.o $(PROG)