#
# filename: accessor/cap.sz.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"

require File.expand_path("../base.rb", __FILE__)
require File.expand_path("../cap.sh.rb", __FILE__)

module Accessor
  class CapSz < CapSh
    def query(params={})
      dir = data_dir

      all = params[:all]
      stocks = params[:stocks]

      data = {}
      Dir.entries(dir).each do |f|
        next if f.start_with? '.'

        code = f.gsub(".json", "")
        if all or stocks.index(code)
          text = File.open(File.join(dir, f)).read
          code_data = JSON.load text
          cap = {}
          cap["all"] = code_data["market cap"].gsub(",", "").to_i
          cap["all"] += code_data["market cap b"].gsub(",", "").to_i
          cap["a"] = code_data["live cap"].gsub(",", "").to_i
          cap["b"] = code_data["live cap b"].gsub(",", "").to_i
          cap["h"] = 0
          cap["restricted"] = cap["all"] - cap["a"] - cap["b"]

          data[code] = cap
        end
      end

      data
    end

    def update(identifier, params={})
      raise "not supported: cap.sz is saved with code.sz"
    end

    def list
      dir = data_dir
      data = {}

      Dir.entries(dir).each do |f|
        next if f.start_with? '.'

        f = f.gsub(".json", "")
        data[f] = true
      end

      data
    end

    def data_dir
      File.expand_path("../../data/code.sz", __FILE__)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  options = {}
  opts = OptionParser.new do |opts|
    Accessor.stock_options(options, opts)
    Accessor.common_options(options, opts)
  end

  opts.parse!
  Accessor.validate_stock_options(options, opts)

  gen = Accessor::CapSz.new
  data = gen.query options
  puts JSON.dump(data)
end

