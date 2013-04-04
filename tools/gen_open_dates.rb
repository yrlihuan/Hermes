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

    prices.each do |row|
      dates[row[0]] = true
    end
  end

  dates.keys.sort.each do |d|
    puts d
  end
end

