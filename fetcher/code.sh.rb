#
# filename: fetcher/code.sh.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"

require File.expand_path("../../accessor/all.rb", __FILE__)
require File.expand_path("../base.rb", __FILE__)

module Fetcher
  class CodeSh < Base
    def run
      # for some weird reason, this api returns 5 pages per request
      [1, 6, 11, 16].each do |page|
        text = fetch_data(page)
        data = parse_data(text)
        if data.size < 1
          puts "#{self.class}: page #{page} has no data"
        else
          save_data(data)
        end
      end
    end

    def url(page)
      "http://query.sse.com.cn/commonQuery.do?" +
      "jsonCallBack=jsonpCallback63358&isPagination=true" +
      "&sqlId=COMMON_SSE_ZQPZ_GPLB_MCJS_SSAG_L" +
      "&pageHelp.pageSize=50&pageHelp.pageNo=1" +
      "&pageHelp.beginPage=#{page}&pageHelp.endPage=#{page+5}&_=1359641079733"
    end

    def detail_url(code)
      "http://query.sse.com.cn/commonQuery.do?" +
      "jsonCallBack=jsonp1365867800897&_=1365867800937" +
      "&isPagination=false&sqlId=COMMON_SSE_ZQPZ_GP_GPLB_AGSSR_C&productid=#{code}"
    end

    def fetch_data(page)
      #uri = URI.parse url
      #res = Net::HTTP.start(uri.host, uri.port) do |http|
      #  http.get(uri.path)
      #end

      #text = res.body
      text = `curl -s -e "http://www.sse.com.cn/assortment/stock/list/name/" "#{url(page)}"`
    end

    def parse_data(text)
      start = text.index('(') + 1
      json = text[start...-1]

      data = JSON.load(json)['pageHelp']['data']

      data
    end

    def save_data(data)
      accessor = accessor_cls.new
      data.each do |dict|
        code = dict['PRODUCTID']

        cmd = "curl -s -e \"http://www.sse.com.cn/assortment/stock/list/stockdetails/company/index.shtml?COMPANY_CODE=#{code}\" \"#{detail_url(code)}\""
        text = `#{cmd}`
        start = text.index('(') + 1
        json = text[start...-1]

        data = JSON.load(json)['result']

        if data.count != 0
          dict['IPO_DATE'] = data[0]["LISTINGDATEA"]
        else
          dict['IPO_DATA'] = "2099-12-31"
        end

        accessor.update(code, :data => dict)
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  gen = Fetcher::CodeSh.new
  gen.run
end
