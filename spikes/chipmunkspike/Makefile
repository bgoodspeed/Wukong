
CC=gcc
CFLAGS= -I/usr/local/include/chipmunk -std=c99 
DEPS = ChipmunkDemo.h ChipmunkDebugDraw.h
OBJ = Player.o  ChipmunkDemo.o ChipmunkDebugDraw.o
LIBS=-lm -lGL -lGLU -lglut -lchipmunk -lSDL
%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

pyramid: $(OBJ)
	gcc -o $@ $^ $(CFLAGS) $(LIBS)