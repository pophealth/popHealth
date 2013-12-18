class Thorax.Views.LogicView extends Thorax.View
  template: JST['measures/logic']
  initialize: ->
    @layout = new Thorax.Views.LogicLayoutView measure: @model
  changeFilter: (population) ->
    @population = population
    @reloadPopulation() if @model.isPopulated()

  reloadPopulation: ->
    population = @model.get @population
    view = if population?.has 'preconditions'
      new Thorax.Views.PreconditionView model: population.get('preconditions').first()
    else
      new Thorax.Views.EmptyPopulationView population: @population
    @layout.setView view
  events:
    model:
      change: -> @reloadPopulation()

class Thorax.Views.LogicLayoutView extends Thorax.LayoutView

# not sure if there's a better way to do this
class Thorax.Views.EmptyPopulationView extends Thorax.View
  template: JST['measures/empty_preconditions']
  className: 'text-muted'
  isDenominator: -> @population is 'DENOM'
