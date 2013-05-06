#include <iostream>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "level2.h"

using namespace std;
using namespace hermes;

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
  _avgOfferPrice = round(avgOfferPrice * 1000);
  _avgBidPrice = round(avgBidPrice * 1000);
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
  price = this->price();
  avgOfferPrice = this->avgOfferPrice();
  avgBidPrice = this->avgBidPrice();
  for (int i = 0; i < 10; ++i) {
    offerPrice[i] = this->offerPrice(i);
    bidPrice[i] = this->bidPrice(i);
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

double Level2Data::localTS()
{
  return _localTS;
}

double Level2Data::remoteTS()
{
  return _remoteTS;
}

int    Level2Data::securityId()
{
  return _securityId;
}

int    Level2Data::volumeTraded()
{
  return _volumeTraded;
}

int    Level2Data::orderTraded()
{
  return _orderTraded;
}

int    Level2Data::totalOfferQty()
{
  return _totalOfferQty;
}

int    Level2Data::totalBidQty()
{
  return _totalBidQty;
}

float  Level2Data::price()
{
  return _price / 100.0;
}

float  Level2Data::avgOfferPrice()
{
  return _avgOfferPrice / 1000.0;
}

float  Level2Data::avgBidPrice()
{
  return _avgBidPrice / 1000.0;
}

float  Level2Data::offerPrice(int i)
{
  return _offerPrice[i] / 100.0;
}

int    Level2Data::offerNumber(int i)
{
  return _offerNumber[i];
}

int    Level2Data::offerQty(int i)
{
  return _offerQty[i];
}

float  Level2Data::bidPrice(int i)
{
  return _bidPrice[i] / 100.0;
}

int    Level2Data::bidNumber(int i)
{
  return _bidNumber[i];
}

int    Level2Data::bidQty(int i)
{
  return _bidQty[i];
}




