require 'hivelet/core_ext'

module Hivelet
  VERSION = '0.1'
  
  autoload :ExternalFile,'hivelet/external_file'
  autoload :Interpreter, 'hivelet/interpreter'
  
  module Table
    autoload :Base,      'hivelet/table/base'
    autoload :Alter,     'hivelet/table/alter'
    autoload :Cluster,   'hivelet/table/cluster'
    autoload :Column,    'hivelet/table/column'
    autoload :Partition, 'hivelet/table/partition'
    autoload :RowFormat, 'hivelet/table/row_format'
  end
  
end
