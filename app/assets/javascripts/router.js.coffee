class PopHealthRouter extends Backbone.Router
  initialize: ->
    # categories is defined globally in view
    @categories = new Thorax.Collections.Categories categories, parse: true
    @view = new Thorax.LayoutView el: '#container'

  routes:
    '':                                 'dashboard'
    'measures/:id(/:sub_id)':           'measure'
    'measures/:id(/:sub_id)/patients':  'patientsForMeasure'
    'patients/:id':                     'patient'
    'providers/:id':                    'provider'

  dashboard: ->
    @view.setView new Thorax.Views.Dashboard collection: @categories

  measure: (id, subId) ->
    # @view.setView yourView

  patientsForMeasure: (id, subId) ->
    # @view.setView yourView

  patient: (id) ->
    patientRecord = new Thorax.Models.Patient '_id': id
    # TODO Handle 404 case
    @view.setView new Thorax.Views.PatientView model: patientRecord

  provider: (id) ->
    providerModel = new Thorax.Models.Provider '_id': id
    # TODO Handle 404 case
    @view.setView new Thorax.Views.ProviderView model: providerModel

new PopHealthRouter()
Backbone.history.start()
