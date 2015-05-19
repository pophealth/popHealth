class Thorax.Models.Measure extends Thorax.Model
  idAttribute: '_id'
  url: ->
    url = @collection?.url
    subId = @get 'sub_id'
    url += "/#{@get 'hqmf_id'}" unless @isNew()
    url += "?sub_id=#{subId}" if subId = @get('sub_id')
    return url
  parse: (attrs) ->
    data = _(attrs).omit 'subs', 'sub_ids'
    subs = for sub in attrs.subs or []
      subData = _(sub).extend(data)
      subData.isPrimary = !sub.sub_id? or sub.sub_id is 'a'
      subData 
    @effectiveDate = @collection?.effectiveDate
    @effectiveFromDate = @collection?.effectiveFromDate
    @effectiveToDate = @collection?.effectiveToDate
    attrs.submeasures = new SubCollection subs, parent: this
    attrs
   sync: (method, model, options) ->
    if method isnt 'update'
      super
    else
      options.url = 'api/measures/update_metadata'
      super('create', model, options) # POST to this URL to update


class Thorax.Collections.Measures extends Thorax.Collection
  model: Thorax.Models.Measure
  url: '/api/measures'
  comparator: 'name'
  initialize: (models, options) ->
    @parent = options?.parent
    @hasMoreResults = true
    @effectiveDate = @parent?.effectiveDate
    @effectiveFromDate = @parent?.effectiveFromDate
    @effectiveToDate = @parent?.effectiveToDate
  currentPage: (perPage = 100) -> Math.ceil(@length / perPage)
  fetch: ->
    result = super
    result.done => @hasMoreResults = /rel="next"/.test(result.getResponseHeader('Link'))
  fetchNextPage: (options = {perPage: 10}) ->
    data = {page: @currentPage(options.perPage) + 1, per_page: options.perPage}
    @fetch(remove: false, data: data) if @hasMoreResults

class Thorax.Models.Submeasure extends Thorax.Model
  idAttribute: 'sub_id'
  url: -> "/api/measures/#{@get('id')}"
  initialize: ->
    # TODO remove @get('query') when we upgrade to Thorax 3
    @effectiveDate = @collection?.effectiveDate
    @effectiveFromDate = @parent?.effectiveFromDate
    @effectiveToDate = @parent?.effectiveToDate
    query = new Thorax.Models.Query({measure_id: @get('id'), sub_id: @get('sub_id'), effective_date: @effectiveDate, effective_from_date: @effectiveDate, effective_to_date: @effectiveDate }, parent: this) 
    @set 'query', query
    @queries = {}
  isPopulated: -> @has 'IPP'
  fetch: (options = {}) ->
    options.data = {sub_id: @get('sub_id')} unless options.data?
    super(options)
  parse: (attrs) ->
    attrs = $.extend true, {}, attrs
    attrs.id = attrs.hqmf_id
    # turn {someKey: {title: 'title'}} into {id: 'someKey', title: 'title'}
    dataCriteria = for id, criteria of attrs.hqmf_document.data_criteria
      _(criteria).extend id: id
    attrs.data_criteria = new Thorax.Collections.DataCriteria dataCriteria, parse: true
    # only create populations for those that apply to this submeasure
    for popName, population of attrs.hqmf_document.population_criteria when population.hqmf_id is attrs.population_ids[population.type]
      # track the original type of the population (NUMER, or NUMER_1)
      population.original_type = popName
      attrs[population.type] = new Thorax.Models.Population population, parse: true
      attrs[population.type].parent = this
    attrs
  getQueryForProvider: (providerId) ->
    query = @queries[providerId] or new Thorax.Models.Query({measure_id: @get('id'), sub_id: @get('sub_id'), effective_date: @effectiveDate, effective_from_date: @effectiveDate, effective_to_date: @effectiveDate, providers: [providerId]}, parent: this)
    @queries[providerId] ?= query


class SubCollection extends Thorax.Collection
  model: Thorax.Models.Submeasure
  initialize: (models, options) -> 
    @parent = options.parent
    @effectiveDate = @parent?.effectiveDate
  comparator: 'sub_id'
