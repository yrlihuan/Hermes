#
# filename: fetcher/minute.sz.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"
require "date"

require File.expand_path("../../accessor/all.rb", __FILE__)
require File.expand_path("../base.rb", __FILE__)
require File.expand_path("../minute.sh.rb", __FILE__)

module Fetcher
  class MinuteSz < MinuteSh
   def code_cls
      Accessor::CodeSz
    end

    def url(code, year, month)
      "http://finance.sina.com.cn/realstock/company/sz#{code}/hisdata/#{year}/%02d.js" % month
    end
  end
end

if $PROGRAM_NAME == __FILE__
  options = {}
  opts = OptionParser.new do |opts|
     opts.on("-l", "--update_latest", "only run to update latest month") do |date|
      options[:update_latest] = true
    end
  end

  opts.parse!

  gen = Fetcher::MinuteSz.new
  gen.run(false, options[:update_latest])
end
