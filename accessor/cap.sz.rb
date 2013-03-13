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
      # params = {}
      # params = {:code => "600036"}
      dir = data_dir
      puts dir

      c = params[:code]
      data = {}
      Dir.entries(dir).each do |f|
        next if f.start_with? '.'
        next if c && f.sub(".json", "") != c

        text = File.open(File.join(dir, f)).read
        code = f.gsub(".json", "")
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
  gen = Accessor::CapSz.new
  data = gen.query
  puts data.count
  puts data['000001']
end

