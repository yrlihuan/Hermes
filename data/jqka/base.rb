module Stock
  module Jqka
    # Header structure of 10jqka data file.
    # Schema 1 (without index block):
    #   Header:
    #     Finger Print: 6 bytes
    #     Record Count: 4 bytes
    #     Header Length: 2 bytes
    #     Record Length: 2 bytes
    #     Field Count: 2 bytes
    #     Fields Definition: Field Count * 4 bytes
    #   Data Block:
    #     Record Length * Record Count
    #
    # Schema 2 (with index block):
    #   Header:
    #     ...
    #     Stuffing Block: Field Count * 2 bytes
    #     Index Block:
    #       Block Size: 2 bytes
    #       Index Count: 2 bytes
    #       Block Data: Index Count * 18 bytes
    #   Data Block:
    #
    class Header
      FingerPrint = "\x68\x64\x31\x2e\x30\x00"

      attr_accessor :record_cnt, :header_len, :record_len
      attr_accessor :field_cnt, :fields, :indices

      class FieldDef
        attr_reader :type, :size
        def initialize(type, size)
          @type, @size = type, size
        end
      end

      class IndexDef
        attr_reader :id, :start_idx, :total, :free
        def initialize(market, id, start_idx, total_records, free_records)
          if market == 0x10
            market_id = "S"
          elsif market == 0x50
            market_id = "H"
          elsif market == 0x4a
            market_id = "B"
          else
            market_id = "U"
          end

          @id = market_id + id
          @start_idx = start_idx
          @total = total_records
          @free = free_records
        end

        def used
          @total - @free
        end
      end

      def initialize
        @fields = []
        @indices = {}
      end

      def add_field(type, size)
        @fields << FieldDef.new(type, size)
      end

      def add_index_entity(market, id, start_idx, total_records, free_records)
        idx_entity = IndexDef.new(market, id, start_idx, total_records, free_records)
        @indices[idx_entity.id] = idx_entity
      end
    end

    class Base
      SCALERS = [1.0, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0, 10000000.0]

      class << self
        def load_header(fin)
          header = Header.new

          # Finger print
          fin.seek(0)
          if fin.read(Header::FingerPrint.length) != Header::FingerPrint
            raise "not a valid jqka data file!"
          end

          # Header info
          record_cnt, header_len, record_len, field_cnt = fin.read(10).unpack("ISSS")

          record_cnt &= 0xffffff
          header.record_cnt = record_cnt
          header.header_len = header_len
          header.record_len = record_len
          header.field_cnt = field_cnt

          # Field definition
          1.upto(field_cnt) do
            w1, type, w2, size = fin.read(4).unpack("CCCC")
            header.add_field(type, size)
          end

          # If schema 1
          if 16 + 4 * field_cnt == header_len
            return header
          end

          # Skip stuffing section
          fin.seek(2 * field_cnt, IO::SEEK_CUR)

          # Index block
          index_block_len, index_cnt = fin.read(4).unpack("SS")
          1.upto(index_cnt) do
            market, id, free_records, start_idx, total_records = fin.read(18).unpack("CZ9SIS")
            header.add_index_entity(market, id, start_idx, total_records, free_records)
          end

          header
        end

        protected
        def format_indices(header, indices)
          if indices.is_a? Integer
            indices = [indices]
          elsif indices == nil
            if header.indices.size == 0
              indices = 0.upto(header.record_cnt - 1)
            else
              indices = []
              header.indices.each do |id,ind|
                indices += ind.start_idx.upto(ind.start_idx+ind.total-ind.free-1).map {|v| v}
              end
            end
          end

          indices
        end

        def match_ids_for_indices(header, indices)
          mapping = {}

          header.indices.each do |id,ind|
            ind.start_idx.upto(ind.start_idx+ind.total-ind.free-1) do |i|
              mapping[i] = id
            end
          end

          matches = {}
          indices.each do |i|
            matches[i] = mapping[i]
          end

          matches
        end

        def parse_date(i)
          if i < 0
            Date.new(1970, 1, 1)
          else
            Date.new(i/10000, (i%10000)/100, i%100)
          end
        end

        def parse_value(uint)
          value = uint & 0x0fffffff
          sgn = uint >> 31
          amplifier = (uint >> 28) & 0x7

          if amplifier != 0
            if sgn != 0
              value /= SCALERS[amplifier]
            else
              value *= SCALERS[amplifier]
            end
          end

          value
        end
      end
    end
  end
end
