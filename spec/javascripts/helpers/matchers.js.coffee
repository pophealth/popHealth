beforeEach ->
  @addMatchers
    toBeInstanceOf: (klass) ->
      @actual instanceof klass

    toDeeplyEqual: (obj) ->
      _(@actual).isEqual obj
