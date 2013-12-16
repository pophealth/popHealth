class Thorax.Views.PatientResultsView extends Thorax.View
  template: JST['patient_results/index']
  patientContext: (patient) ->
    _(patient.toJSON()).extend
      first: PopHealth.Helpers.maskName(patient.get('first')) if patient.get('first')
      last: PopHealth.Helpers.maskName(patient.get('last')) if patient.get('last')
      formattedBirthdate: moment(patient.get('birthdate')).format(PopHealth.Helpers.maskDateFormat('MM/DD/YYYY')) if patient.get('birthdate')
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

  changePopulation: (population) ->
    @filterPopulation = population
    @updateFilter()

class Thorax.Views.QueryView extends Thorax.View
  template: JST['patient_results/query']
  ipp: -> @model.ipp()
  numerator: -> @model.numerator()
  denominator: -> @model.denominator()
  exceptions: -> @model.exceptions()
  exclusions: -> @model.exclusions()
  outliers: -> @model.outliers()
  initialize: (attrs) ->
    @setModel(attrs.model, {render: true})
    @parent = attrs.parent
  
  events:
    'click .population-btn': 'changeFilter' 

  changeFilter: (event) ->
    @parent.changePopulation event.currentTarget.id
    $('.population-btn.active').removeClass 'active'
    $(event.currentTarget).addClass 'active'