add :jar => 's3://path/to/file', :file => 'local/path/to/file'

table = create('table_name')
table.external    true
table.overwrite   false
table.comment     "This table rocks!"

table.columns do |column|
  column.int      :id, {:comment => 'a'}
  column.string   :name
  column.boolean  :valid      
end

table.partition do |p|
  p.string        :ds, :comment => "Not sure about this one"
  p.string        :country
end

table.cluster do |c|
  c.columns [:a, "b"]
  c.sort [:a, {:b => :desc}]
  c.buckets 32
end

table.rowformat do |rf|
  rf.serde 'sdfsdf', :properties => "sdf"
  rf.store :as => 'file_format', :by => 'storage.handler.class'
  # rf.delimiter do |d|
  #   d.fields '\001'
  #   t.collection '\002'
  #   t.map '\003'
  # end
end
  
table.location 'hdfs_path'
