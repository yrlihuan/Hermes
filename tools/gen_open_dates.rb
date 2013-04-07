#!/usr/bin/env ruby

#
# filename: tools/opening_dates.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"

require File.expand_path("../../accessor/all.rb", __FILE__)

if $PROGRAM_NAME == __FILE__
  dates = {}

  codes = Accessor::CodeSh.new.query({:all => true}).keys
  codes.each do |c|
    data = Accessor::DailySh.new.query({:stocks => [c]})
    prices = data[c][:data]

    next_date = nil
    next_close = nil
    prices.each do |row|
      date = row[0]
      close = row[1]

      # yahoo's data don't align with chinese festivals
      dates[next_date] = true if next_date and next_close != close

      next_date = date
      next_close = close
    end
  end

  dates.keys.sort.each do |d|
    puts d
  end
end

