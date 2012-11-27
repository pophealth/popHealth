class PopHealth.Filter extends Backbone.Model
  idAttribute: "_id"
  urlRoot: "/measures"
  destroy: ->
  select: ->
    measures = Backbone.sync("update", @, 
      url: "#{@url()}/select", 
      success: (response) ->
        PopHealth.selectedMeasures.add(response)       
    )
  unselect: ->
    measures = Backbone.sync("delete", @, 
      url: "#{@url()}/remove", 
      success: (response) =>
        measures = PopHealth.selectedMeasures.where(nqf_id: @id)
        PopHealth.selectedMeasures.remove(measures)      
    )
    

class PopHealth.FilterGroup extends Backbone.Collection
	model: PopHealth.Filter
	initialize: (models, options) ->
		@name = options.name