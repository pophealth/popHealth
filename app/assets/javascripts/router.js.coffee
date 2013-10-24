class PopHealthRouter extends Backbone.Router
  initialize: ->
    @measures = new Thorax.Collections.Measures()
    @view = new Thorax.LayoutView el: '#container'

  routes:
    '': 'dashboard'

  dashboard: ->
    @view.setView new Thorax.Views.Dashboard collection: @measures


new PopHealthRouter()
Backbone.history.start()
