class QueryHeadingView extends Thorax.View
  template: JST['patient_results/query_heading']
  className: 'clearfix'
  events:
    rendered: ->
      @$('.dial').knob()
      d3.select(@el).select('.pop-chart').datum(@model.result()).call(@popChart) if @model.isPopulated()
  initialize: ->
    @popChart = PopHealth.viz.populationChart().width(125).height(40).maximumValue(PopHealth.patientCount)
  shouldDisplayPercentageVisual: -> !@model.isContinuous() and PopHealth.currentUser.shouldDisplayPercentageVisual()
  resultValue: -> if @model.isContinuous() then @model.observation() else @model.performanceRate()
  fractionTop: -> if @model.isContinuous() then @model.measurePopulation() else @model.numerator()
  fractionBottom: -> if @model.isContinuous() then @model.ipp() else @model.performanceDenominator()
  episodeOfCare: -> @model.parent.get('episode_of_care')
  unit: -> if @model.isContinuous() and @model.parent.get('cms_id') isnt 'CMS179v2' then 'min' else '%'


class QueryButtonsView extends Thorax.View
  template: JST['patient_results/query_buttons']
  events:
    'click .population-btn': 'changeFilter'
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

  changeFilter: (event) ->
    @currentPopulation = $(event.currentTarget).data 'population'
    # get measureView
    measureView = @parent
    until measureView.changeFilter
      measureView = measureView.parent
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


# ItemView might work if there was some way to pass information between parent/children...?
# class Thorax.Views.QueryPanelView extends Thorax.View
#   className: 'panel panel-default'
#   events:
#     rendered: ->
#       toggleChevron = (e) -> $(e.target).parent('.panel').find('.panel-chevron').toggleClass 'glyphicon-chevron-right glyphicon-chevron-down'
#       @$('.collapse').on 'hidden.bs.collapse', toggleChevron
#       @$('.collapse').on 'show.bs.collapse', toggleChevron
#   initialize: ->
#     # @parent doesn't exist, @providerId hasn't been passed down
#     console.log 'p', @parent
#     # @queryView = new Thorax.Views.QueryView model: @model.getQueryForProvider(@providerId), providerId: @providerId
#   context: ->
#     isActive = @model is @parent?.currentSubmeasure
#     _(super).extend active: isActive#, queryView: @queryView

class Thorax.Views.MultiQueryView extends Thorax.View
  template: JST['patient_results/query']
  initialize: ->
    @currentPopulation = 'IPP'
    @queryHeadingView = new QueryHeadingView model: @model.getQueryForProvider(@providerId)
    @queryButtonsView = new Thorax.Views.QueryCollectionView currentSubmeasure: @model, collection: @submeasures, providerId: @providerId
  changeSubmeasure: (submeasure) ->
    # @setModel submeasure
    @queryHeadingView.setModel submeasure.getQueryForProvider(@providerId)
    @queryButtonsView.setActiveSubmeasure submeasure

class Thorax.Views.QueryCollectionView extends Thorax.CollectionView
  id: 'submeasures'
  className: 'panel-group'
  itemTemplate: JST['patient_results/query_collection']
  # itemView: Thorax.Views.QueryPanelView
  events:
    # rendered: ->
    #   # only rendered collection view, not child views yet
    'rendered:item': (qcv, collection, model, $el) ->
      # console.log 'rendered:item'
      toggleChevron = (e) -> $(e.target).parent('.panel').find('.panel-chevron').toggleClass 'glyphicon-chevron-right glyphicon-chevron-down'
      $el.find('.collapse').on 'hidden.bs.collapse', toggleChevron
      $el.find('.collapse').on 'show.bs.collapse', toggleChevron
    # 'rendered:collection': ->
    #   # this happens after all views have been rendered, but they might be replaced if their models update
    #   toggleChevron = (e) -> $(e.target).parent('.panel').find('.panel-chevron').toggleClass 'glyphicon-chevron-right glyphicon-chevron-down'
    #   @$('.collapse').each ->
    #     console.log 'h', this
    #     $(this).on 'hidden.bs.collapse', toggleChevron
    #   @$('.collapse').each ->
    #     console.log 's', this
    #     $(this).on 'show.bs.collapse', toggleChevron
  # initialize: ->
  #   # it doesn't make sense to initialize views now because they'll be removed if any child views are updated
  #   @views = {}
  #   @collection.each (submeasure) =>
  #     @views[submeasure.get('short_subtitle')] = new QueryButtonsView model: submeasure.getQueryForProvider(@providerId), providerId: @providerId
  itemContext: (submeasure) ->
    # console.log 'itemContext'
    isActive = submeasure is @currentSubmeasure
    queryView = new QueryButtonsView model: submeasure.getQueryForProvider(@providerId), isActive: isActive, providerId: @providerId
    _(super).extend active: isActive, queryView: queryView # @views[submeasure.get('short_subtitle')]

  setActiveSubmeasure: (submeasure) ->
    @currentSubmeasure = submeasure
    buttonViews = _(@children).values()
    _(buttonViews).each (view) -> view.setActive view.model.parent is @currentSubmeasure
    
  # appendItem: ->
  #   console.log 'a', arguments
  #   super
  # removeItem: ->
  #   console.log 'r', arguments
  #   super
  # updateItem: ->
  #   console.log 'u', arguments
  #   super
