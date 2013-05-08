#include <iostream>
#include <fstream>
#include <list>
#include <deque>
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
  typedef deque<Level2Data> DataDeque;

  while (data.size() > 1) {
    DataDeque deques[2];
    for (int i = 0; i < 2; ++i) {
      DataVector &v = data.front();
      DataDeque &d = deques[i];
      d.resize(v.size());

      std::copy(v.begin(), v.end(), d.begin());
      v.clear();
      data.pop_front();
    }

    DataDeque &d0 = deques[0];
    DataDeque &d1 = deques[1];

    data.push_back(DataVector());
    DataVector &merged = data.back();

    DataDeque::iterator it0 = d0.begin();
    DataDeque::iterator it1 = d1.begin();

    while (it0 < d0.end() && it1 < d1.end()) {
      if (it0->localTS() < it1->localTS()) {
        merged.push_back(*(it0++));
        d0.pop_front();
      }
      else if (it0->localTS() > it1->localTS()) {
        merged.push_back(*(it1++));
        d1.pop_front();
      }
      else {
        if (it0->securityId() < it1->securityId()) {
          merged.push_back(*(it0++));
          d0.pop_front();
        }
        else {
          merged.push_back(*(it1++));
          d1.pop_front();
        }
      }
    }

    // why not use std::copy here?
    // cause we expect it0 is very close to d0's end
    // using assignment is much easier
    while (it0 < d0.end()) {
      merged.push_back(*(it0++));
      d0.pop_front();
    }

    while (it1 < d1.end()) {
      merged.push_back(*(it1++));
      d1.pop_front();
    }
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
