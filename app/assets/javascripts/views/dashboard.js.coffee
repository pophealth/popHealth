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
    @popChart = PopHealth.viz.populationChart().width(125).height(50).barHeight(20).maximumValue(PopHealth.patientCount)
    unless @model.isPopulated()
      @timeout = setInterval =>
        @model.fetch()
      , 3000

class Thorax.Views.DashboardSubmeasureView extends Thorax.View
  events:
    rendered: ->
      @$("[rel='popover']").popover()
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
    selectedIds = _(PopHealth.currentUser.selected_measures).map (m) -> m.id
    @selectedCategories = new Thorax.Collections.Categories
    @collection.each (cat) =>
      selectedMeasures = cat.get('measures').select (m) => _(selectedIds).contains m.id
      if selectedMeasures.length
        selectedCategory = cat.clone()
        selectedCategory.set 'measures', new Thorax.Collections.Measures selectedMeasures, parent: selectedCategory
        @selectedCategories.add selectedCategory

  toggleMeasure: (e) ->
    # update 'all' checkbox to be checked if all measures are checked
    $cb = $(e.target)
    $all = $cb.closest('.panel-body').find(':checkbox.all')
    $all.prop 'checked', $cb.closest('.panel-body').find(':checkbox.individual').not(':checked').length is 0
    # show/hide measure
    measure = $(e.target).model()
    category = measure.collection.parent
    selectedCategory = @selectedCategories.findWhere category: category.get('category')
    if $(e.target).is(':checked')
      unless selectedCategory?
        selectedCategory = new Thorax.Models.Category {category: category.get('category'), measures: []}, parse: true
        @selectedCategories.add selectedCategory
      selectedCategory.get('measures').add measure
    else
      measures = selectedCategory.get('measures')
      measures.remove measures.get(measure)
      @selectedCategories.remove(selectedCategory) if measures.isEmpty()


  toggleCategory: (e) ->
    # change DOM
    $cb = $(e.target)
    $cb.closest('.panel-body').find(':checkbox.individual').prop 'checked', $cb.is(':checked')
    # change models
    category = $cb.model()
    selectedCategory = @selectedCategories.findWhere category: category.get('category')
    if $cb.is(':checked')
      unless selectedCategory?
        selectedCategory = new Thorax.Models.Category {category: category.get('category'), measures: []}, parse: true
        @selectedCategories.add selectedCategory
      selectedCategory.get('measures').reset category.get('measures').models
    else
      @selectedCategories.remove selectedCategory
