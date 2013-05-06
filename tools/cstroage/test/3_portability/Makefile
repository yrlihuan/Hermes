all: build run diff clean

build:
	g++ -I../../cpp/ ../../cpp/level2.cpp test.cpp

run:
	./a.out

diff:
	diff -q binary.dat expected.dat

clean:
	rm a.out binary.dat

