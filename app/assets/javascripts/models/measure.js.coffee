class Thorax.Models.Measure extends Thorax.Model
  parse: (attrs) ->
    data = _(attrs).omit 'subs', 'sub_ids'
    subs = for sub in attrs.subs
      subData = _(sub).extend(data)
      subData.isPrimary = !sub.sub_id? or sub.sub_id is 'a'
      subData
    attrs.submeasures = new SubCollection subs, parent: this
    attrs

class Thorax.Collections.Measures extends Thorax.Collection
  model: Thorax.Models.Measure
  initialize: (models, options) -> @parent = options.parent
  comparator: 'name'

class Thorax.Models.Submeasure extends Thorax.Model
  idAttribute: 'sub_id'
  url: -> "/api/measures/#{@get('id')}"
  initialize: ->
    # FIXME don't use hardcoded effective date
    # TODO remove @get('query') when we upgrade to Thorax 3
    query = new Thorax.Models.Query({measure_id: @get('id'), sub_id: @get('sub_id'), effective_date: Config.effectiveDate}, parent: this)
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
    query = @queries[providerId] or new Thorax.Models.Query({measure_id: @get('id'), sub_id: @get('sub_id'), effective_date: Config.effectiveDate, providers: [providerId]}, parent: this)
    @queries[providerId] ?= query


class SubCollection extends Thorax.Collection
  model: Thorax.Models.Submeasure
  initialize: (models, options) -> @parent = options.parent
  comparator: 'sub_id'

