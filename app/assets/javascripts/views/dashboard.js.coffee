class Thorax.Views.ResultsView extends Thorax.View
  template: JST['dashboard/results']
  events:
    model:
      change: ->
        clearInterval(@timeout) if @timeout? and !@model.isLoading()
    rendered: ->
      @$(".dial").knob()

  performanceRate: -> @model.performanceRate()
  numerator: -> @model.numerator()
  denominator: -> @model.denominator()
  performanceDenominator: -> @model.performanceDenominator()
  initialize: ->
    unless @model.isPopulated()
      @timeout = setInterval =>
        @model.fetch()
      , 3000

class Thorax.Views.DashboardSubmeasureView extends Thorax.View
  events:
    rendered: ->
      query = @model.get('query')
      unless query.isPopulated()
        @$el.fadeTo 'fast', 0.5
        query.on 'change:status', =>
          if query.isPopulated()
            @$el.fadeTo 'fast', 1
            query.off 'change:status'



class Thorax.Views.Dashboard extends Thorax.View
  template: JST['dashboard/index']
  events:
    rendered: ->
      @$("[rel='tooltip']").tooltip()

  initialize: ->
    selectedIds = _(PopHealth.currentUser.selected_measures).map (m) -> m.id
    @selectedCategories = new Thorax.Collections.Categories
    @collection.each (cat) =>
      selectedMeasures = cat.get('measures').select (m) => _(selectedIds).contains m.id
      if selectedMeasures.length
        m.set('selected', true) for m in selectedMeasures
        selectedCategory = cat.clone()
        selectedCategory.set 'measures', new Thorax.Collections.Measures selectedMeasures
        @selectedCategories.add selectedCategory
