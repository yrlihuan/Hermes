require "rubygems"
require "sequel"

module Stock
  module Storage
    DB = Sequel.connect("mysql://root@localhost/stock")

    class Base
      # subclass should define its own table & index class
      # variable and call generate_table.
      @@table = []
      @@index = []
      class << self
        protected
        def generate_table
          instance_eval(self.class_init_code)
        end

        def class_init_code
          code  = "DB.create_table?(:#{self.name.split('::')[-1].downcase}) do\n"
          @@table.each do |field_type|
            field, type = field_type.split(" ")
            code += "#{type} :#{field}\n"
          end

          @@index.each do |str|
            fields = str.split(",")
            if fields.size == 1
              code += "index :#{fields[0]}\n"
            else
              code += %Q$index [#{fields.map {|f| ":#{f}"}.join(",")}]$ + "\n"
            end
          end

          code += "end"
        end
      end
    end

    class D1Bar < Base
      @@table = ["date Date",
                 "open Float",
                 "high Float",
                 "low Float",
                 "close Float",
                 "amount Float",
                 "volumn Float",
                 "id String"]
      @@index = ["id,date"]
      self.generate_table
    end

    class Dividend < Base
      @@table = ["id String",
                 "ex_date String",
                 "cash Float",
                 "stock Float",
                 "allotment Float",
                 "allotment_price Float"]
      @@index = ["id,ex_date"]
      self.generate_table
    end
  end
end

if $PROGRAM_NAME == __FILE__
end
