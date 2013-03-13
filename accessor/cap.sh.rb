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
      # params = {}
      # params = {:code => "600036"}
      dir = data_dir

      c = params[:code]
      data = {}
      Dir.entries(dir).each do |f|
        next if f.start_with? '.'
        next if c && f.sub(".json", "") != c

        text = File.open(File.join(dir, f)).read
        code = f.gsub(".json", "")
        data[code] = JSON.load text
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
