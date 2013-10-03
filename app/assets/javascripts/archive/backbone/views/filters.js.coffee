class PopHealth.DemographicsFilterGroupView extends Backbone.View
	tagName: "li"
	className: "dropdown"
	render: ->
		@$el.html PopHealth.Templates["demographics"](label: @collection.name)
		@collection.each (filter) =>
			@$("ul").append new PopHealth.FilterView(model: filter).render().el
		@

class PopHealth.FilterView extends Backbone.View
	tagName: 'li'
	render: ->
		@$el.html PopHealth.Templates["selector"](filter: @model, selected: true)
		@
