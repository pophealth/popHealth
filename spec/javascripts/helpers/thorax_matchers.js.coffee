beforeEach ->
  @addMatchers
    toBeNew: ->
      @actual.isNew()
    toBeValid: ->
      @actual.isValid()
    toBeEmpty: ->
      @actual.isEmpty()
