require File.expand_path("../base", __FILE__)
require File.expand_path("../../storage", __FILE__)

module Stock
  module Jqka
    class DataLoader
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def update_dividend
        in_db_records = {}
        table = Stock::Storage::DB[:dividend]
        table.select(:id, :ex_date).each do |r|
          in_db_records["#{r[:id]}#{r[:ex_date]}"] = true
        end

        file = File.join(@path, Files::Dividend)
        File.open(file, "rb") do |f|
          header = Dividend.load_header(f)
          Dividend.load_records(f, header) do |r|
            unless in_db_records.include?("#{r[:id]}#{r[:ex_date]}")
              Stock::Storage::Dividend.insert_record(r)
            end
          end
        end
      end

      def update_d1bar
        table = Stock::Storage::DB[:d1bar]

        Dir.glob(File.join(@path, Files::D1BarPattern)).each do |f|
          id = f.split("/")[-1][0...-4]
          puts id

          record = table.where(:id => id, :src => "jqka").select(:date).order(:date).last
          last_update = record && record[:date] || Date.new(1970, 1, 1)

          File.open(f) do |f|
            header = D1Bar.load_header(f)
            ind = header.record_cnt - 1
            while ind >= 0
              record = D1Bar.load_records(f, header, ind)[0]
              ind -= 1

              next unless record

              if record[:date] <= last_update
                break
              end

              record[:id] = id
              record[:src] = "jqka"

              table.where(:id => id, :date => record[:date]).delete
              Stock::Storage::D1Bar.insert_record(record)
            end
          end
        end
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  require File.expand_path("../../boot", __FILE__)

  usage = "data_loader.rb path [tables]"
  all_tables = ["dividend", "d1bar"]

  if ARGV.size == 0
    puts usage
    exit 1
  end

  path = ARGV[0]
  tables = ARGV.size == 1 && all_tables || ARGV[1..-1]

  loader = Stock::Jqka::DataLoader.new(path)

  tables.each do |t|
    instance_eval("loader.update_#{t}")
  end
end
