#ifndef _HERMES_SERIALIZER_H_
#define _HERMES_SERIALIZER_H_

#include <iostream>
#include <fstream>
#include <vector>
#include <iterator>
#include <string>

#include "level2.h"

namespace hermes {

class Serializer
{
public:
  template<typename DataType>
  void loadCsvFile(const std::string &csvFilename, std::vector<DataType> &dataOut)
  {
    // Here we just assume no line will be longer than 4096
    // a typical level2 data csv line is about 300 bytes
    char lineBuf[4096];

    std::ifstream fin;
    fin.open(csvFilename.c_str());
    while (true)
    {
      fin.getline(lineBuf, sizeof(lineBuf));

      if (lineBuf[0] == '\0')
        break;

      dataOut.push_back(DataType(std::string(lineBuf)));
    }

    fin.close();
  }

  template<typename ForwardIterator>
  void dumpCsvFile(const std::string &csvFilename, ForwardIterator begin, ForwardIterator end)
  {
    std::ofstream fout;
    fout.open(csvFilename.c_str());
    ForwardIterator it = begin;
    while (it != end)
    {
      fout << (it++)->toCsv() << std::endl;
    }

    fout.close();
  }

  template<typename DataType>
  void loadDatFile(const std::string &csvFilename, std::vector<DataType> &dataOut)
  {
    // hmmm... we don't know the file size yet
    std::ifstream fin(csvFilename.c_str());
    fin.seekg(0, fin.end);
    long size = fin.tellg();
    fin.seekg(0, fin.beg);

    // better check the size
    if (size % sizeof(DataType) != 0) {
      std::cout << "Wrong file size! Not a mutiplier of " << sizeof(DataType) << std::endl;
      return;
    }

    // allocate space
    int numOfData = size / sizeof(DataType);
    dataOut.resize(numOfData);

    fin.read((char*)(&dataOut[0]), size);
    fin.close();
  }

  template<typename ForwardIterator>
  void dumpDatFile(const std::string &csvFilename, ForwardIterator begin, ForwardIterator end)
  {
    typedef typename std::iterator_traits<ForwardIterator>::value_type DataType;

    std::ofstream fout;
    fout.open(csvFilename.c_str());
    ForwardIterator it = begin;
    while (it != end) {
      fout.write((char*)(&*(it++)), sizeof(DataType));
    }

    fout.close();
  }
};

} // END of NS Hermes

#endif
