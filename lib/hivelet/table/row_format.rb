module Hivelet
  module Table
    class RowFormat
      def initialize(format)
        @format = format
      end

      def serde(name, options={})
        valid_options = [:properties]
        unless (keys = (options.keys - valid_options)).empty?
          raise "Invalid parameters: #{ keys.join(', ') }. Valid parameters are: #{valid_options.join(', ')}"
        end
        @format[:serde] = { :name => name, :properties => options[:properties] }
      end

      def store(options = {})
        valid_options = [:as, :by]
        unless (keys = (options.keys - valid_options)).empty?
          raise "Invalid parameters: #{ keys.join(', ') }. Valid parameters are: #{valid_options.join(', ')}"
        end
        @format[:store].merge!(options)
      end
    end
  end
end