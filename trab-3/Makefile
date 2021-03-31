CC = gcc
CFLAGS = -std=c99
LIBS =

EXEC_NAME = regalloc

$(EXEC_NAME): reg_alloc.c grafo.c pilha.c
	$(CC) reg_alloc.c grafo.c pilha.c -o $(EXEC_NAME) $(LIBS) $(CFLAGS)

clean:
	rm -f $(EXEC_NAME)