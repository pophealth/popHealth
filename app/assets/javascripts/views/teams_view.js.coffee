# This view is the index of team names with links to provider measures list
class Thorax.Views.TeamListView extends Thorax.View
  id: 'team_list_table'
  tagName: 'table'
  className: 'table'
  template: JST['teams/index']
  fetchTriggerPoint: 500 # fetch data when we're 500 pixels away from the bottom
  teamContext: (team) ->
    _(team.toJSON()).extend 
      measure_id: @submeasure.get 'hqmf_id'
      sub_id: (@submeasure.get('query')).get 'sub_id'
      provider_id: @provider_id
  events:
    rendered: ->
      $(document).on 'scroll', @scrollHandler

# This is the layout with the team header and provider measures list
class Thorax.Views.TeamMeasuresView extends Thorax.View
  template: JST['teams/layout']  
  context: ->
    team_id = @model.get '_id'
    providerCollection = new Thorax.Collections.TeamProviders 
    providerCollection.url = "/api/teams/team_providers/#{team_id}"
    
    submeasure = new Thorax.CollectionView
      collection: providerCollection
      itemView: (item) => new Thorax.Views.TeamSubmeasureView model: item.model, submeasure: @submeasure
    _(super).extend 
      submeasure: submeasure
      measureId: @submeasure.get('id')
      sub_id: @submeasure.get('sub_id')
      effectiveDate: @submeasure.effectiveDate

# This view displays the provider's name and NPI, with the measure results
class Thorax.Views.TeamSubmeasureView extends Thorax.View
  template: JST['teams/submeasure']
  className: 'measure'
  options:
    fetch: true
  context: ->
    _(super).extend
      providerExtension: @model.providerExtension() || ""
      teamResultsView: new Thorax.Views.TeamResultsView model: @submeasure.getQueryForProvider(@model.get '_id'), provider_id: @model.get '_id'
      
# This view displays the measure results for a given provider
class Thorax.Views.TeamResultsView extends Thorax.View
  template: JST['teams/results']
  options:
    fetch: true
  events:
    model:
      change: ->
        loadingDiv = "." + "p-" + String(@model.get('filters').providers) + "-loading-measure"
        if @model.isPopulated()
          $(loadingDiv).hide()
          clearInterval(@timeout) if @timeout?
          d3.select(@el).select('.pop-chart').datum(_(lower_is_better: @lower_is_better).extend @model.result()).call(@popChart)
        else
          $(loadingDiv).show()
          @timeout ?= setInterval =>
            @model.fetch()
          , 3000
    rendered: ->
      @$('.dial').knob()
      unless @model.isPopulated()
        @$el.fadeTo 'fast', 0.5
        @listenTo @model, 'change:status', =>
          if @model.isPopulated()
            @$el.fadeTo 'fast', 1
            @stopListening @model, 'change:status'
      if @model.isPopulated()
        if PopHealth.currentUser.populationChartScaledToIPP() then @popChart.maximumValue(@model.result().IPP) else @popChart.maximumValue(PopHealth.patientCount)
        d3.select(@el).select('.pop-chart').datum(_(lower_is_better: @lower_is_better).extend @model.result()).call(@popChart)
        @$('rect').popover()
    destroyed: ->
      clearInterval(@timeout) if @timeout?
  context: ->
    _(super).extend     
      unit: if @model.isContinuous() and @model.parent.get('cms_id') isnt 'CMS179v2' then 'min' else '%'
      resultValue: if @model.isContinuous() then @model.observation() else @model.performanceRate()
      fractionTop: if @model.isContinuous() then @model.measurePopulation() else @model.numerator()
      fractionBottom: if @model.isContinuous() then @model.ipp() else @model.performanceDenominator()
  initialize: ->
    @popChart = PopHealth.viz.populationChart().width(125).height(25).maximumValue(PopHealth.patientCount)
