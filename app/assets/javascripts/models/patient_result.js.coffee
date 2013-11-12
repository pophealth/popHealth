class Thorax.Models.PatientResult extends Thorax.Model
  formatted_birthdate: -> moment(@get('birthdate')).format('MM/DD/YYYY') if @get('birthdate')
  parse: (attrs) ->
    # JSON that comes back is in the MongoDB M/R created format
    # We only want to work with the properties in value
    attrs.value

class Thorax.Collections.PatientResults extends Thorax.Collection
  model: Thorax.Models.PatientResult
  url: -> "#{@parent.url()}/patient_results"
  initialize: (attrs, options) -> @parent = options.parent