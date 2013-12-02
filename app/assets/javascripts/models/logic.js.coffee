class Thorax.Models.Population extends Thorax.Model
  parse: (attrs) ->
    if attrs.preconditions?
      attrs.preconditions = new Thorax.Collections.Preconditions attrs.preconditions, parent: this, parse: true
    attrs

class Thorax.Models.Precondition extends Thorax.Model
  submeasure: ->
    obj = this
    until obj instanceof Thorax.Models.Submeasure
      obj = (obj.collection or obj).parent
    obj
  reference: ->
    id = @get('reference')
    @submeasure().get('data_criteria').get(id)
  parse: (attrs) ->
    if attrs.preconditions?
      attrs.preconditions = new Thorax.Collections.Preconditions attrs.preconditions, parent: this, parse: true
    attrs

class Thorax.Collections.Preconditions extends Thorax.Collection
  model: Thorax.Models.Precondition
  conjunctionMap:
    allTrue: 'and'
    atLeastOneTrue: 'or'
  initialize: (models, options) -> @parent = options.parent
  conjunction: -> @conjunctionMap[@parent.get('conjunction_code')]


class Thorax.Models.DataCriteria extends Thorax.Model
  parse: (attrs) ->
    if attrs.temporal_references?
      attrs.temporal_references = new Thorax.Collections.TemporalReferences attrs.temporal_references, parent: this, parse: true
    if attrs.children_criteria?
      cc = ({id: id} for id in attrs.children_criteria)
      attrs.children_criteria = new Thorax.Collections.ChildCriteria cc, parent: this, parse: true
    if attrs.value?
      attrs.value = new Thorax.Models.Range attrs.value, parse: true
    if attrs.subset_operators?
      attrs.subset_operators = new Thorax.Collections.SubsetOperators attrs.subset_operators, parse: true
    if attrs.field_values?
      fieldValues = for key, value of attrs.field_values
        {id: key, value: value}
      attrs.field_values = new Thorax.Collections.FieldValues fieldValues, parse: true
    attrs

class Thorax.Collections.DataCriteria extends Thorax.Collection
  model: Thorax.Models.DataCriteria

class Thorax.Models.ChildCriteria extends Thorax.Models.DataCriteria
  # have to define #get instead of referencing the original dataCriteria because the ChildCriteria is created within DataCriteria#parse
  dataCriteria: -> @collection.parent.collection.get @id
  get: (attribute) -> @dataCriteria().get attribute
  toJSON: -> @dataCriteria().toJSON()


class Thorax.Collections.ChildCriteria extends Thorax.Collection
  model: Thorax.Models.ChildCriteria
  initialize: (models, options) -> @parent = options.parent


class Thorax.Models.TemporalReference extends Thorax.Model
  reference: ->
    reference = @get 'reference'
    if reference isnt 'MeasurePeriod'
      dataCriteria = @collection.parent.collection
      reference = dataCriteria.get reference
    reference
  parse: (attrs) ->
    if attrs.range?
      attrs.range = new Thorax.Models.Range attrs.range, parse: true
    attrs


class Thorax.Collections.TemporalReferences extends Thorax.Collection
  model: Thorax.Models.TemporalReference
  initialize: (models, options) -> @parent = options.parent


class Thorax.Models.Range extends Thorax.Model
  parse: (attrs) ->
    if attrs.high?
      attrs.high = new Thorax.Models.Value attrs.high, parse: true
    if attrs.low?
      attrs.low = new Thorax.Models.Value attrs.low, parse: true
    attrs

class Thorax.Models.Value extends Thorax.Model


class Thorax.Models.SubsetOperator extends Thorax.Model
  parse: (attrs) ->
    if attrs.value?
      klass = if attrs.value.type is 'IVL_PQ' then Thorax.Models.Range else Thorax.Models.Value
      attrs.value = new klass attrs.value, parse: true
    attrs

class Thorax.Collections.SubsetOperators extends Thorax.Collection
  model: Thorax.Models.SubsetOperator

class Thorax.Models.FieldValue extends Thorax.Model
  parse: (attrs) ->
    if attrs.value?
      klass = if attrs.value.type is 'IVL_PQ' then Thorax.Models.Range else Thorax.Models.Value
      attrs.value = new klass attrs.value, parse: true
    attrs

class Thorax.Collections.FieldValues extends Thorax.Collection
  model: Thorax.Models.FieldValue
