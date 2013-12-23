beforeEach ->
  jasmine.addMatchers
    toBeNew: ->
      compare: (actual) ->
        pass: actual.isNew()
    toBeValid: ->
      compare: (actual) ->
        pass: actual.isValid()
    toBeEmpty: ->
      compare: (actual) ->
        pass: actual.isEmpty()
