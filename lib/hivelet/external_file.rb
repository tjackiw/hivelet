module Hivelet
  class ExternalFile
    
    def initialize(options = {}, &block)
      @statements = []
      unless block_given?
        valid_options = [:jar, :file]
        unless (keys = (options.keys - valid_options)).empty?
          raise Hivelet::Error.new("Invalid parameters: #{ keys.join(', ') }. Valid parameters are: #{valid_options.join(', ')}")
        end
        options.each_pair do |key,value|
          @statements << "ADD #{key.to_s.upcase} #{value}"
        end
      end
    end
    
    def jar(path)
      @statements << "ADD JAR #{path}"
    end
    
    def file(path)
      @statements << "ADD FILE #{path}"
    end
    
    def to_s
      @statements
    end
  end
end