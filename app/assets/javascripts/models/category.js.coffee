class Thorax.Models.Category extends Thorax.Model
  parse: (attrs) ->
    attrs = $.extend {}, attrs
    attrs.measures = new Thorax.Collections.Measures attrs.measures, parent: this, parse: true
    attrs

class Thorax.Collections.Categories extends Thorax.Collection
  model: Thorax.Models.Category
  comparator: (a, b) ->
    if a.get('category') is 'Core'
      -1
    else if b.get('category') is 'Core'
      1
    else
      a.get('category').localeCompare b.get('category')

  findMeasure: (id, subId) ->
    desiredMeasure = null
    @each (category) ->
      measure = category.get('measures').get(id)
      if measure?
        if subId?
          desiredMeasure = measure.get('submeasures').get(subId)
        else
          desiredMeasure = measure.get('submeasures').first()
        return
    desiredMeasure
