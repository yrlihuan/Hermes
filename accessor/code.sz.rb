#
# filename: accessor/code.sz.rb
# author: yrlihuan@gmail.com
#

require File.expand_path("../code.sh.rb", __FILE__)

module Accessor
  class CodeSz < CodeSh
    def query(params={})
      raw_data = query_raw(params)

      data = {}
      raw_data.each do |code, dict|
        if params[:more]
          data[code] = {:name => dict["name"], :ipo_date => dict["ipo date"]}
        else
          data[code] = dict["name"]
        end
      end

      data
    end
  end
end

if $PROGRAM_NAME == __FILE__
  options = {}
  opts = OptionParser.new do |opts|
    Accessor.stock_options(options, opts)
    Accessor.common_options(options, opts)
    Accessor::CodeSz.advanced_options(options, opts)
  end

  opts.parse!
  Accessor.validate_stock_options(options, opts)

  gen = Accessor::CodeSz.new
  data = gen.query options

  puts JSON.dump(data)

end

