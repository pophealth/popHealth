class FactoryHash < Hash
  def method_missing(method_name,*args)
    method_name = method_name.to_s
    if method_name =~ /=$/
      super if args.size > 1
      self[method_name[0...-1]] = args[0]
    else
      return nil unless has_key?(method_name) and args.empty?
      self[method_name]
    end
  end
  def save!
    Mongoid.default_session[@collection].insert(self, {safe: true})
  end
  def destroy
    Mongoid.default_session[@collection].remove({:_id => id})
  end
  def id
    self[:_id]
  end
  def collection(name)
    @collection = name
  end
end
