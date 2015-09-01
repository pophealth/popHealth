window.PopHealth ||= {}
class PopHealth.Router extends Backbone.Router
  initialize: ->
    # categories is defined globally in view
    @categories = new Thorax.Collections.Categories PopHealth.categories, parse: true, effectiveDate: PopHealth.currentUser.get 'effective_date'
    @view = new Thorax.LayoutView el: '#container'

  routes:
    '':                                                                 'dashboard'
    'measures/:id(/:sub_id)(/providers/:provider_id)/patient_results':  'patientResultsForMeasure'
    'measures/:id(/:sub_id)(/providers/:provider_id)':                  'measure'
    'patients/:id':                                                     'patient'
    'providers(/:id)':                                                  'provider'
    'admin/measures':                                                   'admin_measures'
    'measures/:id(/:sub_id)(/providers/:provider_id)/teams(/:team_id)': 'teams'
  
  dashboard: ->
    if Config.OPML
      @view.setView new Thorax.Views.ProviderView model: PopHealth.rootProvider
    else
      if PopHealth.currentUser.get("admin") or PopHealth.currentUser.get("provider_id") != null
        providerModel = new Thorax.Models.Provider '_id': PopHealth.currentUser.get("provider_id")
        @view.setView new Thorax.Views.ProviderView model: providerModel
      else
        practice = PopHealth.currentUser.get('practice')
        if practice != null
          providerModel = new Thorax.Models.Provider '_id': practice.provider_id
          @view.setView new Thorax.Views.ProviderView model: providerModel

  teams: (id, subId, providerId, teamId) ->
    submeasure = @categories.findSubmeasure(id, subId)
    view = new Thorax.Views.MeasureView submeasure: submeasure, provider_id: providerId, viewType: 'team_measures' 
    @view.setView view
    if teamId? 
      team = new Thorax.Models.Team '_id': teamId 
      view.activateTeamMeasuresView(team)
    else
      view.activateTeamListView()
   
  measure: (id, subId, providerId) ->
    measure = @categories.findMeasure(id)
    submeasure = @categories.findSubmeasure(id, subId)
    currentView = @view.getView()
    unless currentView instanceof Thorax.Views.MeasureView and currentView.measure is submeasure
      currentView = new Thorax.Views.MeasureView submeasure: submeasure, viewType: 'logic', provider_id: providerId
      @view.setView currentView
    currentView.activateLogicView()

  patientResultsForMeasure: (id, subId, providerId) ->
    submeasure = @categories.findSubmeasure(id, subId)
    currentView = @view.getView()
    unless currentView instanceof Thorax.Views.MeasureView and currentView.measure is submeasure
      currentView = new Thorax.Views.MeasureView submeasure: submeasure, viewType: 'patient_results', provider_id: providerId
      @view.setView currentView
    currentView.activatePatientResultsView(providerId)

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
      @view.setView new Thorax.Views.ProvidersView

  admin_measures: ->
    @view.setView new Thorax.Views.MeasuresAdminView collection: new Thorax.Collections.Measures

