class Thorax.Views.ProviderView extends Thorax.View
  template: JST['providers/show']
  initialize: ->
    @dashboardView = new Thorax.Views.Dashboard provider_id: @model.id, collection: new Thorax.Collections.Categories PopHealth.categories, parse: true
    @providerChart = PopHealth.viz.providerChart()
  # Code for eventual partial replacement of
  # changeProvider: (event) ->
  #    providerId = $(event.currentTarget).attr("id") # selected ID
  #    @setModel(new Thorax.Models.Provider(_id: providerId))
  #    @dashboardView.remove()
  context: ->
    _(super).extend
      providerType: @model.providerType() || ""
      providerExtension: @model.providerExtension() || ""
  events:
    # 'click g': 'changeProvider'
    rendered: ->
      if @model.isPopulated()
        d3.select(@el).select("#providerChart").datum(@model.toJSON()).call(@providerChart)
        @$('.node').popover()

class Thorax.Views.ProvidersView extends Thorax.View
  tagName: 'table'
  className: 'table'
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
