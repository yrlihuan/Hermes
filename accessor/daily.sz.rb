#
# filename: accessor/daily.sz.rb
# author: yrlihuan@gmail.com
#

require "rubygems"

require File.expand_path("../base.rb", __FILE__)
require File.expand_path("../code.sz.rb", __FILE__)
require File.expand_path("../daily.sh.rb", __FILE__)

module Accessor
  class DailySz < DailySh
    def query(params={})
      # params = {}
      # params = {:code => "000001"}

      data = super(params)
      data2 = {}
      data.each do |k,v|
        data2[k.gsub('.ss', '.sz')] = v
      end

      data2
    end

    def list
      data = super()
      data2 = {}
      data.each do |k,v|
        data2[k.gsub('.ss', '.sz')] = v
      end

      data2
    end
  end
end

if $PROGRAM_NAME == __FILE__
  acc = Accessor::DailySz.new
  data = acc.query
  puts data.count
end
