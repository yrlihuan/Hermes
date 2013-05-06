all: build run control compare clean

build:
	g++ -I../../cpp/ ../../cpp/level2.cpp ../../cpp/data_merger.cpp

run:
	./a.out files.cfg data.csv data.dat

control:
	./sort.py files.cfg data2.csv

compare:
	./compare.py data.csv data2.csv

clean:
	rm a.out data.csv data.dat data2.csv


