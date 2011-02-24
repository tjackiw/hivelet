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
    autoload :Quoting,   'hivelet/table/quoting'
    autoload :RowFormat, 'hivelet/table/row_format'
    autoload :Select,    'hivelet/table/select'
  end
  
end
