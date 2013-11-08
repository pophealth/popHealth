class Thorax.Views.PatientResultsView extends Thorax.View
  template: JST['patient_results/index']

  query: -> @query
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
  events: { 
    'click .population': (event) ->
      @parent.changePopulation event.currentTarget.id
  }

    
