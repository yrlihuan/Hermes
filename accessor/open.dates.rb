#
# filename: accessor/date.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"

require File.expand_path("../base.rb", __FILE__)

module Accessor
  class OpenDates < Base
    def query(params={})
      dir = data_dir

      from = (params[:from] or Date.parse("1900-01-01")).to_s
      to = (params[:to] or Date.today).to_s

      dates = File.open(File.join(dir, "hs.txt")).read().split("\n")

      dates.find_all {|d| d >= from && d <= to}
    end
  end
end

if $PROGRAM_NAME == __FILE__
  options = {}
  opts = OptionParser.new do |opts|
    Accessor.time_options(options, opts)
  end

  opts.parse!
  Accessor.validate_time_options(options, opts)

  gen = Accessor::OpenDates.new
  data = gen.query options

  puts JSON.dump(data)
end

