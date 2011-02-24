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