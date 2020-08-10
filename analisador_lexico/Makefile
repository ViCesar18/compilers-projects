FLEX = flex
CC = gcc
CFLAGS = -std=c99
LIBS = 

EXEC_NAME = lexico
LEXICO = lexico.l

$(EXEC_NAME): $(LEXICO)
	$(FLEX) $(LEXICO)
	$(CC) lex.yy.c -o $(EXEC_NAME)

clean:
	rm -f lex.yy.c
	rm -f $(EXEC_NAME)