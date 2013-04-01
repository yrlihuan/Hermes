#
# filename: accessor/daily.sh.rb
# author: yrlihuan@gmail.com
#

require "rubygems"

require File.expand_path("../base.rb", __FILE__)
require File.expand_path("../code.sh.rb", __FILE__)

module Accessor
  class DailySh < Base
    def query(params={})
      dir = data_dir

      all = params[:all]
      stocks = params[:stocks]
      from = (params[:from] or Date.parse("1900-01-01")).to_s
      to = (params[:to] or Date.today).to_s

      data = {}
      Dir.entries(dir).each do |f|
        next if f.start_with? '.'

        code = f.gsub(".csv", "")

        if all or stocks.index(code)
          text = File.open(File.join(dir, f)).read
          lines = text.split("\n")
          headers = lines[0].split(",")
          rows = []

          lines[1..-1].each do |l|
            values = l.split(",")
            # make sure the date is in the range
            # TODO: here is plenty room of optimization
            if values[0] >= from && values[0] <= to
              rows << l.split(",").map {|str| str.to_f}
            end
          end

          data[code] = {:header => headers, :data => rows}
        end
      end

      data
    end

    def update(identifier, params={})
      data = params[:data]
      path = File.join(data_dir, "#{identifier}.csv")

      f = File.open(path, 'w')
      f.write(data)
      f.close
    end

    def list
      dir = data_dir
      data = {}

      Dir.entries(dir).each do |f|
        next if f.start_with? '.'

        f = f.gsub(".csv", "")
        data[f] = true
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
    Accessor.time_options(options, opts)
  end

  opts.parse!
  Accessor.validate_stock_options(options, opts)
  Accessor.validate_time_options(options, opts)

  gen = Accessor::DailySh.new
  data = gen.query options

  puts JSON.dump(data)
end

