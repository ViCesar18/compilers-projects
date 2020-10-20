CC = gcc
CFLAGS = -std=c99
LIBS = 

EXEC_NAME = ex4.out

FONT_NAME = lexico.o sintatico.o

$(EXEC_NAME): $(FONT_NAME)
	$(CC) $(FONT_NAME) $(CFLAGS) $(LIBS) -o $(EXEC_NAME)

clean:
	rm -f $(EXEC_NAME)
	rm -f *.o