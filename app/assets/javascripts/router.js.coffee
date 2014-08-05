window.PopHealth ||= {}
class PopHealth.Router extends Backbone.Router
  initialize: ->
    # categories is defined globally in view
    @categories = new Thorax.Collections.Categories PopHealth.categories, parse: true
    @view = new Thorax.LayoutView el: '#container'

  routes:
    '':                                                                 'dashboard'
    'measures/:id(/:sub_id)(/providers/:provider_id)/patient_results':  'patientResultsForMeasure'
    'measures/:id(/:sub_id)(/providers/:provider_id)':                  'measure'
    'patients/:id':                                                     'patient'
    'providers(/:id)':                                                  'provider'
    'admin/measures':                                                   'admin_measures'

  dashboard: ->
    @view.setView new Thorax.Views.ProviderView model: PopHealth.rootProvider

  measure: (id, subId, providerId) ->
    measure = @categories.findMeasure(id, subId)
    measureView = @view.getView()
    unless measureView instanceof Thorax.Views.MeasureView and measureView.measure is measure
      measureView = new Thorax.Views.MeasureView measure: measure, view_type: 'logic', provider_id: providerId
      @view.setView measureView
    measureView.activateLogicView()

  patientResultsForMeasure: (id, subId, providerId) ->
    measure = @categories.findMeasure(id, subId)
    if measure?
      measureView = @view.getView()
      unless measureView instanceof Thorax.Views.MeasureView and measureView.measure is measure
        measureView = new Thorax.Views.MeasureView measure: measure, view_type: 'patient_results', provider_id: providerId
        @view.setView measureView
      measureView.activatePatientResultsView(providerId)
    else
      console?.log 'Measure not found'

  patient: (id) ->
    patientRecord = new Thorax.Models.Patient '_id': id
    # TODO Handle 404 case
    @view.setView new Thorax.Views.PatientView model: patientRecord

  provider: (id) ->
    if id?
      providerModel = new Thorax.Models.Provider '_id': id
      # TODO Handle 404 case
      @view.setView new Thorax.Views.ProviderView model: providerModel
    else
      providerCollection = new Thorax.Collections.Providers
      @view.setView new Thorax.Views.ProvidersView collection: providerCollection

  admin_measures: ->
    @view.setView new Thorax.Views.MeasuresAdminView 

