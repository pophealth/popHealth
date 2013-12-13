class Thorax.Views.PatientResultsView extends Thorax.View
  tagName: 'table'
  className: 'table'
  template: JST['patient_results/index']
  patientContext: (patient) ->
    _(patient.toJSON()).extend
      formatted_birthdate: moment(patient.get('birthdate')).format('MM/DD/YYYY') if patient.get('birthdate')
      age: moment(patient.get('birthdate')).fromNow().split(' ')[0] if patient.get('birthdate')

  initialize: ->
    @filterPopulation = 'DENOM'
    @query.on 'change', =>
      @setCollection(@query.get('patient_results'), {render: true})
      @query.get('patient_results').fetch()
    if @query.isNew()
      @query.fetch()
    else
      @setCollection(@query.get('patient_results'))
      @query.get('patient_results').fetch()

  itemFilter: (model, index) ->
    model.get(@filterPopulation) == 1

  changeFilter: (population) ->
    @filterPopulation = population
    @updateFilter()

# TODO consider inheriting from/joining with ResultsView
class Thorax.Views.QueryView extends Thorax.View
  template: JST['patient_results/query']
  events:
    'click .population-btn': 'changeFilter'
    rendered: ->
      @$('.dial').knob()
      d3.select(@el).select('.pop-chart').datum(@model.result()).call(@popChart) if @model.isPopulated()

  ipp: -> @model.ipp()
  numerator: -> @model.numerator()
  denominator: -> @model.denominator()
  hasExceptions: -> @model.hasExceptions()
  exceptions: -> @model.exceptions()
  hasExclusions: -> @model.hasExclusions()
  exclusions: -> @model.exclusions()
  outliers: -> @model.outliers()
  performanceRate: -> @model.performanceRate()
  performanceDenominator: -> @model.performanceDenominator()
  initialize: ->
    @currentPopulation = 'IPP'
    @popChart = PopHealth.viz.populationChart().width(125).height(50).barHeight(20).maximumValue(PopHealth.patientCount)

  changeFilter: (event) ->
    @currentPopulation = event.currentTarget.id
    @parent.getView().changeFilter @currentPopulation
    # FIXME bootstrap can manage this for us /->
    $('.population-btn.active').removeClass 'active'
    $(event.currentTarget).addClass 'active'
