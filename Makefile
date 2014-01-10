# This is Makefile for durak
# you should run 'make debug' for debugging purposes

all: src/*.vala
	valac src/*vala -o durak
clean:
	rm durak
debug: src/*.vala
	mkdir -p debug
	valac src/*vala -o debug/durak

