class Thorax.Views.MeasureView extends Thorax.LayoutView
  id: 'measureSummary'
  template: JST['measures/show']
  initialize: ->
    @queryView = new Thorax.Views.QueryView model: @measure.getQueryForProvider(@provider_id), providerId: @provider_id

  context: ->
    _(super).extend @measure.toJSON(), measurementPeriod: moment(Config.effectiveDate * 1000).format('YYYY')

  activateLogicView: ->
    view = new Thorax.Views.LogicView model: @measure
    view.changeFilter @queryView.currentPopulation
    @setView view

  activatePatientResultsView: (providerId) ->
    view = new Thorax.Views.PatientResultsLayoutView query: @measure.getQueryForProvider(providerId), providerId: providerId
    view.changeFilter @queryView.currentPopulation
    @setView view

  logicIsActive: -> if view = @getView() then view instanceof Thorax.Views.LogicView else @view_type is 'logic'
  patientResultsIsActive: -> if view = @getView() then view instanceof Thorax.Views.PatientResultsLayoutView else @view_type is 'patient_results'
