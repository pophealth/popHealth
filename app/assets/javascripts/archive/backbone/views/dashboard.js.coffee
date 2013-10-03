class PopHealth.CategoryView extends Backbone.View
  initialize: (options) ->
    @category = options.category
  className: 'category'
  attributes:
    style: "display:none"
  render: ->
    @$el.html("<h4 class=\"category-title\">#{@category}</h4>")
    @
class PopHealth.CategorizedMeasuresView extends Backbone.View
  id: "measures"
  className: "row-fluid"
  initialize: (options) ->
    @categories = _.reduce options.categories, (memo, cat) ->
      memo[cat] = new PopHealth.CategoryView(category: cat)
      memo
    , {}
    options.collection.on "add", @select, @
    options.collection.on "remove", @unselect, @
  select: (measure) ->
    view = @categories[measure.get('category')]
    view.$el.show()
    mView = new PopHealth.MeasureView(model: measure, id: "measure-#{measure.get('nqf_id')}")
    view.$el.append(mView.render().el)
  unselect: (measure) ->
    view = @category(measure)
    view.$el.find("h4.category-title:only-child").parent().hide()
    # if !?
      # console.log("empty")
  category: (measure) ->
    @categories[measure.get('category')]
  render: ->
    views = _.values(@categories)
    _.each views, (cat) =>
      @$el.append(cat.render().el)
    @collection.each (measure) => @select(measure)
    @
class PopHealth.MeasureView extends Backbone.View
  className: "measure row-fluid"
  initialize: ->
    @model.on "change", @render, @
    @model.on "remove", @remove, @
  render: ->
    @$el.html(PopHealth.Templates['measure'](measure: @model))
    @