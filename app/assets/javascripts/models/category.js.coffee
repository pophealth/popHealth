class Thorax.Models.Category extends Thorax.Model
  parse: (attrs) ->
    # WARNING this modifies attrs in place, consider `attrs = $.extend {}, attrs` to make a deep copy
    attrs.measures = new Thorax.Collections.Measures attrs.measures, parse: true
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
