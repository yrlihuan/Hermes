#
# filename: accessor/cap.sh.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"

require File.expand_path("../base.rb", __FILE__)

module Accessor
  class CapSh < Base
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
          data[code] = JSON.load text
        end
      end

      data
    end

    def update(identifier, params={})
      data = {}
      data["all"] = params[:all]
      data["a"] = params[:a]
      data["b"] = params[:b]
      data["h"] = params[:h]
      data["restricted"] = params[:restricted]
      path = File.join(data_dir, "#{identifier}.json")

      f = File.open(path, 'w')
      f.write(JSON.dump(data))
      f.close
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

  gen = Accessor::CapSh.new
  data = gen.query options
  puts JSON.dump(data)
end

