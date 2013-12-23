beforeEach ->
  jasmine.addMatchers
    toBeInstanceOf: ->
      compare: (actual, klass) ->
        pass: actual instanceof klass

    toDeeplyEqual: ->
      compare: (actual, obj) ->
        pass: _(actual).isEqual obj