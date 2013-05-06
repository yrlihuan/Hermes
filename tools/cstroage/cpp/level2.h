#ifndef _HERMES_LEVEL2_H_
#define _HERMES_LEVEL2_H_

#include <string>
#include <tr1/cstdint>

namespace hermes {

static const char *rawCsvSchema = ""
"%d,"       // security id
"%lf,"      // local ts
"%d:%d:%d," // remote time, in %H:%M:%S
"%lf,"      // price
"%lf,"      // volume traded
"%d,"       // order traded
"%lf,"      // avg offer price
"%lf,"      // avg offer qty
"%lf,"      // avg bid price
"%lf,"      // avg bid qty
"%lf,"      // offer price 10
"%u,"       // offer qty 10
"%hu,"       // offer count 10
"%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," // offer 9, ... , offer 2
"%lf,"      // offer price 1
"%u,"       // offer qty 1
"%hu,"       // offer count 1
"%lf,"      // bid price 1
"%u,"       // bid qty 1
"%hu,"       // bid count 1
"%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," "%lf,%u,%hu," // bid 2, ... , bid 9
"%lf,"      // bid price 10
"%u,"       // bid qty 10
"%hu";       // bid count 10

static const char *rawCsvOutputSchema = ""
"%06d,"       // security id
"%.2lf,"      // local ts
"%02d:%02d:%02d," // remote time, in %H:%M:%S
"%.2lf,"      // price
"%.2lf,"      // volume traded
"%d,"       // order traded
"%.3lf,"      // avg offer price
"%.0lf,"      // avg offer qty
"%.3lf,"      // avg bid price
"%.0lf,"      // avg bid qty
"%.2lf,"      // offer price 10
"%d,"       // offer qty 10
"%d,"       // offer count 10
"%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," // offer 9, ... , offer 2
"%.2lf,"      // offer price 1
"%d,"       // offer qty 1
"%d,"       // offer count 1
"%.2lf,"      // bid price 1
"%d,"       // bid qty 1
"%d,"       // bid count 1
"%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," "%.2lf,%d,%d," // bid 2, ... , bid 9
"%.2lf,"      // bid price 10
"%d,"       // bid qty 10
"%d";       // bid count 10


class Level2Data {
  public:
    // csv conversions
    Level2Data() {}
    Level2Data(const std::string &rawCsvRecord);
    std::string toCsv();

    // getters
    double localTS();
    double remoteTS();
    int securityId();
    int volumeTraded();
    int orderTraded();
    int totalOfferQty();
    int totalBidQty();
    float price();
    float avgOfferPrice();
    float avgBidPrice();

    float offerPrice(int i);
    int offerNumber(int i);
    int offerQty(int i);

    float bidPrice(int i);
    int bidNumber(int i);
    int bidQty(int i);

  private:
    double               _localTS;       // local timestamp
    double               _remoteTS;      // remote timestamp
    std::tr1::uint32_t   _securityId;    // security id in integer
    std::tr1::uint32_t   _volumeTraded;  // total volume of trades
    std::tr1::uint32_t   _orderTraded;   // total number of trades
    std::tr1::uint32_t   _totalOfferQty;
    std::tr1::uint32_t   _totalBidQty;
    std::tr1::uint16_t   _price;         // price, in cents
    std::tr1::uint32_t   _avgOfferPrice;
    std::tr1::uint32_t   _avgBidPrice;

    std::tr1::uint16_t   _offerPrice[10];
    std::tr1::uint16_t   _offerNumber[10];
    std::tr1::uint32_t   _offerQty[10];

    std::tr1::uint16_t   _bidPrice[10];
    std::tr1::uint16_t   _bidNumber[10];
    std::tr1::uint32_t   _bidQty[10];
};

} // END of NS Hermes

#endif
