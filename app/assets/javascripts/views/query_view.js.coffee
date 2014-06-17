class Thorax.Views.QueryView extends Thorax.View
  template: JST['patient_results/query']
  events:
    'click .population-btn': 'changeFilter'
    rendered: ->
      @$('.dial').knob()
      d3.select(@el).select('.pop-chart').datum(@model.result()).call(@popChart) if @model.isPopulated()

  ipp: -> @model.ipp()
  msrpopl: -> @model.msrpopl()
  observ: -> @model.observ()
  numerator: -> @model.numerator()
  denominator: -> @model.denominator()
  hasExceptions: -> @model.hasExceptions()
  exceptions: -> @model.exceptions()
  hasExclusions: -> @model.hasExclusions()
  exclusions: -> @model.exclusions()
  hasOutliers: -> @model.hasOutliers()
  outliers: -> @model.outliers()
  performanceRate: -> @model.performanceRate()
  performanceDenominator: -> @model.performanceDenominator()
  episode_of_care: -> @model.parent.get('episode_of_care')
  continuous_variable: -> @model.parent.get('continuous_variable')
  initialize: ->
    @currentPopulation = 'IPP'
    @popChart = PopHealth.viz.populationChart().width(125).height(40).maximumValue(PopHealth.patientCount)
    @model.set 'providers', [@providerId] if @providerId

  changeFilter: (event) ->
    @currentPopulation = event.currentTarget.id
    @parent.getView().changeFilter @currentPopulation
    # FIXME bootstrap can manage this for us /->
    $('.population-btn.active').removeClass 'active'
    $(event.currentTarget).addClass 'active'
