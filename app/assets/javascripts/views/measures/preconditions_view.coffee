class Thorax.Views.PreconditionView extends Thorax.View
  template: JST['measures/preconditions']
  context: -> _(super).extend dataCriteria: @model.reference()
  isFirstItem: -> @model is @model.collection?.first()
  conjunction: -> @model.collection?.conjunction()
  isOuterLevel: -> !@model.collection?.parent.collection?


class Thorax.Views.DataCriteriaView extends Thorax.View
  template: JST['measures/data_criteria']
  context: ->
    _(super).extend temporalReference: @model.get('temporal_references')?.first(), valueView: @_valueViewFor(@model.get('value'))
  childContext: (child) ->
    _(child.attributes).extend valueView: @_valueViewFor(child.get('value'))
  fieldValueContext: (child, i) ->
    _(@childContext(child)).extend isFirst: i is 0, title: Config.fieldValues[child.id].title
  icon: ->
    iconMap =
      medications:      'medkit'
      conditions:       'stethoscope'
      encounters:       'user-md'
      physical_exams:   'user-md'
      characteristic:   'user'
      procedures:       'scissors'
      laboratory_tests: 'flask'
      interventions:    'comments'
    iconMap[@model.get('type')] || 'question' # use question in case we're missing an icon

  # private, intended only for local use
  _valueViewFor: (value) ->
    if value instanceof Thorax.Models.Value then 'ValueView'
    else if value instanceof Thorax.Models.Range then 'RangeView'



class Thorax.Views.TemporalReferenceView extends Thorax.View
  template: JST['measures/temporal_reference']
  dataCriteriaTemplate: -> @parent.template
  referencesDataCriteria: -> @model.reference() instanceof Thorax.Models.DataCriteria
  tagName: -> if @referencesDataCriteria() then 'div' else 'span'

  context: ->
    valueView =
      if @model.has('range')
        range = @model.get('range')
        if range instanceof Thorax.Models.Value then 'ValueView'
        else if range instanceof Thorax.Models.Range then 'RangeView'
    if @referencesDataCriteria()
      _(super).extend data_criteria: @model.reference(), valueView: valueView
    else
      # FIXME don't store this knowledge in both view and model
      _(super).extend reference: 'the Measurement Period', valueView: valueView

  period: ->
    typeMap =
      SBS:        'Starts Before the Start of'
      SAS:        'Starts After the Start of'
      SBE:        'Starts Before or During'
      SAE:        'Starts After the End of'
      SDU:        'Starts During'
      SCW:        'Starts Concurrent with'
      DURING:     'During'
      CONCURRENT: 'Concurrent with'
      EBS:        'Ends Before the Start of'
      EAS:        'Ends During or After'
      EBE:        'Ends Before or During'
      EAE:        'Ends After the End of'
      EDU:        'Ends During'
      ECW:        'Ends Concurrent with'
    typeMap[@model.get('type')] || @model.get('type')


class Thorax.Views.ChildCriteriaView extends Thorax.Views.DataCriteriaView
  template: JST['measures/child_criteria']
  context: -> _.extend {}, @model.toJSON(), {temporalReference: @model.get('temporal_references')?.first()}
  isFirstItem: -> @model is @model.collection.first()
  conjunction: ->
    conjunctionMap =
      UNION:    'or'
      XPRODUCT: 'and'
    conjunctionMap[@model.collection.parent.get('derivation_operator')]
  negation: -> @model.collection.parent.get('negation')


class Thorax.Views.TemporalReferenceDataCriteriaView extends Thorax.Views.DataCriteriaView
  template: JST['measures/temporal_reference_data_criteria']
  context: -> Thorax.View::context.call this


class Thorax.Views.RangeView extends Thorax.View
  tagName: 'span'
  template: JST['measures/range']
  initialize: ->
    @isAnyNonNull = @model.get('type') == 'ANYNonNull'
    @isLowAndHigh = @model.has('high') and @model.has('low')

class Thorax.Views.ValueView extends Thorax.View
  tagName: 'span'
  template: JST['measures/value']
  units:
    a:    'year'
    mo:   'month'
    wk:   'week'
    d:    'day'
    h:    'hour'
    min:  'minute'
    s:    'second'
  initialize: ->
    @operator ?= ''
    @operator += '=' if @model.get('inclusive?')
    @isCoded = @model.get('type') == 'CD'
    @isAnyNonNull = @model.get('type') == 'ANYNonNull'
  context: ->
    if @model.has('unit') and @units.hasOwnProperty(@model.get('unit'))
      unit = @units[@model.get('unit')]
      unit += 's' if @model.get('value') > 1
    else
      unit = @model.get('unit')
    _(super).extend unit: unit
