class QueryHeadingView extends Thorax.View
  template: JST['patient_results/query_heading']
  className: 'clearfix'
  events:
    rendered: ->
      @$('.dial').knob()
      if @model.isPopulated()
        @popChart.maximumValue(@model.result().IPP)
        d3.select(@el).select('.pop-chart').datum(@model.result()).call(@popChart)
  initialize: ->
    @popChart = PopHealth.viz.populationChart().width(125).height(25).maximumValue(PopHealth.patientCount)
  shouldDisplayPercentageVisual: -> !@model.isContinuous() and PopHealth.currentUser.shouldDisplayPercentageVisual()
  resultValue: -> if @model.isContinuous() then @model.observation() else @model.performanceRate()
  fractionTop: -> if @model.isContinuous() then @model.measurePopulation() else PopHealth.Helpers.formatNumber(@model.numerator())
  fractionBottom: -> if @model.isContinuous() then @model.ipp() else PopHealth.Helpers.formatNumber(@model.performanceDenominator())
  episodeOfCare: -> @model.parent.get('episode_of_care')
  unit: -> if @model.isContinuous() and @model.parent.get('cms_id') isnt 'CMS179v2' then 'min' else '%'


class QueryButtonsView extends Thorax.View
  template: JST['patient_results/query_buttons']
  events:
    'click .population-btn': 'changeFilter'
    model:
      change: ->
        if @model.isPopulated()
          clearInterval(@timeout) if @timeout?
        else
          @timeout ?= setInterval =>
            @model.fetch()
          , 3000
  initialize: ->
    @currentPopulation ?= 'IPP'
  ipp: -> @model.ipp()
  numerator: -> PopHealth.Helpers.formatNumber(@model.numerator())
  denominator: -> PopHealth.Helpers.formatNumber(@model.denominator()-@model.exclusions())
  hasExceptions: -> @model.hasExceptions()
  exceptions: -> PopHealth.Helpers.formatNumber(@model.exceptions())
  hasExclusions: -> @model.hasExclusions()
  exclusions: -> PopHealth.Helpers.formatNumber(@model.exclusions())
  hasOutliers: -> @model.hasOutliers()
  outliers: -> PopHealth.Helpers.formatNumber(@model.outliers())
  performanceRate: -> @model.performanceRate()
  performanceDenominator: -> PopHealth.Helpers.formatNumber(@model.performanceDenominator())

  ippIsActive: -> @isActive and @currentPopulation is 'IPP'
  numeratorIsActive: -> @isActive and @currentPopulation is 'NUMER'
  denominatorIsActive: -> @isActive and @currentPopulation is 'DENOM'
  exclusionsAreActive: -> @isActive and @currentPopulation is 'DENEX'
  exceptionsAreActive: -> @isActive and @currentPopulation is 'DENEXCEP'
  antinumeratorIsActive: -> @isActive and @currentPopulation is 'antinumerator'

  changeFilter: (event) ->
    @currentPopulation = $(event.currentTarget).data 'population'
    # get measureView
    measureView = @parent
    until measureView.changeFilter
      measureView = measureView.parent
    measureView.sidebarView.currentPopulation = @currentPopulation
    measureView.changeFilter @model.parent, @currentPopulation
    # FIXME bootstrap can manage this for us /->
    @$('.population-btn.active').removeClass 'active'
    $(event.currentTarget).addClass 'active'
  setActive: (isActive) ->
    @isActive = isActive
    @$('.population-btn.active').removeClass 'active' unless isActive


class Thorax.Views.QueryView extends Thorax.View
  template: JST['patient_results/query']
  initialize: ->
    @currentPopulation = 'IPP'
    @model.set 'providers', [@providerId] if @providerId
    @queryHeadingView = new QueryHeadingView model: @model
    @queryButtonsView = new QueryButtonsView model: @model, isActive: true


class Thorax.Views.MultiQueryView extends Thorax.View
  template: JST['patient_results/query']
  initialize: ->
    @currentPopulation = 'IPP'
    @queryHeadingView = new QueryHeadingView model: @model.getQueryForProvider(@providerId)
    @queryButtonsView = new Thorax.Views.QueryCollectionView currentSubmeasure: @model, collection: @submeasures, providerId: @providerId
  changeSubmeasure: (submeasure) ->
    @queryHeadingView.setModel submeasure.getQueryForProvider(@providerId)
    @queryButtonsView.setActiveSubmeasure submeasure

class Thorax.Views.QueryCollectionView extends Thorax.CollectionView
  id: 'submeasures'
  className: 'panel-group'
  itemTemplate: JST['patient_results/query_collection']
  events:
    'rendered:item': (qcv, collection, model, $el) ->
      toggleChevron = (e) -> $(e.target).parent('.panel').find('.panel-chevron').toggleClass 'glyphicon-chevron-right glyphicon-chevron-down'
      $el.find('.collapse').on 'hidden.bs.collapse', toggleChevron
      $el.find('.collapse').on 'show.bs.collapse', toggleChevron
  itemContext: (submeasure) ->
    isActive = submeasure is @currentSubmeasure
    queryView = new QueryButtonsView model: submeasure.getQueryForProvider(@providerId), isActive: isActive, providerId: @providerId, currentPopulation: @parent.currentPopulation
    _(super).extend active: isActive, queryView: queryView # @views[submeasure.get('short_subtitle')]

  setActiveSubmeasure: (submeasure) ->
    @currentSubmeasure = submeasure
    buttonViews = _(@children).values()
    _(buttonViews).each (view) -> view.setActive view.model.parent is @currentSubmeasure
