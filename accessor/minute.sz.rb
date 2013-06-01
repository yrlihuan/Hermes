#
# filename: accessor/minute.sz.rb
# author: yrlihuan@gmail.com
#

require "rubygems"

require File.expand_path("../base.rb", __FILE__)
require File.expand_path("../code.sh.rb", __FILE__)
require File.expand_path("../minute.sh.rb", __FILE__)

module Accessor
  class MinuteSz < MinuteSh
  end
end

if $PROGRAM_NAME == __FILE__
  puts "for better performance, pls read the raw csv file directly"
end

