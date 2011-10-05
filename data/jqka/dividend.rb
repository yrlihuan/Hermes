require File.expand_path("../base", __FILE__)

module Stock
  module Jqka
    class Dividend < Base
      def self.load_records(fin, header, indices)
        records = []

        if indices.is_a? Integer
          indices = [indices]
        end

        indices.each do |i|
          fin.seek(header.header_len + header.record_len * i)
          record = {}

          # record len is 238
          fields = fin.read(header.record_len).unpack("iiiEEEEEiiZ178")
          record[:date] = self.parse_date(fields[0])
          record[:ex_date] = self.parse_date(fields[2])
          record[:cash] = fields[3]
          record[:split] = fields[4]
          record[:bonus] = fields[5]
          record[:allotment] = fields[6]
          record[:allotment_price] = fields[7]
          record[:reg_date] = self.parse_date(fields[8])
          record[:list_date] = self.parse_date(fields[9])
          record[:description] = fields[10]

          if block_given?
            yield record
          else
            records << record
          end
        end

        records
      end
    end
  end
end