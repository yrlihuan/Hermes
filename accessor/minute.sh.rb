#
# filename: accessor/minute.sh.rb
# author: yrlihuan@gmail.com
#

require "rubygems"

require File.expand_path("../base.rb", __FILE__)
require File.expand_path("../code.sh.rb", __FILE__)

module Accessor
  class MinuteSh < Base
    def update(identifier, params={})
      data = params[:data]
      year = params[:year]
      month = params[:month]

      dir = File.join(data_dir, "#{code}")
      `mkdir -p #{dir}` unless File.exists? dir

      path = File.join(dir, "%d%2d.csv" % [year,month])
      f = File.open(path, 'w')
      f.write(data)
      f.close
    end

    def exists?(code, year, month)
      file = File.join(data_dir, "#{code}", "%d%2d.csv" % [year,month])
      File.exists? file
    end
  end
end

if $PROGRAM_NAME == __FILE__
  puts "for better performance, pls read the raw csv file directly"
end

