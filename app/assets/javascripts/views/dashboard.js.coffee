class Thorax.Views.ResultsView extends Thorax.View
  template: JST['dashboard/results']
  events:
    model:
      change: ->
        clearInterval(@timeout) if @timeout? and !@model.isLoading()
  performanceRate: -> @model.performanceRate()
  numerator: -> @model.numerator()
  denominator: -> @model.denominator()
  performanceDenominator: -> @model.performanceDenominator()
  initialize: ->
    unless @model.isPopulated()
      @timeout = setInterval =>
        @model.fetch()
      , 3000


class Thorax.Views.Dashboard extends Thorax.View
  template: JST['dashboard/index']
  events:
    rendered: ->
      @$("[rel='tooltip']").tooltip()
