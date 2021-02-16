FLEX = flex
BISON = bison
CC = gcc
CFLAGS = -std=c99
LIBS = -lm

EXEC_NAME = semantico
LEXICO = lexico.l
SINTATICO = sintatico.y

$(EXEC_NAME): $(LEXICO) $(SINTATICO) ast.c hash_table.c semantico.c
	$(FLEX) $(LEXICO)
	$(BISON) -d $(SINTATICO)
	$(CC) ast.c hash_table.c lex.yy.c sintatico.tab.c semantico.c -o $(EXEC_NAME) $(LIBS)

clean:
	rm -f lex.yy.c
	rm -f sintatico.tab.c
	rm -f sintatico.tab.h
	rm -f sintatico.zip
	rm -f $(EXEC_NAME)