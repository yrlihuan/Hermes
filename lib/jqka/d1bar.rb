require File.expand_path("../base", __FILE__)

module Stock
  module Jqka
    class D1Bar < Base
      def self.load_records(fin, header, indices)
        records = []

        indices = self.format_indices(header, indices)

        indices.each do |i|
          fin.seek(header.header_len + header.record_len * i)
          record = {}

          # record len is 168
          fields = fin.read(header.record_len).unpack("iIIIIII")
          if fields[0] == 0
            puts "Invalid Record: pos => #{i}"
            next
          end

          record[:date] = self.parse_date(fields[0])
          record[:open] = self.parse_value(fields[1])
          record[:high] = self.parse_value(fields[2])
          record[:low] = self.parse_value(fields[3])
          record[:close] = self.parse_value(fields[4])
          record[:amount] = self.parse_value(fields[5])
          record[:volumn] = self.parse_value(fields[6])

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
