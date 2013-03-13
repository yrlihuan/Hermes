#
# filename: fetcher/cap.sh.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"
require "nokogiri"

require File.expand_path("../../accessor/all.rb", __FILE__)
require File.expand_path("../base.rb", __FILE__)

module Fetcher
  class CapSh < Base
    def run(force_update=false)
      accessor = accessor_cls.new

      data_existed = accessor.list
      codes = Accessor::CodeSh.new.query.keys
      codes.each do |code|
        # code sample: 6000036.ss
        code = code.gsub(".ss", "")
        if !force_update && data_existed[code]
          puts "skipping #{code}"
          next
        end

        puts "fetching #{code}"
        text = fetch_data(code)
        obj = parse_data(text)
        save_data(code, obj)
      end
    end

    def url(code)
      "http://q.stock.sohu.com/cn/#{code}/index.shtml"
    end

    def fetch_data(code)
      text = `curl -s "#{url(code)}"`
    end

    def parse_data(text)
      doc = Nokogiri::HTML(text)
      data = {}
      node = doc.xpath('//table[@class="table table03"]').first
      node.xpath('tbody/tr').each do |tr|
        tds = tr.xpath('td')
        title = tds[0].text
        value = tds[1].text

        if title.include? "总股本"
          data[:all] = value.to_i * 10000
        elsif title.include? "流通股本"
          data[:a] = value.to_i * 10000
        end
      end

      data
    end

    def save_data(code, obj)
      accessor = accessor_cls.new
      accessor.update(code, obj)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  gen = Fetcher::CapSh.new
  gen.run
end
