class Thorax.Models.PatientResult extends Thorax.Model
  parse: (attrs) ->
    # JSON that comes back is in the MongoDB M/R created format
    # We only want to work with the properties in value
    attrs = _.extend {}, attrs.value
    attrs.birthdate = attrs.birthdate * 1000
    attrs

class Thorax.Collections.PatientResults extends Thorax.Collection
  model: Thorax.Models.PatientResult
  url: -> "#{@parent.url()}/patient_results"
  initialize: (attrs, options) ->
    @parent = options.parent
    @population = options.population
    @page = 1
  fetch: (options = {}) ->
    options.data ?= {}
    options.data[@population.toLowerCase()] = true if @population?
    super options
  fetchNextPage: (options = {perPage: 10}) ->
    data = {page: ++@page, per_page: options.perPage}
    @fetch remove: false, data: data
