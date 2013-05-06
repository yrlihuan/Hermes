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

  serializer.loadCsvFile("test.csv", data);
  serializer.dumpDatFile("binary.dat", data.begin(), data.end());

  return 0;
}