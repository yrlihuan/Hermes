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
      # params = {}
      # params = {:code => "600036"}
      dir = data_dir

      code = params[:code]
      data = {}
      Dir.entries(dir).each do |f|
        next if f.start_with? '.'
        next if code && f.sub(".csv", "") != code

        text = File.open(File.join(dir, f)).read
        code = f.gsub("csv", "ss")
        data[code] = text
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

        f = f.gsub(".csv", ".ss")
        data[f] = true
      end

      data
    end
  end
end
