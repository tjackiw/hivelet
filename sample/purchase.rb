require 'date'

add :jar => 's3://elasticmapreduce/samples/hive-ads/libs/jsonserde.jar'

create('ofx_purchases') do |table|
  table.external    true
  table.overwrite   false

  table.columns do |column|
    column.int      :user_id
    column.int      :client_application_id
    column.string   :item
    column.int      :item_id
    column.float    :cost
    column.boolean  :restored
    column.string   :country
    column.string   :created_at
  end

  table.partition do |p|
    p.string        :ds
  end

  table.rowformat do |rf|
    rf.serde 'com.amazon.elasticmapreduce.JsonSerde', :properties => "'paths'='user_id, client_application_id, event.dlc.purchase.item, event.dlc.purchase.id, event.dlc.purchase.cost, event.dlc.purchase.restored, event.dlc.purchase.country, timestamp'"
  end
  
  table.location 'hdfs_path'
end

alter('ofx_purchases') do |table|
  table.recover_partitions
end

select(:all, 
  :from       => 'ofx_purchases', 
  :columns    => ["client_application_id", "count", "sum(cost)", "to_date(created_at)"], 
  :conditions => ["item = ? AND ds = ? AND age = ? AND b = ?", 'sales', Date.today.to_s, nil, 3.123456789], 
  :group      => ["client_application_id", "to_date(created_at)"], 
  :into       => { :directory => '/path/to/directory', :local => true },
  :order      => ["item DESC", "a ASC"]
)

