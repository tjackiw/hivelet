# Copyright (c) 2011 Thiago Jackiw
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Hivelet
  module Table    
    class Base
  
      def initialize(tbl_name)
        @table = {
          :name       => tbl_name,
          :external   => false,
          :overwrite  => true,
          :columns    => [],
          :partitions => [],
          :comment    => nil,
          :cluster    => { 
            :columns  => [], 
            :sort     => [], 
            :buckets  => nil 
          },
          :location   => nil,
          :rowformat  => {
            :serde => {
              :name => nil,
              :properties => {}
            },
            :store => {
              :as => nil,
              :by => nil
            }
          }
        }
      end
  
      def external(bool)
        @table[:external] = bool
      end
  
      def overwrite(bool)
        @table[:overwrite] = bool
      end
  
      def comment(text)
        @table[:comment] = text
      end
  
      def columns(&block)
        column = Hivelet::Table::Column.new(@table[:columns])
        yield(column)
      end
  
      def partition(&block)
        partition = Hivelet::Table::Partition.new(@table[:partitions])
        yield(partition)
      end
  
      def cluster(&block)
        cluster = Hivelet::Table::Cluster.new(@table[:cluster])
        yield(cluster)
      end
  
      def location(path)
        @table[:location] = path
      end
  
      def rowformat(&block)
        format = Hivelet::Table::RowFormat.new(@table[:rowformat])
        yield(format)
      end
      
      def to_s
        @table.cleanse
        statement = "CREATE "
        statement << "EXTERNAL " if @table[:external]
        statement << "TABLE "
        statement << "IF NOT EXISTS " unless @table[:overwrite]
        statement << "#{ @table[:name] } ("
        columns = [] 
        @table[:columns].each do |column|
          name, options = column
          columns << "#{ name.to_s } #{ options[:type].to_s.upcase }#{ " COMMENT \"#{options[:comment]}\"" if options.has_key?(:comment)}"
        end
        statement << "#{columns.join(', ')})"
        statement << " COMMENT \"#{@table[:comment]}\"" if @table[:comment]

        unless @table[:partitions].empty?
          statement << " PARTITIONED BY ("
          columns = [] 
          @table[:partitions].each do |column|
            name, options = column
            columns << "#{ name.to_s } #{ options[:type].to_s.upcase }#{ " COMMENT \"#{options[:comment]}\"" if options.has_key?(:comment)}"
          end
          statement << "#{columns.join(', ')})"
        end
    
        if @table.has_key?(:cluster)
          unless @table[:cluster][:columns].empty?
            statement << " CLUSTERED BY #{ @table[:cluster][:columns].join(', ') }"
            unless @table[:cluster][:sort].empty?
              cols = []
              @table[:cluster][:sort].each do |sort|
                if sort.is_a?(Symbol) || sort.is_a?(String)
                  cols << sort.to_s
                elsif sort.is_a?(Hash)
                  cols << "#{sort.keys.pop.to_s} #{sort.values.pop.to_s.upcase}"
                end
              end
              statement << " SORTED BY #{cols.join(', ')}"
            end
            statement << " INTO #{@table[:cluster][:buckets]} BUCKETS"
          end
        end
    
        if @table.has_key?(:rowformat)
          if @table[:rowformat].has_key?(:serde)
            statement << " ROW FORMAT SERDE '#{ @table[:rowformat][:serde][:name] }'"
            statement << " WITH SERDEPROPERTIES (#{ @table[:rowformat][:serde][:properties]})"
          end
          if @table[:rowformat].has_key?(:store)
            statement << " STORED AS #{ @table[:rowformat][:store][:as] }" if @table[:rowformat][:store][:as]
            statement << " STORED BY #{ @table[:rowformat][:store][:by] }" if @table[:rowformat][:store][:by]
          end
        end
    
        statement << " LOCATION \"#{@table[:location]}\"" if @table[:location]
        return( statement )
      end
    end
  end
end