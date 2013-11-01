class Thorax.Models.PatientResult extends Thorax.Model

class Thorax.Collections.PatientResults extends Thorax.Collection
  model: Thorax.Models.PatientResult
  url: -> "#{@parent.url()}/patient_results"
  initialize: (attrs, options) -> @parent = options.parent