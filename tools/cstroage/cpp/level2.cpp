#include <iostream>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "level2.h"

using namespace std;

Level2Data::Level2Data(const std::string &rawCsvRecord)
{
  // parse csv using sscanf
  int remoteHour, remoteMinute, remoteSecond;
  double price;
  double volumeTraded;
  double avgOfferPrice;
  double totalOfferQty;
  double avgBidPrice;
  double totalBidQty;
  double offerPrice[10];
  double bidPrice[10];
  sscanf(rawCsvRecord.c_str(), rawCsvSchema,
      &_securityId,
      &_localTS,
      &remoteHour, &remoteMinute, &remoteSecond,
      &price,
      &volumeTraded,
      &_orderTraded,
      &avgOfferPrice,
      &totalOfferQty,
      &avgBidPrice,
      &totalBidQty,
      offerPrice+9, _offerQty+9, _offerNumber+9,
      offerPrice+8, _offerQty+8, _offerNumber+8,
      offerPrice+7, _offerQty+7, _offerNumber+7,
      offerPrice+6, _offerQty+6, _offerNumber+6,
      offerPrice+5, _offerQty+5, _offerNumber+5,
      offerPrice+4, _offerQty+4, _offerNumber+4,
      offerPrice+3, _offerQty+3, _offerNumber+3,
      offerPrice+2, _offerQty+2, _offerNumber+2,
      offerPrice+1, _offerQty+1, _offerNumber+1,
      offerPrice+0, _offerQty+0, _offerNumber+0,
      bidPrice+0, _bidQty+0, _bidNumber+0,
      bidPrice+1, _bidQty+1, _bidNumber+1,
      bidPrice+2, _bidQty+2, _bidNumber+2,
      bidPrice+3, _bidQty+3, _bidNumber+3,
      bidPrice+4, _bidQty+4, _bidNumber+4,
      bidPrice+5, _bidQty+5, _bidNumber+5,
      bidPrice+6, _bidQty+6, _bidNumber+6,
      bidPrice+7, _bidQty+7, _bidNumber+7,
      bidPrice+8, _bidQty+8, _bidNumber+8,
      bidPrice+9, _bidQty+9, _bidNumber+9);

  // convert prices
  _price = round(price * 100);
  _avgOfferPrice = round(avgOfferPrice * 100);
  _avgBidPrice = round(avgBidPrice * 100);
  for (int i = 0; i < 10; ++i) {
    _offerPrice[i] = round(offerPrice[i] * 100);
    _bidPrice[i] = round(bidPrice[i] * 100);
  }

  // double to int
  _volumeTraded = volumeTraded;
  _totalOfferQty = totalOfferQty;
  _totalBidQty = totalBidQty;

  // convert remote ts
  int startOfDayTS = (int)_localTS - ((int)_localTS + 8 * 3600) % (24 * 3600);
  _remoteTS = startOfDayTS + 3600 * remoteHour + 60 * remoteMinute + remoteSecond;
}

std::string Level2Data::toCsv()
{ 
  int remoteHour, remoteMinute, remoteSecond;
  double price;
  double volumeTraded;
  double avgOfferPrice;
  double totalOfferQty;
  double avgBidPrice;
  double totalBidQty;
  double offerPrice[10];
  double bidPrice[10];

  // convert prices
  price = _price / 100.0;
  avgOfferPrice = _avgOfferPrice / 100.0;
  avgBidPrice = _avgBidPrice / 100.0;
  for (int i = 0; i < 10; ++i) {
    offerPrice[i] = _offerPrice[i] / 100.0;
    bidPrice[i] = _bidPrice[i] / 100.0;
  }

  // int to double
  volumeTraded = _volumeTraded;
  totalOfferQty = _totalOfferQty;
  totalBidQty = _totalBidQty;

  // convert remote ts
  int secondsFromStartOfDay = ((int)_remoteTS + 8 * 3600) % (24 * 3600);
  remoteHour = secondsFromStartOfDay / 3600;
  remoteMinute = secondsFromStartOfDay % 3600 / 60;
  remoteSecond = secondsFromStartOfDay % 60;

  char buf[2048];
  sprintf(buf, rawCsvOutputSchema,
      _securityId,
      _localTS,
      remoteHour, remoteMinute, remoteSecond,
      price,
      volumeTraded,
      _orderTraded,
      avgOfferPrice,
      totalOfferQty,
      avgBidPrice,
      totalBidQty,
      offerPrice[9], _offerQty[9], _offerNumber[9],
      offerPrice[8], _offerQty[8], _offerNumber[8],
      offerPrice[7], _offerQty[7], _offerNumber[7],
      offerPrice[6], _offerQty[6], _offerNumber[6],
      offerPrice[5], _offerQty[5], _offerNumber[5],
      offerPrice[4], _offerQty[4], _offerNumber[4],
      offerPrice[3], _offerQty[3], _offerNumber[3],
      offerPrice[2], _offerQty[2], _offerNumber[2],
      offerPrice[1], _offerQty[1], _offerNumber[1],
      offerPrice[0], _offerQty[0], _offerNumber[0],
      bidPrice[0], _bidQty[0], _bidNumber[0],
      bidPrice[1], _bidQty[1], _bidNumber[1],
      bidPrice[2], _bidQty[2], _bidNumber[2],
      bidPrice[3], _bidQty[3], _bidNumber[3],
      bidPrice[4], _bidQty[4], _bidNumber[4],
      bidPrice[5], _bidQty[5], _bidNumber[5],
      bidPrice[6], _bidQty[6], _bidNumber[6],
      bidPrice[7], _bidQty[7], _bidNumber[7],
      bidPrice[8], _bidQty[8], _bidNumber[8],
      bidPrice[9], _bidQty[9], _bidNumber[9]
    );

  return string(buf);
}

int main()
{
  cout << sizeof(Level2Data) << endl;

  string row = "600000,1367457940.08,09:25:01,9.59,101300.0,75,10.02,992703.0,9.14,295500.0,9.71,500,0,9.7,23100,0,9.69,105800,0,9.68,14600,0,9.67,12600,0,9.65,92500,0,9.64,20000,0,9.62,2000,0,9.6,48969,0,9.59,32420,3,9.58,19200,7,9.56,900,0,9.55,2000,0,9.54,200,0,9.52,300,0,9.51,9100,0,9.5,12600,0,9.49,1700,0,9.48,25000,0,9.46,900,0";
  Level2Data a(row);
  Level2Data b(row);

  cout << a.toCsv() << endl;

  char bufa[sizeof(Level2Data)];
  char bufb[sizeof(Level2Data)];

  memcpy(bufa, &a, sizeof(Level2Data));
  memcpy(bufb, &b, sizeof(Level2Data));

  ofstream fout;
  fout.open("test.dat", ios::binary);
  fout.write(bufa, sizeof(bufa));
  fout.write(bufb, sizeof(bufb));
  fout.close();

  char bufcd[sizeof(Level2Data)*2];
  ifstream fin;
  fin.open("test.dat", ios::binary);
  fin.read(bufcd, sizeof(bufcd));
  fin.close();

  Level2Data *pc = (Level2Data*)bufcd;
  Level2Data *pd = (Level2Data*)(bufcd + sizeof(Level2Data));

  cout << pc->toCsv() << endl;
  cout << pd->toCsv() << endl;

  return 0;
}
