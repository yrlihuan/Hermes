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

  gen = Accessor::DailySz.new
  data = gen.query options

  puts JSON.dump(data)
end
