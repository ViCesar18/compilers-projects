FLEX = flex
BISON = bison
CC = gcc
CFLAGS = -std=c99
LIBS = -lm

EXEC_NAME = l15e1
LEXICO = lexico.l
SINTATICO = sintatico.y

$(EXEC_NAME): semantico.c hash_table.c $(LEXICO) $(SINTATICO)
	$(FLEX) $(LEXICO)
	$(BISON) -d $(SINTATICO)
	$(CC) semantico.c hash_table.c lex.yy.c sintatico.tab.c -o $(EXEC_NAME) $(LIBS)

clean:
	rm -f lex.yy.c
	rm -f sintatico.tab.c
	rm -f sintatico.tab.h
	rm -f $(EXEC_NAME)