class Thorax.Models.Category extends Thorax.Model
  parse: (attrs) ->
    attrs = $.extend {}, attrs
    @effectiveDate = @collection?.effectiveDate #|| attrs.effectiveDate
    @effectiveStartDate = @collection?.effectiveStartDate
    @effectiveEndDate = @collection?.effectiveEndDate
    attrs.measures = new Thorax.Collections.Measures attrs.measures, parent: this, parse: true #, effectiveDate: effectiveDate
    attrs

class Thorax.Collections.Categories extends Thorax.Collection
  model: Thorax.Models.Category
  initialize: (models, options) ->
    @effectiveDate = options?.effectiveDate 
    @effectiveStartDate = options?.effectiveStartDate 
    @effectiveEndDate = options?.effectiveEndDate 

  comparator: (a, b) ->
    if a.get('category') is 'Core'
      -1
    else if b.get('category') is 'Core'
      1
    else
      a.get('category').localeCompare b.get('category')

  findMeasure: (id) ->
    for category in @models
      return measure if measure = category.get('measures').findWhere(hqmf_id: id)

  # finds a submeasure with the given hqmf id and subId. If subId is omitted (as
  # in the case of a measure without submeasures), it'll return the first
  # submeasure present
  findSubmeasure: (id, subId) ->
    desiredMeasure = null
    @each (category) ->
      measure = category.get('measures').findWhere(hqmf_id: id)
      if measure?
        if subId?
          desiredMeasure = measure.get('submeasures').get(subId)
        else
          desiredMeasure = measure.get('submeasures').first()
        return
    desiredMeasure
