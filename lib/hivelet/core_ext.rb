class Object
  def try(method, *args, &block)
    send(method, *args, &block) if respond_to?(method, true)
  end
end

class Hash
  def prune
    self.each do |key, value|
      value.prune if value.is_a?(Hash)
      delete(key) if value.to_s.empty?
    end
  end
end
