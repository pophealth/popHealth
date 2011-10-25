def between(min, max)
  span = max.to_i - min.to_i + 1
  min.to_i+rand(span)
end