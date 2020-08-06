FLEX = flex
CC = gcc
CFLAGS = 
LIBS = 

PROGRAMA = ex3
LEXICO = ex3.l

$(PROGRAMA): $(LEXICO)
	$(FLEX) $(LEXICO)
	$(CC) lex.yy.c $(LIBS) -o $(PROGRAMA)

clean:
	rm -f lex.yy.c
	rm -f ex1