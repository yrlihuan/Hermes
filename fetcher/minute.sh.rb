#
# filename: fetcher/minute.sh.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"
require "date"

require File.expand_path("../../accessor/all.rb", __FILE__)
require File.expand_path("../base.rb", __FILE__)

module Fetcher
  class MinuteSh < Base
    def run(force_update=false)
      accessor = accessor_cls.new

      # SINA only have data after 2008 :(
      today = Date.today
      months_since_2008 = 12 * (today.year - 2008) + today.month

      codes = Accessor::CodeSh.new.query({:all => true}).keys
      codes.each do |code|
        # update date prior to the current month
        1.upto(months_since_2008-1) do |months|
          y = (months-1) / 12 + 2008
          m = (months-1) % 12 + 1

          data_existed = accessor.exists?(code, y, m)
          next if !force_update && data_existed

          raw = fetch_data(code, y, m)
          parsed = parse_data(raw)

          if parsed
            save_data(code, y, m, parsed)
          end

        end
      end
    end

    def url(code, year, month)
      "http://finance.sina.com.cn/realstock/company/sh#{code}/hisdata/#{year}/%02d.js" % month
    end

    def fetch_data(code, year, month)
      puts "#{url(code, year, month)}"
      `curl -s "#{url(code, year, month)}"`
    end

    def parse_data(raw)
      # check "http://finance.sina.com.cn/realstock/company/sh600036/hisdata/2013/02.js" for a sample data
      return nil unless raw.start_with? 'var'

      parts = raw.split('"')
      return nil unless parts.count == 3

      result = ''
      script = File.expand_path("../../tools/sina_finance_decoder/SinaFinanceDecoder.xml", __FILE__)
      parts[1].split(',').each do |daily_data|
        puts script
        result += `adl #{script} -- #{daily_data}`
      end

      # TODO: how to validate the result
      result[1...-1] # remove the trailing newline
    end

    def save_data(code, year, month, text)
      accessor = accessor_cls.new
      accessor.update(code, :data => text, :year => year, :month => month)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  gen = Fetcher::MinuteSh.new
  gen.run
end
