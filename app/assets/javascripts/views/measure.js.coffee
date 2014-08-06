class Thorax.Views.MeasureView extends Thorax.LayoutView
  id: 'measureSummary'
  template: JST['measures/show']
  initialize: ->
    submeasures = @submeasure.collection
    @sidebarView = if submeasures.length > 1
      new Thorax.Views.MultiQueryView model: @submeasure, submeasures: submeasures, providerId: @provider_id
    else
      new Thorax.Views.QueryView model: @submeasure.getQueryForProvider(@provider_id), providerId: @provider_id

  context: ->
    _(super).extend @submeasure.toJSON(), measurementPeriod: moment(Config.effectiveDate * 1000).format('YYYY')

  changeFilter: (submeasure, population) ->
    if submeasure isnt @submeasure
      @submeasure = submeasure
      @sidebarView.changeSubmeasure submeasure
      view = @getView()
      url = "measures/#{submeasure.collection.parent.id}/#{submeasure.id}/providers/#{@provider_id}"
      if @logicIsActive()
        view.setModel @submeasure, render: true
      else
        url += '/patient_results'
        view.setQuery @submeasure.getQueryForProvider @provider_id
      PopHealth.router.navigate url
    @getView().changeFilter population

  activateLogicView: ->
    view = new Thorax.Views.LogicView model: @submeasure
    view.changeFilter @sidebarView.currentPopulation
    @setView view

  activatePatientResultsView: (providerId) ->
    @provider_id = providerId
    view = new Thorax.Views.PatientResultsLayoutView query: @submeasure.getQueryForProvider(providerId), providerId: providerId
    view.changeFilter @sidebarView.currentPopulation
    @setView view

  logicIsActive: -> if view = @getView() then view instanceof Thorax.Views.LogicView else @viewType is 'logic'
  patientResultsIsActive: -> if view = @getView() then view instanceof Thorax.Views.PatientResultsLayoutView else @viewType is 'patient_results'
