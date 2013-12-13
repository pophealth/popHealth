class Thorax.Views.MeasureView extends Thorax.LayoutView
  id: 'measureSummary'
  template: JST['measures/show']
  initialize: ->
    @queryView = new Thorax.Views.QueryView model: @measure.get('query')

  context: ->
    _(super).extend @measure.toJSON(), measurementPeriod: moment(Config.effectiveDate * 1000).format('YYYY')

  activateLogicView: ->
    view = new Thorax.Views.LogicView model: @measure
    view.changeFilter @queryView.currentPopulation
    @setView view

  activatePatientResultsView: ->
    view = new Thorax.Views.PatientResultsLayoutView query: @measure.get('query')
    view.changeFilter @queryView.currentPopulation
    @setView view

  logicIsActive: -> if view = @getView() then view instanceof Thorax.Views.LogicView else @type is 'logic'
  patientResultsIsActive: -> if view = @getView() then view instanceof Thorax.Views.PatientResultsLayoutView else @type is 'patient_results'
