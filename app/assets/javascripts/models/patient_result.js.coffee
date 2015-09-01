class Thorax.Models.PatientResult extends Thorax.Model
  parse: (attrs) ->
    # JSON that comes back may be in the MongoDB M/R created format
    # We only want to work with the properties in value
    attrs = _.extend {}, attrs.value if attrs.value
    attrs.birthdate = attrs.birthdate * 1000
    attrs

class Thorax.Collections.PatientMeasureResults extends Thorax.Collection
  model: Thorax.Models.PatientResult
  url: -> "#{@parent.url()}/results"
  initialize: (attrs, options) ->
    @parent = options.parent

class Thorax.Collections.PatientResults extends Thorax.Collection
  model: Thorax.Models.PatientResult
  url: -> "#{@parent.url()}/patient_results"
  comparator: (p) ->
    [p.get("last"), p.get("first")]
  initialize: (attrs, options) ->
    @parent = options.parent
    @population = options.population
    @providerId = options.providerId
    @hasMoreResults = true
  currentPage: (perPage = 100) -> Math.ceil(@length / perPage)
  fetch: (options = {}) ->
    options.data ?= {}
    options.data[@population.toLowerCase()] = true if @population?
    options.data.provider_id = @providerId if @providerId?
    options.data.per_page = 10
    result = super(options)
    result.done => @hasMoreResults = /rel="next"/.test(result.getResponseHeader('Link'))
  fetchNextPage: (options = {perPage: 10}) ->
    data = {page: @currentPage(options.perPage) + 1, per_page: options.perPage}
    @fetch(remove: false, data: data) if @hasMoreResults

