module Hivelet
  module Table
    class Column

      DATATYPES = [:tinyint, :smallint, :int, :bigint, :string, :double, :float, :boolean]

      DATATYPES.each do |type|
        define_method(type) do |*args|
          field, options = *args
          valid_options  = [:type, :comment]
          options = (options || {}).merge(:type => type)

          raise(Hivelet::MissingArgumentError.new("The column's name is missing!")) if field.to_s.empty?

          unless (keys = (options.keys - valid_options)).empty?
            raise Hivelet::Error.new("Invalid parameters: #{ keys.join(',') }")
          end

          @columns << [field, options]
        end
      end

      def initialize(columns)
        @columns = columns
      end  
    end
  end
end