module Hivelet
  class Error < StandardError
    
    def initialize(msg = "Runtime Error")
      @message = msg
    end
    
    def to_s
      @message
    end
    
  end
  
  class TypeError < Error; end
  class MissingArgumentError < Error; end
  
end