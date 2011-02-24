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