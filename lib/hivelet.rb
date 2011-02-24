require 'hivelet/core_ext'

module Hivelet
  VERSION = '0.1'
  
  autoload :Error,                'hivelet/error'
  autoload :MissingArgumentError, 'hivelet/error'
  autoload :TypeError,            'hivelet/error'

  autoload :ExternalFile,'hivelet/external_file'
  autoload :Interpreter, 'hivelet/interpreter'
  
  module Table
    autoload :Alter,     'hivelet/table/alter'
    autoload :Base,      'hivelet/table/base'
    autoload :Cluster,   'hivelet/table/cluster'
    autoload :Column,    'hivelet/table/column'
    autoload :Partition, 'hivelet/table/partition'
    autoload :RowFormat, 'hivelet/table/row_format'
    autoload :Select,    'hivelet/table/select'
  end
  
end
