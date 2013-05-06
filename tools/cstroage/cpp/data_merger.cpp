#include <iostream>
#include <fstream>
#include <list>
#include <string.h>
#include "level2.h"
#include "serializer.h"

using namespace std;
using namespace hermes;

typedef vector<Level2Data> DataVector;

void readRawCsvFiles(list<DataVector> &result, const char *configFile)
{
  Serializer serializer;

  ifstream fin;
  fin.open(configFile);

  char buf[512];
  while (true) {
    fin.getline(buf, sizeof(buf));
    if (buf[0] == '\0') {
      break;
    }

    char *pos = buf;
    char *path;

    while (*pos != '\0') {
      if (*pos == ',') {
        *pos = '\0';
        path = pos + 1;
      }

      ++pos;
    }

    result.push_back(DataVector());
    serializer.loadCsvFile(path, buf, result.back());
  }

  fin.close();
}

// the sort happened inside list data.
// after finished, there will be only one element in data
// and that is the sorted data
void mergeSort(list<DataVector> &data)
{
  while (data.size() > 1) {
    DataVector &v0 = *(data.begin());
    DataVector &v1 = *(++data.begin());

    DataVector merged(v0.size() + v1.size());

    DataVector::iterator it0 = v0.begin();
    DataVector::iterator it1 = v1.begin();
    DataVector::iterator it = merged.begin();

    while (it0 < v0.end() && it1 < v1.end()) {
      if (it0->localTS() < it1->localTS()) {
        *(it++) = *(it0++);
      }
      else if (it0->localTS() > it1->localTS()) {
        *(it++) = *(it1++);
      }
      else {
        if (it0->securityId() < it1->securityId()) {
          *(it++) = *(it0++);
        }
        else {
          *(it++) = *(it1++);
        }
      }
    }

    while (it0 < v0.end())
      *(it++) = *(it0++);

    while (it1 < v1.end())
      *(it++) = *(it1++);

    data.pop_front();
    data.pop_front();

    data.push_back(merged);
  }
}

int main(int argc, char *argv[])
{
  if (argc != 4) {
    const char *usage =
    "Usage:\n"
    "  data_merger <CSV definition> <binary output> <csv output>\n"
    "    CSV definition: is a file defined which csv files to be merged. Each line contains a pair of <securityId,pathToCsvFile>\n"
    "    binary output: merged result, in bianry format\n"
    "    csv output: merged result, in csv format\n";

    cout << usage << endl;
    return 1;
  }

  const char *cfgFile = argv[1];
  const char *csvOutput = argv[2];
  const char *datOutput = argv[3];

  list<DataVector> rawData;
  readRawCsvFiles(rawData, cfgFile);

  // print lines of each file
  //list<DataVector>::iterator it = rawData.begin();
  //while (it != rawData.end()) {
  //  DataVector &v = *it;
  //  cout << v.size() << endl;
  //  ++it;
  //}

  // assume each file read is data for a single stock, thus the data has been sorted
  // so here we have a list of sorted vector. the next thing is, MERGE SORT!
  list<DataVector> &data = rawData;
  mergeSort(data);

  DataVector &result = data.front();

  Serializer serializer;
  serializer.dumpCsvFile(csvOutput, result.begin(), result.end());
  serializer.dumpDatFile(datOutput, result.begin(), result.end());

  return 0;
}
