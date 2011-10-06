require File.expand_path("../../data/boot", __FILE__)

require "test/unit"
require "date"
require "rubygems"
require "ruby-debug"

class Qkja < Test::Unit::TestCase
  D1BarSample = File.expand_path("../data/jqka/history/shase/600036.day", __FILE__)
  DividendSample = File.expand_path("../data/jqka/finance/权息资料.财经", __FILE__)

  class TestDataType < Stock::Jqka::Base
    def self.load_header_from_file(file)
      File.open(file, "rb") do |f|
        return self.load_header(f)
      end
    end
  end

  def test_header_type1
    header = TestDataType.load_header_from_file(D1BarSample)

    assert_equal(1932, header.record_cnt)
    assert_equal(184, header.header_len)
    assert_equal(168, header.record_len)
    assert_equal(42, header.field_cnt)
  end

  def test_header_type2
    header = TestDataType.load_header_from_file(DividendSample)

    assert_equal(0x8c60, header.record_cnt)
    assert_equal(0xda4e, header.header_len)
    assert_equal(0xee, header.record_len)
    assert_equal(0x0b, header.field_cnt)

    assert_equal((header.header_len - 16 - 4 - 6 * header.field_cnt) / 18, header.indices.size)
  end

  def test_index_block
    File.open(DividendSample, "rb") do |f|
      header = Stock::Jqka::Dividend.load_header(f)
      ind = header.indices["S000002"]
      assert_equal(ind != nil, true)
      assert_equal(ind.id, "S000002")
      assert_equal(ind.start_idx, 60)
      assert_equal(ind.total, 50)
      assert_equal(ind.free, 25)
      assert_equal(ind.used, 25)
    end
  end

  def test_d1bar
    File.open(D1BarSample, "rb") do |f|
      header = Stock::Jqka::D1Bar.load_header(f)
      Stock::Jqka::D1Bar.load_records(f, header, 1) do |record|
        assert_equal("2003-07-29", record[:date].to_s)
        assert_equal(11.40, record[:open])
        assert_equal(11.59, record[:high])
        assert_equal(11.40, record[:low])
        assert_equal(11.53, record[:close])
        assert_equal(119253077, record[:amount])
        assert_equal(10382655, record[:volumn])
      end
    end
  end

  def test_dividend
    File.open(DividendSample, "rb") do |f|
      header = Stock::Jqka::Dividend.load_header(f)
      Stock::Jqka::Dividend.load_records(f, header, 0) do |record|
        assert_equal("S000001", record[:id])
        assert_equal("1993-05-24", record[:date].to_s)
        assert_equal("1993-05-24", record[:ex_date].to_s)
        assert_equal(0.3, record[:cash])
        assert_equal(0.85, record[:stock])
        assert_equal(0.5, record[:bonus])
        assert_equal(0.1, record[:allotment])
        assert_equal(16.0, record[:allotment_price])
        assert_equal("1993-05-21", record[:reg_date].to_s)
        assert_equal("1993-05-24", record[:list_date].to_s)
      end

      records = Stock::Jqka::Dividend.load_records(f, header, 0.upto(1))
      record = records[1]
      assert_equal("S000001", record[:id])
      assert_equal("1994-07-09", record[:date].to_s)
      assert_equal("1994-07-09", record[:ex_date].to_s)
      assert_equal(0.0, record[:cash])
      assert_equal(0.0, record[:stock])
      assert_equal(0.0, record[:bonus])
      assert_equal(0.1, record[:allotment])
      assert_equal(5.0, record[:allotment_price])
      assert_equal("1970-01-01", record[:reg_date].to_s)
      assert_equal("1994-08-22", record[:list_date].to_s)
    end
  end
end
