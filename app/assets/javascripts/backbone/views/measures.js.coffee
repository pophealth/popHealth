class PopHealth.MeasureSelectorGroupView extends Backbone.View
  events:
    "click a": "toggle"
  toggle: ->
    @$el.children("ul").collapse("toggle")
    @$el.find("a i").toggleClass("icon-circle-arrow-right icon-circle-arrow-down")
  render: ->
    @$el.html "<a><i class=\"icon-circle-arrow-right\"></i> #{@collection.name}</a>"
    @$el.append "<ul class=\"collapse\">"
    @collection.each (filter) =>
      selected =  @options.selected.find (m) -> m.get('nqf_id') == filter.id
      @$("ul").append new PopHealth.MeasureSelectorView(model: filter, selected: selected?).render().el
    @

class PopHealth.MeasureSelectorView extends Backbone.View
  events:
    "change": "toggle"
  tagName: "li"
  toggle: ->
    if @$el.find("input:checkbox").is(':checked')
      @model.select()
    else
      @model.unselect()
  className: "selector"
  render: ->
    @$el.html PopHealth.Templates["selector"](filter: @model, selected: @options.selected)
    @