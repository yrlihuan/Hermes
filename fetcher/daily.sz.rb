#
# filename: fetcher/daily.sz.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"

require File.expand_path("../../accessor/all.rb", __FILE__)
require File.expand_path("../base.rb", __FILE__)
require File.expand_path("../daily.sh.rb", __FILE__)

module Fetcher
  class DailySz < DailySh
    def run(force_update=false)
      accessor = accessor_cls.new

      data_existed = accessor.list
      codes = Accessor::CodeSz.new.query({:all => true}).keys
      codes.each do |code|
        if !force_update && data_existed[code]
          puts "skipping #{code}"
          next
        end

        puts "fetching #{code}"
        text = fetch_data(code)
        save_data(code, text)
      end
    end

    def url(code)
      "http://ichart.finance.yahoo.com/table.csv?" +
      "s=#{code}.sz&d=1&e=1&f=2013&g=d&a=3&b=9&c=1990&ignore=.csv"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  gen = Fetcher::DailySz.new
  gen.run
end
