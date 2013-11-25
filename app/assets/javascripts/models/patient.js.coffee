class Thorax.Models.Patient extends Thorax.Model
  urlRoot: '/api/patients'
  idAttribute: '_id'
  parse: (attrs) ->
    attrs = $.extend {}, attrs
    all_events = _.compact(_.union(attrs.procedures, attrs.encounters, attrs.conditions, attrs.results))
    attrs.events = new Thorax.Collections.Events all_events, parse: true, comparator: 'start_time'
    attrs

class Thorax.Collections.Events extends Thorax.Collection
  model: Thorax.Models.Event
  # initialize: (models, options) -> @parent = options.parent

class Thorax.Models.Event extends Thorax.Model
  initialize: ->
    @start = format_time(@start_time)
    @end = format_time(@end_time)

  format_time: (time) -> moment(time).format('MM-DD-YYYY') if time