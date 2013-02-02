#
# filename: fetcher/code.sz.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"
require "nokogiri"

require File.expand_path("../../accessor/all.rb", __FILE__)
require File.expand_path("../base.rb", __FILE__)

module Fetcher
  class CodeSz < Base
    def run
      text = fetch_data
      data = parse_data text
      save_data data
    end

    def url
      "http://www.szse.cn/szseWeb/FrontController.szse?ACTIONID=8&CATALOGID=1110&TABKEY=tab1&ENCODE=1"
    end

    def fetch_data
      html = `curl -s "#{url}"`
    end

    def parse_data(text)
      doc = Nokogiri::HTML(text)
      cnt = 0
      tags = ["code2"]
      tags << "company"
      tags << "company fullname"
      tags << "company english name"
      tags << "address"
      tags << "code"
      tags << "name"
      tags << "ipo date"
      tags << "market cap"
      tags << "live cap"
      tags << "code b"
      tags << "name b"
      tags << "ipo date b"
      tags << "market cap b"
      tags << "live cap b"
      tags << "area"
      tags << "province"
      tags << "city"
      tags << "industry"
      tags << "website"

      data = []
      doc.xpath('//tr[@class="cls-data-tr"]').each do |node|
        td = node.xpath('td')
        dict = {}
        0.upto(tags.count-1) do |i|
          dict[tags[i]] = td[i].text
        end

        data << dict
      end

      data
    end

    def save_data(data)
      accessor = accessor_cls.new
      data.each do |dict|
        code = dict['code']
        accessor.update(code, :data => dict)
      end
    end

  end
end

if $PROGRAM_NAME == __FILE__
  gen = Fetcher::CodeSz.new
  gen.run
end
