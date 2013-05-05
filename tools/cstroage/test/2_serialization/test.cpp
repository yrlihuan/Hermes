#include <iostream>
#include <vector>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "level2.h"

using namespace std;

int main()
{
  vector<Level2Data> data;

  ifstream fin;
  fin.open("test.csv");
  while (true)
  {
    char line[2048];
    fin.getline(line, sizeof(line));

    if (line[0] == '\0')
      break;

    data.push_back(Level2Data(string(line)));
  }

  fin.close();

  ofstream fout;
  fout.open("binary.dat");
  fout.write((char*)(&data[0]), data.size() * sizeof(Level2Data));
  fout.close();

  ifstream fin2;
  fin2.open("binary.dat");

  int bufSize = data.size() * sizeof(Level2Data);
  Level2Data *data2 = (Level2Data*)malloc(bufSize);
  fin2.read((char*)data2, bufSize);
  fin2.close();

  ofstream fout2;
  fout2.open("result.csv");
  int numOfLines = data.size();
  for (int i = 0; i < numOfLines; ++i) {
    fout2 << data2[i].toCsv() << endl;
  }

  fout2.close();

  return 0;
}
