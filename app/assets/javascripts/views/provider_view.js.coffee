class Thorax.Views.ProviderView extends Thorax.View
  template: JST['providers/show']
  initialize: ->
    @dashboardView = new Thorax.Views.Dashboard provider_id: @model.id, collection: new Thorax.Collections.Categories PopHealth.categories, parse: true

class Thorax.Views.ProvidersView extends Thorax.View
  tagName: 'table'
  className: 'table'
  template: JST['providers/index']
