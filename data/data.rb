module Stock
  class DataBase
    def initialize(&blk)
      yield if block_given?
    end
  end

  class Dividend
    attr_reader :id, :reg_date, :ex_date, :cash, :stock, :allotment, :allotment_price

    def initialize(&blk)
      super(&blk)
    end
  end

  class D1Bar
    attr_reader :id, :date, :open, :close, :high, :low, :amount, :volumn

    def initialize(&blk)
      super(&blk)
    end
  end
end
