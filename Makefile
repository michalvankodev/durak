# This is Makefile for durak
# you should run 'make debug' for debugging purposes

all: src/*.vala
	valac src/*vala -o durak --pkg gee-0.8
clean:
	rm durak
debug: src/*.vala
	mkdir -p debug
	valac -g src/*vala -o debug/durak --pkg gee-0.8 --pkg json-glib-1.0 --pkg gio-2.0

