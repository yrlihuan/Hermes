require "rubygems"
require "ruby-debug"
require File.expand_path("../../storage", __FILE__)

module Stock
  module Fxj
    class Dividend
      def to_s
        "#{@id}(#{@ex_date})"
      end

      def self.from_file(file)
        records = []

        File.open(file, "rb") do |f|
          data = f.read
          blocks = data[8...-1].split("\xff\xff\xff\xff")
          blocks[1..-1].each do |b|
            records << self.read_record(b)
          end
        end

        records.each do |r|
          r.update
        end
      end

      private
      def self.read_record(bytes)
        id, ex_date, cash, allotment, allotment_price, stock = bytes.unpack("Z16iffff")
        ex_date = Time.at(ex_date)
        ex_date = Date.new(ex_date.year, ex_date.month, ex_date.day)
        Stock::Storage::Dividend.new(id, ex_date, cash, allotment, allotment_price, stock)
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  Data::Fxj::Dividend.from_file("split.pwr")
end
