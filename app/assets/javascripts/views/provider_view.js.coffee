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
  events:
    # 'click g': 'changeProvider'
    rendered: ->
      if @model.isPopulated() 
        d3.select("#providerChart").datum(@model.toJSON()).call(@providerChart)
        @$('.node').popover()

class Thorax.Views.ProvidersView extends Thorax.View
  tagName: 'table'
  className: 'table'
  template: JST['providers/index']
