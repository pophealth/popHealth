$.extend $.expr[":"],
  containsi: (elem, i, match, array) ->
    (elem.textContent or elem.innerText or "").toLowerCase().indexOf((match[3] or "").toLowerCase()) >= 0

class Thorax.Views.ResultsView extends Thorax.View
  template: JST['dashboard/results']
  events:
    model:
      change: ->
        unless @model.isLoading()
          clearInterval(@timeout) if @timeout?
          d3.select(@el).select('.pop-chart').datum(@model.result()).call(@popChart)
    rendered: ->
      @$('.dial').knob()
      if @model.isPopulated()
        d3.select(@el).select('.pop-chart').datum(@model.result()).call(@popChart)
        @$('rect').popover()
    destroyed: ->
      clearInterval(@timeout) if @timeout?
  shouldDisplayPercentageVisual: -> PopHealth.currentUser.shouldDisplayPercentageVisual()
  context: (attrs) ->
    _(super).extend
      performanceRate: @model.performanceRate()
      numerator: @model.numerator()
      denominator: @model.denominator()
      performanceDenominator: @model.performanceDenominator()
  initialize: ->
    @popChart = PopHealth.viz.populationChart().width(125).height(50).barHeight(18).maximumValue(PopHealth.patientCount)
    @model.set('providers', [@provider_id]) if @provider_id?
    unless @model.isPopulated()
      @timeout = setInterval =>
        @model.fetch()
      , 3000



class Thorax.Views.DashboardSubmeasureView extends Thorax.View
  options:
    fetch: false
  events:
    rendered: ->
      @$("[rel='popover']").popover()
      # TODO when we upgrade to Thorax 3, use `getQueryForProvider`
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
    'change :checkbox.all':                  'toggleCategory'
    'change :checkbox.individual':           'toggleMeasure'
    'keyup :input#category-measure-search': 'searchByTitle'
    'click span.clear-search':              'clearSearch'
  initialize: ->
    @selectedCategories = PopHealth.currentUser.selectedCategories(@collection)

  effective_date: ->
    Config.effectiveDate

  categoryFilterContext: (category) ->
    selectedCategory = @selectedCategories.findWhere(category: category.get('category'))
    measureCount = selectedCategory?.get('measures').length || 0
    allSelected = measureCount == category.get('measures').length
    _(category.toJSON()).extend selected: allSelected, measure_count: measureCount
  measureFilterContext: (measure) ->
    isSelected = @selectedCategories.any (cat) ->
      cat.get('measures').any (selectedMeasure) -> measure is selectedMeasure
    _(measure.toJSON()).extend selected: isSelected

  searchByTitle: (e) ->
    $sb = $(e.target)
    $q = $.trim($sb.val())
    if $q.length > 0
      $('#filters .panel').show() # show all category titles
      $('#filters .panel-body').show() # show all category measure containers
      $('#filters .panel-collapse').collapse('show') # uncollapse all

      $('#filters .panel-body .checkbox').hide() # hide all measures
      $('#filters .panel-body .checkbox:containsi(' + $q + ')').show() # show matching measures
      $('#filters .panel:containsi(' + $q + ')').next('.panel-collapse').find('.checkbox').show() # show matching categories

      $('#filters .panel-body').not(':has(.checkbox:visible)').parent().prev('.panel').hide() # hide empty category titles
      $('#filters .panel-body').not(':has(.checkbox:visible)').hide() # hide empty category measure containers
    else
      $('#filters .panel').show() # show all category titles
      $('#filters .panel-body').show() # show all category measure containers
      $('#filters .panel-body .checkbox').show() # show all measures
      $('#filters .panel-collapse').collapse('hide') # collapse all
  clearSearch: (e) ->
    $sb = $(e.target).prev('input#category-measure-search')
    $sb.val('').trigger('keyup')

  toggleMeasure: (e) ->
    # update 'all' checkbox to be checked if all measures are checked
    $cb = $(e.target); $cbs = $cb.closest('.panel-body').find(':checkbox.individual')
    $all = $cb.closest('.panel-body').find(':checkbox.all')
    $all.prop 'checked', $cbs.not(':checked').length is 0
    # show/hide measure
    measure = $(e.target).model()
    if $(e.target).is(':checked')
      @selectedCategories.selectMeasure measure
    else
      @selectedCategories.removeMeasure measure
    $cb.closest('.panel-collapse').prev('.panel').find('.measure-count').text $cbs.filter(':checked').length

  toggleCategory: (e) ->
    # change DOM
    $cb = $(e.target)
    $cb.closest('.panel-body').find(':checkbox.individual').prop 'checked', $cb.is(':checked')
    $measureCount = $cb.closest('.panel-collapse').prev('.panel').find('.measure-count')
    # change models
    category = $cb.model()
    if $cb.is(':checked')
      @selectedCategories.selectCategory category
      $measureCount.text $cb.model().get('measures').length
    else
      @selectedCategories.removeCategory category
      $measureCount.text 0
