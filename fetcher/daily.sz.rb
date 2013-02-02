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
      codes = Accessor::CodeSz.new.query.keys
      codes.each do |code|
        # code sample: 6000036.ss
        if !force_update && data_existed[code]
          puts "skipping #{code}"
          next
        end

        puts "fetching #{code}"
        text = fetch_data(code)
        save_data(code, text)
      end
    end

    def save_data(code, text)
      accessor = accessor_cls.new
      code = code.gsub(".sz", "")
      accessor.update(code, :data => text)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  gen = Fetcher::DailySz.new
  gen.run
end
