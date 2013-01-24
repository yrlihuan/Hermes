require File.expand_path("../../data/boot", __FILE__)

require "test/unit"
require "date"
require "rubygems"
require "ruby-debug"

class Storage < Test::Unit::TestCase
  class TestDataType < Stock::Storage::Base
    @table = ["date Date",
              "float Float",
              "integer Integer"]
    @index = ["date,float", "integer"]

    class << self
      attr_accessor :init_code
    end

    self.init_code = self.class_init_code
  end

  class TestDataType2 < Stock::Storage::Base
    @table = ["string String"]
    @index = ["string"]

    class << self
      attr_accessor :init_code
    end

    self.init_code = self.class_init_code
  end

  def test_base_init_code
    expected = <<-EOF
      DB.create_table?(:testdatatype) do
        Date :date
        Float :float
        Integer :integer
        index [:date,:float]
        index :integer
      end
    EOF

    expected.gsub!(/\n */, "\n").strip!
    assert_equal(expected, TestDataType.init_code)
  end

  def test_base_init_code2
    expected = <<-EOF
      DB.create_table?(:testdatatype2) do
        String :string
        index :string
      end
    EOF

    expected.gsub!(/\n */, "\n").strip!
    assert_equal(expected, TestDataType2.init_code)
  end
end


