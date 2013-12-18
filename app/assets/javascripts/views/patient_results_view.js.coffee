class Thorax.Views.PatientResultsLayoutView extends Thorax.LayoutView
  initialize: ->
    @views = {}
  events:
    destroyed: ->
      view.release() for population, view of @views
  changeFilter: (population) ->
    if currentView = @getView()
      currentView.retain() # don't destroy child views until the layout view is destroyed
    @views[population] ||= new Thorax.Views.PatientResultsView(population: population, query: @query)
    @setView @views[population]


class Thorax.Views.PatientResultsView extends Thorax.View
  tagName: 'table'
  className: 'table'
  template: JST['patient_results/index']
  fetchTriggerPoint: 500 # fetch data when we're 500 pixels away from the bottom
  patientContext: (patient) ->
    _(patient.toJSON()).extend
      first: PopHealth.Helpers.maskName(patient.get('first')) if patient.get('first')
      last: PopHealth.Helpers.maskName(patient.get('last')) if patient.get('last')
      formatted_birthdate: moment(patient.get('birthdate')).format(PopHealth.Helpers.maskDateFormat('MM/DD/YYYY')) if patient.get('birthdate')
      age: moment(patient.get('birthdate')).fromNow().split(' ')[0] if patient.get('birthdate')

  events:
    rendered: ->
      $(document).on 'scroll', @scrollHandler
    destroyed: ->
      $(document).off 'scroll', @scrollHandler
    collection:
      sync: -> @isFetching = false

  initialize: ->
    @isFetching = false
    @scrollHandler = =>
      distanceToBottom = $(document).height() - $(window).scrollTop() - $(window).height()
      if !@isFetching and @collection?.length and @fetchTriggerPoint > distanceToBottom
        @isFetching = true
        @collection.fetchNextPage()

    setCollection = =>
      @setCollection new Thorax.Collections.PatientResults([], parent: @query, population: @population), render: true
      @collection.fetch()
    @query.on 'change', setCollection
    if @query.isNew() then @query.save() else setCollection()

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
  hasOutliers: -> @model.hasOutliers()
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
