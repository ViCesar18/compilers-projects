FLEX = flex
CC = gcc
CFLAGS = -std=c99
LIBS = 

EXEC_NAME = cstats
LEXICO = ex4.l

$(EXEC_NAME): $(LEXICO)
	$(FLEX) $(LEXICO)
	$(CC) lex.yy.c $(CFLAGS) $(LIBS) -o $(EXEC_NAME)

clean:
	rm -f lex.yy.c
	rm -f $(EXEC_NAME)