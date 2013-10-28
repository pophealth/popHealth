class PopHealthRouter extends Backbone.Router
  initialize: ->
    # categories is defined globally in view
    @categories = new Thorax.Collections.Categories categories, parse: true
    @view = new Thorax.LayoutView el: '#container'

  routes:
    '':                                 'dashboard'
    'measures/:id(/:sub_id)':           'measure'
    'measures/:id(/:sub_id)/patients':  'patientsForMeasure'

  dashboard: ->
    @view.setView new Thorax.Views.Dashboard collection: @categories

  measure: (id, subId) ->
    # @view.setView yourView

  patientsForMeasure: (id, subId) ->
    # @view.setView yourView

new PopHealthRouter()
Backbone.history.start()
