class Thorax.Models.Measure extends Thorax.Model
  parse: (attrs) ->
    data = _(attrs).omit 'subs', 'sub_ids'
    subs = for sub in attrs.subs
      subData = _(sub).extend(data)
      subData.isPrimary = !sub.sub_id? or sub.sub_id is 'a'
      subData
    attrs.submeasures = new SubCollection subs, parent: this
    attrs

class Thorax.Collections.Measures extends Thorax.Collection
  model: Thorax.Models.Measure

class Submeasure extends Thorax.Model
  idAttribute: 'sub_id'
  url: -> "/api/measures/#{@get('id')}"
  fetch: (options = {}) ->
    options.data = {sub_id: @id} unless options.data?
    super(options)    

class SubCollection extends Thorax.Collection
  model: Submeasure
  initialize: (models, options) -> @parent = options.parent