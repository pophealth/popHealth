class Thorax.Views.ResultsView extends Thorax.View
  template: JST['dashboard/results']
  events:
    model:
      change: ->
        unless @model.isLoading()
          clearInterval(@timeout) if @timeout?
          d3.select(@el).select('.pop-chart').datum(@model.get('result')).call(@popChart)
    rendered: ->
      @$('.dial').knob()
      d3.select(@el).select('.pop-chart').datum(@model.get('result')).call(@popChart) if @model.isPopulated()
    destroyed: ->
      clearInterval(@timeout) if @timeout?

  performanceRate: -> @model.performanceRate()
  numerator: -> @model.numerator()
  denominator: -> @model.denominator()
  performanceDenominator: -> @model.performanceDenominator()
  initialize: ->
    @popChart = PopHealth.viz.populationChart().width(125).height(50).numerSpacing(2).maximumValue(PopHealth.patientCount)
    unless @model.isPopulated()
      @timeout = setInterval =>
        @model.fetch()
      , 3000



class Thorax.Views.DashboardSubmeasureView extends Thorax.View
  events:
    rendered: ->
      query = @model.get('query')
      unless query.isPopulated()
        @$el.fadeTo 'fast', 0.5
        @listenTo query, 'change:status', =>
          if query.isPopulated()
            @$el.fadeTo 'fast', 1
            @stopListening query, 'change:status'



class Thorax.Views.Dashboard extends Thorax.View
  template: JST['dashboard/index']
  events:
    'change :checkbox.all':         'toggleCategory'
    'change :checkbox.individual':  'toggleMeasure'

  initialize: ->
    @selectedCategories = PopHealth.currentUser.selectedCategories(@collection)

  categoryFilterContext: (category) ->
    selectedCategory = @selectedCategories.findWhere(category: category.get('category'))
    allSelected = selectedCategory?.get('measures').length == category.get('measures').length
    _(category.toJSON()).extend selected: allSelected
  measureFilterContext: (measure) ->
    isSelected = @selectedCategories.any (cat) ->
      cat.get('measures').any (selectedMeasure) -> measure is selectedMeasure
    _(measure.toJSON()).extend selected: isSelected

  toggleMeasure: (e) ->
    # update 'all' checkbox to be checked if all measures are checked
    $cb = $(e.target)
    $all = $cb.closest('.panel-body').find(':checkbox.all')
    $all.prop 'checked', $cb.closest('.panel-body').find(':checkbox.individual').not(':checked').length is 0
    # show/hide measure
    measure = $(e.target).model()
    if $(e.target).is(':checked')
      @selectedCategories.selectMeasure measure
    else
      @selectedCategories.removeMeasure measure

  toggleCategory: (e) ->
    # change DOM
    $cb = $(e.target)
    $cb.closest('.panel-body').find(':checkbox.individual').prop 'checked', $cb.is(':checked')
    # change models
    category = $cb.model()
    if $cb.is(':checked')
      @selectedCategories.selectCategory category
    else
      @selectedCategories.removeCategory category
