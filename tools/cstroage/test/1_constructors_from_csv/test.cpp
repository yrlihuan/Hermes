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
  //string row = "600000,1367457940.08,09:25:01,9.59,101300.0,75,10.02,992703.0,9.14,295500.0,9.71,500,0,9.7,23100,0,9.69,105800,0,9.68,14600,0,9.67,12600,0,9.65,92500,0,9.64,20000,0,9.62,2000,0,9.6,48969,0,9.59,32420,3,9.58,19200,7,9.56,900,0,9.55,2000,0,9.54,200,0,9.52,300,0,9.51,9100,0,9.5,12600,0,9.49,1700,0,9.48,25000,0,9.46,900,0";
  //Level2Data a(row);
  //Level2Data b(row);

  //cout << a.toCsv() << endl;

  //char bufa[sizeof(Level2Data)];
  //char bufb[sizeof(Level2Data)];

  //memcpy(bufa, &a, sizeof(Level2Data));
  //memcpy(bufb, &b, sizeof(Level2Data));

  //ofstream fout;
  //fout.open("test.dat", ios::binary);
  //fout.write(bufa, sizeof(bufa));
  //fout.write(bufb, sizeof(bufb));
  //fout.close();

  //char bufcd[sizeof(Level2Data)*2];
  //ifstream fin;
  //fin.open("test.dat", ios::binary);
  //fin.read(bufcd, sizeof(bufcd));
  //fin.close();

  //Level2Data *pc = (Level2Data*)bufcd;
  //Level2Data *pd = (Level2Data*)(bufcd + sizeof(Level2Data));

  //cout << pc->toCsv() << endl;
  //cout << pd->toCsv() << endl;

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
  fout.open("result.csv");

  int numOfLines = data.size();
  for (int i = 0; i < numOfLines; ++i) {
    fout << data[i].toCsv() << endl;
  }

  fout.close();

  return 0;
}
