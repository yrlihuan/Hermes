#include <iostream>
#include <vector>
#include <fstream>
#include <iterator>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "level2.h"
#include "serializer.h"

using namespace std;
using namespace hermes;

int main()
{
  vector<Level2Data> data;
  Serializer serializer;

  // load the csv file, dump the content as binary
  // then load the binary file, and dump it back to csv
  serializer.loadCsvFile("test.csv", data);
  serializer.dumpDatFile("binary.dat", data.begin(), data.end());

  vector<Level2Data> data2;
  serializer.loadDatFile("binary.dat", data2);
  serializer.dumpCsvFile("result.csv", data2.begin(), data2.end());

  // load two csv files, combine the content
  // dump it to a second csv
  vector<Level2Data> data000001;
  serializer.loadCsvFile("000001.csv", "000001", data000001);

  vector<Level2Data> data600000;
  serializer.loadCsvFile("600000.csv", "600000", data600000);

  data000001.insert(data000001.end(), data600000.begin(), data600000.end());
  serializer.dumpCsvFile("result2.csv", data000001.begin(), data000001.end());

  return 0;
}
