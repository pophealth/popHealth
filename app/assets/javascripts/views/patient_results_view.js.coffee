class Thorax.Views.PatientResultsView extends Thorax.View
  template: JST['patient_results/index']
  fetchTriggerPoint: 500 # fetch data when we're 500 pixels away from the bottom
  patientContext: (patient) ->
    _(patient.toJSON()).extend
      formatted_birthdate: moment(patient.get('birthdate')).format('MM/DD/YYYY') if patient.get('birthdate')
      age: moment(patient.get('birthdate')).fromNow().split(' ')[0] if patient.get('birthdate')

  events:
    'change:load-state': (state) -> @isFetching = false if state is 'end'
    rendered: ->
      $(document).on 'scroll', @scrollHandler
    destroyed: ->
      $(document).off 'scroll', @scrollHandler

  initialize: ->
    @isFetching = false
    @scrollHandler = =>
      distanceToBottom = $(document).height() - $(window).scrollTop() - $(window).height()
      if !@isFetching and @query.get('patient_results')?.length and @fetchTriggerPoint > distanceToBottom
        @isFetching = true
        @query.get('patient_results').fetchNextPage()
    @filterPopulation = 'DENOM'
    @query.on 'change', =>
      @setCollection(@query.get('patient_results'), render: true)
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
