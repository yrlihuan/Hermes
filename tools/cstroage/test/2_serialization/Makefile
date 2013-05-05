all: build run compare clean

build:
	g++ -I../../cpp/ ../../cpp/level2.cpp test.cpp

run:
	./a.out

compare:
	./compare.py test.csv result.csv

clean:
	rm a.out result.csv binary.dat


