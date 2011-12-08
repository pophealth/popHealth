def between(min, max)
  span = max.to_i - min.to_i + 1
  min.to_i+rand(span)
end

def existing_max(collection, field)
  if MONGO_DB['providers'].find().count > 0
    map = "function() { emit(null, this.#{field}); }"
    reduce = "function (key, values) { return Math.max.apply(Math, values); }"
    return MONGO_DB[collection].map_reduce(map, reduce, :raw=>true, :out => {:inline => true})['results'].first['value']
  else 
    return 0
  end
end