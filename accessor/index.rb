#
# filename: accessor/index.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"

require File.expand_path("../base.rb", __FILE__)

module Accessor
  class Index < Base
    def query(params={})
      dir = data_dir

      stocks = params[:stocks]

      data = {}
      Dir.entries(dir).each do |f|
        next if f.start_with? '.'

        code = f.gsub(".csv", "")

        if stocks.index(code)
          text = File.open(File.join(dir, f)).read
          lines = text.split("\n")

          index_data = {}
          lines.each do |l|
            stock_code, stock_name = l.split ','
            index_data[stock_code] = stock_name
          end

          data[code] = index_data
        end
      end

      data
    end
  end
end

if $PROGRAM_NAME == __FILE__
  options = {}
  opts = OptionParser.new do |opts|
    Accessor.stock_options(options, opts, false)
    Accessor.common_options(options, opts)
  end

  opts.parse!
  Accessor.validate_stock_options(options, opts)

  gen = Accessor::Index.new
  data = gen.query options

  puts JSON.dump(data)
end


