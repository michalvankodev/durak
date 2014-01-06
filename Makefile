# This is Makefile for durak
# you should run 'make debug' for debugging purposes

all:
	valac src/*.vala -o durak
clean:
	rm durak
debug: 
	valac src/*vala -o debug/durak