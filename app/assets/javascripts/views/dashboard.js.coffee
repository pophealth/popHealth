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

  initialize: ->
    selectedIds = _(currentUser.selected_measures).map (m) -> m.id
    @selectedCategories = new Thorax.Collections.Categories
    @collection.each (cat) =>
      selectedMeasures = cat.get('measures').select (m) => _(selectedIds).contains m.id
      if selectedMeasures.length
        m.set('selected', true) for m in selectedMeasures
        selectedCategory = cat.clone()
        selectedCategory.set 'measures', new Thorax.Collections.Measures selectedMeasures
        @selectedCategories.add selectedCategory
