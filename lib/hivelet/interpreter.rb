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
  class Interpreter
    
    def initialize(&block)
      @top_level_statements = [ ]
      interpret(&block) if block_given?
    end
  
    def interpret(&block)
      instance_eval(&block) if block_given?
      self
    end
    
    def to_hive
      @top_level_statements.flatten.map{ |s| s.to_s }.reject{|st| st.to_s.strip.empty?}.join(";\n") + ";\n"
    end
    
    protected
    def hive(&block)
      @top_level_statements << yield
    end
    
    def add(options={}, &block)
      file = Hivelet::ExternalFile.new(options, &block)
      yield(file) if block_given?
      @top_level_statements << file
      file
    end
    
    def create(tbl_name, &block)
      table = Hivelet::Table::Base.new(tbl_name)
      yield(table) if block_given?
      @top_level_statements << table
      table
    end
    
    def alter(tbl_name, &block)
      table = Hivelet::Table::Alter.new(tbl_name)
      yield(table) if block_given?
      @top_level_statements << table
      table
    end
    
    def select(scope, options = {})
      @top_level_statements << Hivelet::Table::Select.new(scope, options)
    end
  end
end