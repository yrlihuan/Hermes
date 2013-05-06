#include <iostream>
#include <vector>
#include <fstream>
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
  Serializer serializer;
  vector<Level2Data> data;

  serializer.loadCsvFile("test.csv", data);
  serializer.dumpCsvFile("result.csv", data.begin(), data.end());

  return 0;
}
