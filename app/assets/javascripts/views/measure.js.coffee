class SubmeasureView extends Thorax.View
  template: JST['measures/submeasure']
  context: ->
    _(super).extend measurementPeriod: moment(PopHealth.currentUser.get 'effective_date' * 1000).format('YYYY')
  logicIsActive: -> @parent.logicIsActive()
  patientResultsIsActive: -> @parent.patientResultsIsActive()
  teamMeasuresIsActive: -> @parent.teamMeasuresIsActive() or @parent.teamListIsActive()
  effectiveDate: -> PopHealth.currentUser.get 'effective_date'

class Thorax.Views.MeasureView extends Thorax.LayoutView
  id: 'measureSummary'
  template: JST['measures/show']
  initialize: ->
    submeasures = @submeasure.collection
    @sidebarView = if submeasures.length > 1
      new Thorax.Views.MultiQueryView model: @submeasure, submeasures: submeasures, providerId: @provider_id
    else
      new Thorax.Views.QueryView model: @submeasure.getQueryForProvider(@provider_id), providerId: @provider_id
    @submeasureView = new SubmeasureView model: @submeasure, provider_id: @provider_id

  context: ->
    _(super).extend @submeasure.toJSON(), measurementPeriod: moment(PopHealth.currentUser.get 'effective_date' * 1000).format('YYYY')

  changeFilter: (submeasure, population) ->
    if submeasure isnt @submeasure
      @submeasure = submeasure
      @submeasureView.setModel @submeasure
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

  activateTeamListView: ->
    view = new Thorax.Views.TeamListView submeasure: @submeasure, provider_id: @provider_id, collection: new Thorax.Collections.Teams 
    @setView view
    
  activateLogicView: ->
    view = new Thorax.Views.LogicView model: @submeasure
    view.changeFilter @sidebarView.currentPopulation
    @setView view

  activateTeamMeasuresView: (team) ->
    view = new Thorax.Views.TeamMeasuresView model: team, submeasure: @submeasure
    @setView view

  activatePatientResultsView: (providerId) ->
    @provider_id = providerId
    view = new Thorax.Views.PatientResultsLayoutView query: @submeasure.getQueryForProvider(providerId), providerId: providerId
    view.changeFilter @sidebarView.currentPopulation
    @setView view

  teamListIsActive: -> if view = @getView() then view instanceof Thorax.Views.TeamListView else @viewType is 'team_list'
  
  teamMeasuresIsActive: -> if view = @getView() then view instanceof Thorax.Views.TeamMeasuresView else @viewType is 'team_measures'

  logicIsActive: -> if view = @getView() then view instanceof Thorax.Views.LogicView else @viewType is 'logic'
  patientResultsIsActive: -> if view = @getView() then view instanceof Thorax.Views.PatientResultsLayoutView else @viewType is 'patient_results'
