class Thorax.Views.LogicView extends Thorax.View
  template: JST['measures/logic']
  initialize: ->
    console.log @model.cid
    @model.isPopulated = -> @has 'IPP'
    @layout = new Thorax.Views.LogicLayoutView measure: @model
  changeFilter: (population) ->
    @population = population
    @reloadPopulation() if @model.isPopulated()

  reloadPopulation: ->
    population = @model.get @population
    view = if population.has 'preconditions'
      new Thorax.Views.PreconditionView model: population.get('preconditions').first()
    else
      console.log @population
      new Thorax.Views.EmptyPopulationView population: @population
    @layout.setView view
  events:
    model:
      change: -> @reloadPopulation()
    rendered: -> console.log 'logic rendered!', @model.isPopulated()
    activated: -> console.log 'logic activated!', @model.isPopulated()

class Thorax.Views.LogicLayoutView extends Thorax.LayoutView

class Thorax.Views.EmptyPopulationView extends Thorax.View
  template: JST['measures/empty_preconditions']
  className: 'text-muted'
  isDenominator: -> @population is 'DENOM'
