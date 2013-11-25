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

class Submeasure extends Thorax.Model
  idAttribute: 'sub_id'
  url: -> "/api/measures/#{@get('id')}"
  initialize: ->
    # FIXME don't use hardcoded effective date
    query = new Thorax.Models.Query({measure_id: @get('id'), sub_id: @get('sub_id'), effective_date: Config.effectiveDate}, parent: this)
    @set 'query', query

  fetch: (options = {}) ->
    options.data = {sub_id: @get('sub_id')} unless options.data?
    super(options)

class SubCollection extends Thorax.Collection
  model: Submeasure
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
  ipp: -> if @isPopulated() and @has('result') then @get('result').IPP else 0
  numerator: -> if @isPopulated() and @has('result') then @get('result').NUMER else 0
  denominator: -> if @isPopulated() and @has('result') then @get('result').DENOM else 0
  exceptions: -> if @isPopulated() and @has('result') then @get('result').DENEXCEP else 0
  exclusions: -> if @isPopulated() and @has('result') then @get('result').DENEX else 0
  outliers: -> if @isPopulated() and @has('result') then @get('result').antinumerator else 0
  performanceDenominator: -> @denominator() - @exceptions() - @exclusions()
  performanceRate: -> Math.round(100 * @numerator() / Math.max(1, @performanceDenominator()))
  # hack so that creating a query acts just like checking an existing query
  fetch: -> if @isNew() then @save() else super(arguments...)

