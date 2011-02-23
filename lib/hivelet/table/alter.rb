module Hivelet
  module Table
    class Alter < Hivelet::Table::Base
      
      def initialize(tbl_name)
        @table = {
          :name => tbl_name,
          :recover => nil
        }
      end
      
      def recover_partitions
        @table[:recover] = true
      end
      
      def to_s
        statement =  "ALTER TABLE #{@table[:name]}"
        statement << " RECOVER PARTITIONS" if @table[:recover]
      end
      
    end
  end
end