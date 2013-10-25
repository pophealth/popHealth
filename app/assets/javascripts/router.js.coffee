class PopHealthRouter extends Backbone.Router
  initialize: ->
    # categories is defined globally in view
    @categories = new Thorax.Collections.Categories categories, parse: true
    @view = new Thorax.LayoutView el: '#container'

  routes:
    '':                       'dashboard'
    'measures/:id(/:sub_id)': 'measure'

  dashboard: ->
    @view.setView new Thorax.Views.Dashboard collection: @categories

  measure: (id, subId) ->
    # @view.setView yourView

new PopHealthRouter()
Backbone.history.start()
