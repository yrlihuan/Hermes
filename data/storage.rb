require "rubygems"
require "sequel"

module Stock
  module Storage
    DB = Sequel.connect("mysql://root@localhost/stock")

    class Dividend
      DB.create_table?(:dividends) do
        String  :id
        Date    :ex_date
        Float   :cash
        Float   :stock
        Float   :allotment
        Float   :allotment_price
        index   [:id, :ex_date]
      end

      TABLE = DB[:dividends]

      def initialize(id, ex_date, cash, allotment, allotment_price, stock)
        @id = id
        @ex_date = ex_date
        @cash = cash
        @allotment = allotment
        @allotment_price = allotment_price
        @stock = stock
      end

      def update
        unless TABLE.select(:id).filter(:id => @id, :ex_date => @ex_date).first
          TABLE.insert(:id => @id,
                       :ex_date => @ex_date,
                       :cash => @cash,
                       :allotment => @allotment,
                       :allotment_price => @allotment_price,
                       :stock => @stock)
        end
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
end
