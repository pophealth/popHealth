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
        message: "Expected #{actual.cid} to be empty, but had a length of #{actual.length}."
