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
          d3.select(@el).select('.pop-chart').datum(_(lower_is_better: @lower_is_better).extend @model.result()).call(@popChart)
      rescale: ->
        if @model.isPopulated()
          if PopHealth.currentUser.populationChartScaledToIPP() then @popChart.maximumValue(@model.result().IPP) else @popChart.maximumValue(PopHealth.patientCount)
          @popChart.update(_(lower_is_better: @lower_is_better).extend @model.result())
    rendered: ->
      @$(".icon-popover").popover()
      @$('.dial').knob()
      if @model.isPopulated()
        if PopHealth.currentUser.populationChartScaledToIPP() then @popChart.maximumValue(@model.result().IPP) else @popChart.maximumValue(PopHealth.patientCount)
        d3.select(@el).select('.pop-chart').datum(_(lower_is_better: @lower_is_better).extend @model.result()).call(@popChart)
        @$('rect').popover()
    destroyed: ->
      clearInterval(@timeout) if @timeout?
  shouldDisplayPercentageVisual: -> !@model.isContinuous() and PopHealth.currentUser.shouldDisplayPercentageVisual()
  context: (attrs) ->
    _(super).extend
      unit: if @model.isContinuous() and @model.parent.get('cms_id') isnt 'CMS179v2' then 'min' else '%'
      resultValue: if @model.isContinuous() then @model.observation() else @model.performanceRate()
      fractionTop: if @model.isContinuous() then @model.measurePopulation() else @model.numerator()
      fractionBottom: if @model.isContinuous() then @model.ipp() else @model.performanceDenominator()
  initialize: ->
    @popChart = PopHealth.viz.populationChart().width(125).height(25).maximumValue(PopHealth.patientCount)
    @model.set('providers', [@provider_id]) if @provider_id?
    unless @model.isPopulated()
      @timeout = setInterval =>
        @model.fetch()
      , 3000



class Thorax.Views.DashboardSubmeasureView extends Thorax.View
  template: JST['dashboard/submeasure']
  className: 'measure'
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
  context: ->
    matches = @model.get('cms_id').match(/CMS(\d+)v(\d+)/)
    _(super).extend
      cms_number: matches?[1]
      cms_version: matches?[2]


class Thorax.Views.Dashboard extends Thorax.View
  template: JST['dashboard/index']
  events:
    'change :checkbox.all':           'toggleCategory'
    'change :checkbox.individual':    'toggleMeasure'
    'keyup .category-measure-search': 'search'
    'click .clear-search':            'clearSearch'
    'change .rescale': (event) ->
      @$('.rescale').parent().toggleClass("btn-primary")
      PopHealth.currentUser.setPopulationChartScale(event.target.value=="true")
      this.selectedCategories.each (category) ->
          category.get("measures").each (measure) ->
            measure.get("submeasures").each (submeasure) ->
              submeasure.attributes.query.trigger("rescale")
  initialize: ->
    @selectedCategories = PopHealth.currentUser.selectedCategories(@collection)
    @populationChartScaledToIPP = PopHealth.currentUser.populationChartScaledToIPP()

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
  selectedCategoryContext: (category) ->
    # split up measures into whether or not they are continuous variable or not
    {'true': cvMeasures, 'false': proportionBasedMeasures} = category.get('measures').groupBy 'continuous_variable'
    _(category.toJSON()).extend
      cvMeasures:               new Thorax.Collections.Measures(cvMeasures, parent: category)
      proportionBasedMeasures:  new Thorax.Collections.Measures(proportionBasedMeasures, parent: category)

  search: (e) ->
    $sb = $(e.target)
    query = $.trim($sb.val())
    if query.length > 0
      $('#filters .panel').show() # show all category titles
      $('#filters .panel-body').show() # show all category measure containers
      $('#filters .panel-collapse').collapse('show') # uncollapse all

      $('#filters .panel-body .checkbox').hide() # hide all measures
      $("#filters .panel-body .checkbox:containsi(#{query})").show() # show matching measures
      $("#filters .panel:containsi(#{query})").next('.panel-collapse').find('.checkbox').show() # show matching categories

      $('#filters .panel-body').not(':has(.checkbox:visible)').parent().prev('.panel').hide() # hide empty category titles
      $('#filters .panel-body').not(':has(.checkbox:visible)').hide() # hide empty category measure containers
    else
      $('#filters .panel').show() # show all category titles
      $('#filters .panel-body').show() # show all category measure containers
      $('#filters .panel-body .checkbox').show() # show all measures
      $('#filters .panel-collapse').collapse('hide') # collapse all

  clearSearch: (e) ->
    $sb = $(e.target).parent().prev('.category-measure-search')
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
