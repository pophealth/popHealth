class Thorax.Models.Measure extends Thorax.Model
  parse: (attrs) ->
    data = _(attrs).omit 'subs', 'sub_ids'
    subs = for sub in attrs.subs
      subData = _(sub).extend(data)
      subData.isPrimary = !sub.sub_id? or sub.sub_id is 'a'
      subData.isContinuous = sub.continuous_variable is true
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
    query = new Thorax.Models.Query({measure_id: @get('id'), sub_id: @get('sub_id'), effective_date: Config.effectiveDate}, parent: this)
    @set 'query', query
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

class SubCollection extends Thorax.Collection
  model: Thorax.Models.Submeasure
  initialize: (models, options) -> @parent = options.parent


class Thorax.Models.Query extends Thorax.Model
  idAttribute: '_id'
  urlRoot: '/api/queries'
  initialize: (attrs, options) ->
    @parent = options.parent
    @set 'patient_results', new Thorax.Collections.PatientResults [], parent: this
  # TODO what other final states are there other than completed?
  isPopulated: -> @has('status') and @get('status').state in ['completed']
  isLoading: -> !@isPopulated()
  isContinuous: -> @has('population_ids') and @get('population_ids').hasOwnProperty('MSRPOPL')
  ipp: -> if @isPopulated() and @has('result') then @get('result').IPP else 0
  msrpopl: -> if @isPopulated() and @has('result') then @get('result').MSRPOPL else 0
  numerator: -> if @isPopulated() and @has('result') then @get('result').NUMER else 0
  denominator: -> if @isPopulated() and @has('result') then @get('result').DENOM else 0
  observ: -> if @isPopulated() and @has('result') then @get('result').OBSERV else 0
  hasExceptions: -> @has('population_ids') and @get('population_ids').hasOwnProperty('DENEXCEP')
  exceptions: -> if @isPopulated() and @has('result') then @get('result').DENEXCEP else 0
  hasExclusions: -> @has('population_ids') and @get('population_ids').hasOwnProperty('DENEX')
  exclusions: -> if @isPopulated() and @has('result') then @get('result').DENEX else 0
  hasOutliers: -> !@isContinuous() and @has('antinumerator')
  outliers: -> if @isPopulated() and @has('result') then @get('result').antinumerator else 0
  performanceDenominator: -> @denominator() - @exceptions() - @exclusions()
  performanceRate: -> Math.round(100 * @numerator() / Math.max(1, @performanceDenominator()))
  # hack so that creating a query acts just like checking an existing query
  fetch: -> if @isNew() then @save() else super(arguments...)
  result: -> _(@get('result')).extend performanceDenominator: @performanceDenominator()

