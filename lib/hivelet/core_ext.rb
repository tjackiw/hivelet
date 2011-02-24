class Object
  def try(method, *args, &block)
    send(method, *args, &block) if respond_to?(method, true)
  end
end

class Hash
  # Recursively removes nil and empty values from a hash and returns a new clean hash.
  # 
  # hash = { 
  #   :name => nil, 
  #   :country => 'US', 
  #   :preferences => {
  #     :quality => nil,
  #     :sites => {
  #       :small => [],
  #       :medium => []
  #     }
  #   } 
  # }
  # hash.cleanse
  # => {:country=>"US"}
  # 
  def cleanse
    self.each do |key, value|
      value.cleanse if value.is_a?(Hash)
      delete(key) if value.to_s.empty?
    end
  end
end
