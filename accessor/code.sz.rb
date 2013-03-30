#
# filename: accessor/code.sz.rb
# author: yrlihuan@gmail.com
#

require File.expand_path("../code.sh.rb", __FILE__)

module Accessor
  class CodeSz < CodeSh
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

  gen = Accessor::CodeSz.new
  data = gen.query options

  puts JSON.dump(data)

end

