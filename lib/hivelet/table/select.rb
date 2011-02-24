module Hivelet
  module Table
    class Select
      
      def initialize(scope, params = {})
        validate_arguments(scope, params)
        @statement = {
          :scope  => scope,
          :params => params
        }
      end
      
      def to_s
        #@statement.cleanse
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
        if @statement[:params].has_key?(:conditions)
          
        end
        if @statement[:params].has_key?(:group)
          statement << "GROUP BY #{@statement[:params][:group].join(", ")} "
        end
        if @statement[:params].has_key?(:order)
          statement << "ORDER BY "
          statement << ( @statement[:params][:order].is_a?(Array) ? @statement[:params][:order].join(", ") : @statement[:params][:order])
        end
      end
      
      private
      def validate_arguments(scope, params)
        valid_scopes  = [:first, :all, :last]
        valid_options = [:from, :conditions, :group, :into, :limit, :columns, :order]
        unless valid_scopes.include?(scope)
          raise "Invalid scope: #{ scope }. Valid scopes are: #{valid_scopes.join(', ')}"
        end
        unless (keys = (params.keys - valid_options)).empty?
          raise "Invalid parameters: #{ keys.join(', ') }. Valid parameters are: #{valid_options.join(', ')}"
        end
        
        # Required parameters
        raise "" unless params.has_key?(:from)
      end
      
    end
  end
end