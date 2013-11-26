class Thorax.Models.PatientResult extends Thorax.Model
  parse: (attrs) ->
    # JSON that comes back is in the MongoDB M/R created format
    # We only want to work with the properties in value
    attrs.value

class Thorax.Collections.PatientResults extends Thorax.Collection
  model: Thorax.Models.PatientResult
  url: -> "#{@parent.url()}/patient_results"
  initialize: (attrs, options) ->
    @parent = options.parent
    @page = 1
  fetchNextPage: (options = {perPage: 10}) ->
    @fetch remove: false, data: {page: ++@page, per_page: options.perPage}
