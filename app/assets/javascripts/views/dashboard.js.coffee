$.extend $.expr[":"],
  containsi: (elem, i, match, array) ->
    (elem.textContent or elem.innerText or "").toLowerCase().indexOf((match[3] or "").toLowerCase()) >= 0

class Thorax.Views.ResultsView extends Thorax.View
  template: JST['dashboard/results']
  options:
    fetch: false
  events:
    model:
      change: ->
        loadingDiv = "." + String(@model.get('measure_id')) + "-loading-measure"
        if (PopHealth.currentUser.showAggregateResult() and @model.aggregateResult()) or (!PopHealth.currentUser.showAggregateResult() and @model.isPopulated())
          $(loadingDiv).html("")
          clearInterval(@timeout) if @timeout?
          d3.select(@el).select('.pop-chart').datum(_(lower_is_better: @lower_is_better).extend @model.result()).call(@popChart)
        else
          $(loadingDiv).html("<h2>LOADING...</h2>")
          @authorize()
          if @response == 'false'
            clearInterval(@timeout)
            @view.setView ''
          else
            @timeout ?= setInterval =>
              @model.fetch()
            , 3000
      rescale: ->
        if @model.isPopulated()
          if PopHealth.currentUser.populationChartScaledToIPP() then @popChart.maximumValue(@model.result().IPP) else @popChart.maximumValue(PopHealth.patientCount)
          @popChart.update(_(lower_is_better: @lower_is_better).extend @model.result())
    rendered: ->
      unless PopHealth.currentUser.showAggregateResult() then @$('.aggregate-result').hide()
      @$(".icon-popover").popover()
      @$('.dial').knob()
      if @model.isPopulated()
        if PopHealth.currentUser.populationChartScaledToIPP() then @popChart.maximumValue(@model.result().IPP) else @popChart.maximumValue(PopHealth.patientCount)
        d3.select(@el).select('.pop-chart').datum(_(lower_is_better: @lower_is_better).extend @model.result()).call(@popChart)
        @$('rect').popover()
    destroyed: ->
      clearInterval(@timeout) if @timeout?

  authorize: ->
    @response = $.ajax({ 
      async: false,
      url: "home/check_authorization/", 
      data: {"id": @provider_id}
    }).responseText    
    
  shouldDisplayPercentageVisual: -> !@model.isContinuous() and PopHealth.currentUser.shouldDisplayPercentageVisual()
  context: (attrs) ->
    _(super).extend
      unit: if @model.isContinuous() and @model.parent.get('cms_id') isnt 'CMS179v2' then 'min' else '%'
      resultValue: if @model.isContinuous() then @model.observation() else @model.performanceRate()
      fractionTop: if @model.isContinuous() then @model.measurePopulation() else @model.numerator()
      fractionBottom: if @model.isContinuous() then @model.ipp() else @model.performanceDenominator()
      aggregateResult: @model.aggregateResult()
  initialize: ->
    @popChart = PopHealth.viz.populationChart().width(125).height(25).maximumValue(PopHealth.patientCount)
    @model.set('providers', [@provider_id]) if @provider_id?


class Thorax.Views.DashboardSubmeasureView extends Thorax.View
  template: JST['dashboard/submeasure']
  className: 'measure'
  options:
    fetch: false
  events:
    rendered: ->
      @$('.icon-popover').popover()
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
    'click .aggregate-btn': 'toggleAggregateShow'
    'click .btn-checkbox.all':           'toggleCategory'
    'click .btn-checkbox.individual':    'toggleMeasure'
    'keyup .category-measure-search': 'search'
    'click .clear-search':            'clearSearch'
    'change .rescale': (event) ->
      @$('.rescale').parent().toggleClass("btn-primary")
      PopHealth.currentUser.setPopulationChartScale(event.target.value=="true")
      this.selectedCategories.each (category) ->
          category.get("measures").each (measure) ->
            measure.get("submeasures").each (submeasure) ->
              submeasure.attributes.query.trigger("rescale")
    rendered: ->
      toggleChevron = (e) -> $(e.target).parent('.panel').find('.panel-chevron').toggleClass 'glyphicon-chevron-right glyphicon-chevron-down'
      @$('.collapse').on 'hidden.bs.collapse', toggleChevron
      @$('.collapse').on 'show.bs.collapse', toggleChevron
  initialize: ->
    @selectedCategories = PopHealth.currentUser.selectedCategories(@collection)
    @populationChartScaledToIPP = PopHealth.currentUser.populationChartScaledToIPP()
    @currentUser = PopHealth.currentUser.get 'username'
    @showAggregateResult = PopHealth.currentUser.showAggregateResult()
    @opml = PopHealth.OPML

  toggleAggregateShow: (e) ->    
    shown = PopHealth.currentUser.showAggregateResult()
    PopHealth.currentUser.setShowAggregateResult(!shown)
    if !shown 
      if confirm "Please wait for the aggregate measure to calculate. The result will appear when the calculation is completed."
        location.reload()
        @$('.aggregate-result').toggle(400)   
        @$('.aggregate-btn').toggleClass('active')
    else
      @$('.aggregate-result').toggle(400)   
      @$('.aggregate-btn').toggleClass('active')

  effective_date: ->
    PopHealth.currentUser.get 'effective_date'

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
    measures = category.get('measures')
    {'true': cvMeasureData, 'false': proportionBasedMeasureData} = measures.groupBy 'continuous_variable'
    cvMeasures = new Thorax.Collections.Measures(cvMeasureData, parent: category)
    proportionBasedMeasures = new Thorax.Collections.Measures(proportionBasedMeasureData, parent: category)
    for action in ['add', 'remove']
      do (action) ->
        measures.on action, (measure) ->
          if measure.get('continuous_variable')
            cvMeasures[action](measure)
          else
            proportionBasedMeasures[action](measure)
    measures.on 'reset', (measures) ->
      {'true': cvMeasureData, 'false': proportionBasedMeasureData} = measures.groupBy 'continuous_variable'
      cvMeasures.reset(cvMeasureData)
      proportionBasedMeasures.reset(proportionBasedMeasureData)
    _(category.toJSON()).extend
      cvMeasures:               cvMeasures
      proportionBasedMeasures:  proportionBasedMeasures
      measureContext: @measureContext

  measureContext: (measure) ->
    submeasureView = new Thorax.CollectionView
      collection: measure.get 'submeasures'
      itemView: (item) => new Thorax.Views.DashboardSubmeasureView model: item.model, provider_id: @provider_id
    _(measure.toJSON()).extend submeasureView: submeasureView

  filterEHMeasures: (flag) ->
    @filterEH = flag
    @selectedCategories.each (category) =>
      category.get('measures').each (measure) =>
        unless @filterEH and measure.get('type') is 'eh'
          measure.get('submeasures').each (submeasure) ->
            submeasure.get('query').fetch()
    @render()

  measureFilter: (measure) ->
    !(@filterEH and measure.get('type') == 'eh')

  categoryFilter: (category) ->
    if @filterEH
      types = category.get('measures').map (measure) => measure.get('type')
      'ep' in types
    else
      true

  search: (e) ->
    $sb = $(e.target)
    query = $.trim($sb.val())
    $('#filters .panel, #filters .btn-checkbox').show() # show everything
    if query.length > 0
      # only show categories with a matching header, or buttons with matching text
      $("#filters .panel:not(:containsi(#{query})), #filters .panel-body:containsi(#{query}) .btn-checkbox:not(:containsi(#{query}))").hide()
      # collapse panels that don't match, show panels that do
      $("#filters .panel:containsi(#{query}) .panel-collapse").collapse('show')
      $("#filters .panel:not(:containsi(#{query})) .panel-collapse").collapse('hide')
    else
      $('#filters .panel-collapse').collapse('hide') # collapse all

  clearSearch: (e) ->
    $sb = $(e.target).parent().prev('.category-measure-search')
    $sb.val('').trigger('keyup')

  toggleMeasure: (e) ->
    # update 'all' checkbox to be checked if all measures are checked
    e.preventDefault()
    $cb = $(e.target); $cbs = $cb.closest('.panel-body').find('.btn-checkbox.individual')
    $cb.toggleClass 'active'
    $all = $cb.closest('.panel-body').find('.btn-checkbox.all')
    $all.toggleClass 'active', $cbs.not('.active').length is 0
    # show/hide measure
    measure = $cb.model()
    if $cb.is('.active')
      @selectedCategories.selectMeasure measure
    else
      @selectedCategories.removeMeasure measure
    $cb.closest('.panel-collapse').prev('.panel-heading').find('.measure-count').text $cbs.filter('.active').length

  toggleCategory: (e) ->
    # change DOM
    e.preventDefault()
    $cb = $(e.target)
    $cb.toggleClass 'active'
    $cb.closest('.panel-body').find('.btn-checkbox.individual').toggleClass 'active', $cb.is('.active')
    $measureCount = $cb.closest('.panel-collapse').prev('.panel-heading').find('.measure-count')
    # change models
    category = $cb.model()
    if $cb.is('.active')
      @selectedCategories.selectCategory category
      $measureCount.text $cb.model().get('measures').length
    else
      @selectedCategories.removeCategory category
      $measureCount.text 0
