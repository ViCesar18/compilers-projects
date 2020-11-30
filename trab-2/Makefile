FLEX = flex
BISON = bison
CC = gcc
CFLAGS = -std=c99
LIBS = 

EXEC_NAME = dcmat
LEXICO = lexico.l
SINTATICO = sintatico.y

$(EXEC_NAME): dcmat.c arvore.c $(LEXICO) $(SINTATICO)
	$(FLEX) $(LEXICO)
	$(BISON) -d $(SINTATICO)
	$(CC) dcmat.c arvore.c lex.yy.c sintatico.tab.c -o $(EXEC_NAME)

clean:
	rm -f lex.yy.c
	rm -f sintatico.tab.c
	rm -f sintatico.tab.h
	rm -f $(EXEC_NAME)