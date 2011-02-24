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
    class Select
      
      include Hivelet::Table::Quoting
      
      def initialize(scope, params = {})
        validate_arguments(scope, params)
        @statement = {
          :scope  => scope,
          :params => params
        }
      end
      
      def to_s
        @statement.cleanse
        statement = ""
        if @statement[:params].has_key?(:into)
          statement << "INSERT OVERWRITE "
          statement << "LOCAL " if @statement[:params][:into][:local]
          statement << "TABLE #{@statement[:params][:into][:table]} " if @statement[:params][:into].has_key?(:table)
          statement << "DIRECTORY '#{@statement[:params][:into][:directory]}' " if @statement[:params][:into].has_key?(:directory)
        end
        statement << "SELECT "
        statement << (@statement[:params].has_key?(:columns) ? @statement[:params][:columns].join(", ") : "*")
        statement << " FROM #{@statement[:params][:from]} "
        
        if @statement[:params].has_key?(:conditions) && conditions = @statement[:params][:conditions]
          statement << "WHERE "
          query, *values = conditions          
          statement << if query.include?('?')
            replace_variables(query, values)
          elsif query.is_a?(Hash)
            query.collect{|k,v| "#{k} = #{quote(v)}"}.join(' AND ')
          else
            query % values.collect { |value| quote_string(value.to_s) }
          end
          statement << " "
        end
        
        if @statement[:params].has_key?(:group)
          statement << "GROUP BY #{@statement[:params][:group].join(", ")} "
        end
        
        if @statement[:params].has_key?(:order)
          statement << "ORDER BY "
          statement << ( @statement[:params][:order].is_a?(Array) ? @statement[:params][:order].join(", ") : @statement[:params][:order])
        end
        
        if @statement[:scope] == :first
          statement << " LIMIT 1"
        end
        
        statement
      end
      
      private
      def validate_arguments(scope, params)
        valid_scopes  = [:first, :all]
        valid_options = [:from, :conditions, :group, :into, :limit, :columns, :order]
        unless valid_scopes.include?(scope)
          raise Hivelet::Error.new("Invalid scope: #{ scope }. Valid scopes are: #{valid_scopes.join(', ')}")
        end
        unless (keys = (params.keys - valid_options)).empty?
          raise Hivelet::Error.new("Invalid parameters: #{ keys.join(', ') }. Valid parameters are: #{valid_options.join(', ')}")
        end
        
        # Required parameters
        raise(Hivelet::MissingArgumentError.new("The select statement is missing the :from parameter.")) unless params.has_key?(:from)
      end
      
      # Replaces '?' with actual values.
      # Borrowed from ActiveRecord
      def replace_variables(statement, values)
        raise_if_arity_mismatch(statement, statement.count('?'), values.size)
        bound = values.dup
        statement.gsub('?') { quote(bound.shift) }
      end
      
      # Borrowed from ActiveRecord
      def raise_if_arity_mismatch(statement, expected, provided)
        unless expected == provided
          raise Hivelet::Error.new("Wrong number of bind variables (#{provided} for #{expected}) in: #{statement}")
        end
      end
      
    end
  end
end