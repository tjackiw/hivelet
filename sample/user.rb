
# This is a very simple example demonstrating how to use Hivelet
# 
# Output:
#   CREATE TABLE users (id INT, name STRING, email STRING, country STRING, validated BOOLEAN, created_at STRING) PARTITIONED BY (ds STRING);
#   INSERT OVERWRITE LOCAL DIRECTORY '/path/to/directory' SELECT * FROM users WHERE country = 'US' ORDER BY id DESC;
#   INSERT OVERWRITE LOCAL DIRECTORY '/path/to/directory' SELECT * FROM users WHERE validated = TRUE ORDER BY id DESC;
#   INSERT OVERWRITE LOCAL DIRECTORY '/path/to/directory' SELECT * FROM users WHERE country = 'US' AND validated = TRUE ORDER BY id DESC;

create('users') do |table|
  table.external    false
  table.overwrite   true

  table.columns do |column|
    column.int      :id
    column.string   :name
    column.string   :email
    column.string   :country
    column.boolean  :validated
    column.string   :created_at
  end

  table.partition do |p|
    p.string        :ds
  end
end

[ "country = 'US'", {:validated => true}, ["country = ? AND validated = ?", 'US', true] ].each do |conditions|
  select(:all, 
    :from       => 'users', 
    :conditions => conditions, 
    :into       => { :directory => '/path/to/directory', :local => true },
    :order      => "id DESC"
  )
end
