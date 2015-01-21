class Thorax.Views.ProviderView extends Thorax.View
  template: JST['providers/show']
  initialize: ->
    @dashboardView = new Thorax.Views.Dashboard provider_id: @model.id, collection: new Thorax.Collections.Categories PopHealth.categories, parse: true
    if PopHealth.currentUser.shouldDisplayProviderTree() then @providerChart = PopHealth.viz.providerChart()
  context: ->
    _(super).extend
      providerType: @model.providerType() || ""
      providerExtension: @model.providerExtension() || ""
  events:
    rendered: ->
      if @model.isPopulated()
        d3.select(@el).select("#providerChart").datum(@model.toJSON()).call(@providerChart)
        @$('.node').popover()
    model:
      change: ->
          @dashboardView.filterEHMeasures(@model.providerType() == Config.ehExclusionType)


class Thorax.Views.ProvidersView extends Thorax.View
  template: JST['providers/index_layout']
  events:
    'keyup .provider-search' : 'search'
    'click .clear-search' : 'clearSearch'
  initialize: ->
    @providers = new Thorax.Views.ProvidersIndex collection: new Thorax.Collections.Providers
  search: (e) ->
    $sb = $(e.target)
    query = $.trim($sb.val())
    $(".providerTable tr").show() # show everything
    if query.length > 0
      $(".providerTable tbody tr:not(:containsi(#{query}))").hide()
    else
      $(".providerTable tr").show()

  clearSearch: (e) ->
    $sb = $(e.target).parent().prev('.provider-search')
    $sb.val('').trigger('keyup')

class Thorax.Views.ProvidersIndex extends Thorax.View
  tagName: 'table'
  className: "table providerTable"
  template: JST['providers/index']
  fetchTriggerPoint: 500 #Fetch data when we're 500 pixels away from the bottom
  itemContext: (model, index) ->
    _.extend {}, model.attributes, providerType: model.providerType() || "", providerExtension: model.providerExtension() || ""
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
