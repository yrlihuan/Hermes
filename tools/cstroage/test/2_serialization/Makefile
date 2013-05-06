all: build run compare clean

build:
	g++ -I../../cpp/ ../../cpp/level2.cpp test.cpp

run:
	./a.out

compare:
	./compare.py test.csv result.csv
	./compare.py test.csv result2.csv

clean:
	rm a.out binary.dat result.csv result2.csv


