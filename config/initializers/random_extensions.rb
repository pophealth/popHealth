# there might be a better place to put this ...?

Kernel.class_eval do
  
  def rand_range(min, max)
    min == max ? min : min + rand(max-min)
  end
  
end